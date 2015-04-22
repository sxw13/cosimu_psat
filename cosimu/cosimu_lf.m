function  ResultData = cosimu_lf(Config, CurrentStatus, ResultData)
global Fig Settings Snapshot Hdl
global Bus File DAE Theme OMIB
global SW PV PQ Fault Ind Syn Exc Tg
global Varout Breaker Line Path clpsat

% ================================================================
% ----------------------------------------------------------------
% Main loop
% ----------------------------------------------------------------
% ================================================================
h = Settings.tstep;
t = 0;
nHour = 1;
load([Config.loadShapeFile, num2str(nHour)]);
loadshape = hourDataNew;
nPointOfLoadShape = 0;
sizeOfLoadShape = length(loadshape);

% time vector of snapshots, faults and breaker events
fixed_times = [];

fixed_times = [fixed_times; gettimes(Fault); ...
    gettimes(Breaker); gettimes(Ind)];
fixed_times = sort(fixed_times);


while (t < Settings.tf)
    
    %% one step integration
    if (t + h > Settings.tf), h = Settings.tf - t; end
    actual_time = t + h;
   
    DAE.t = actual_time;
    
    % applying faults, breaker interventions and perturbations
    if ~isempty(fixed_times)
        if ~isempty(find(abs(fixed_times - t) < 1e-3))
            disp(['intervention time as ', num2str(t)]);
            Fault = intervention(Fault,t);
            Breaker = intervention(Breaker,t);
            %% add some code to deal with the optimal powerflow model
            lineIdx = ResultData.allLineIdx(Breaker.line);
            CurrentStatus.branch(lineIdx, 11) = Breaker.u;
        end
    end
    
    if Config.enableLoadShape == 1
        %% increase the load acording the loadshape
        nPointOfLoadShape = nPointOfLoadShape + 1;
        
        if nPointOfLoadShape > sizeOfLoadShape
            nHour = nHour + 1;
            % modified by sxw
            nHour = mod(nHour-1,24)+1;
            % end of modification
            load([Config.loadShapeFile, num2str(nHour)]);
            loadshape = hourDataNew;
            nPointOfLoadShape = 1;
            sizeOfLoadShape = length(loadshape);
        end
        PQ.con(:, [4, 5]) = loadshape(nPointOfLoadShape) * ResultData.loadBase;
        if isfield(Config,'LoadShapeRatio')
            PQtemp = PQ.con(:, [4, 5]);ratiotemp = Config.LoadShapeRatio;
            PQ.con(:, [4, 5]) = ratiotemp * PQtemp;
            ResultData.loadRatioHis = [ResultData.loadRatioHis loadshape(nPointOfLoadShape)*Config.LoadShapeRatio];
        else 
            ResultData.loadRatioHis = [ResultData.loadRatioHis loadshape(nPointOfLoadShape)];
        end
    end
    
    fm_spf_modified(Config);
    
    
    %% sampling all real history records from PSAT
    ResultData = recordRealSystemStatus(t, Config, ResultData);
    
    
    
    if Config.enableOPFCtrl == 1
        %     %% check the voltages of all buses to shed/recovery load
        %     ResultData = LoadShedAndRecovery(Config,ResultData);
        
        %     %% do control according opf result
        if abs(t - ResultData.nOpf*Config.controlPeriod) <= Settings.tstep/2
            %         % make measurements for control center to do opf control
            % ===================== cal eigenvalue
            if Config.calEigs
                if Config.distrsw
                    Jrow = sparse(1,DAE.n+SW.refbus,1,1,DAE.n+DAE.m+1);
                    eigValues = eig(full([DAE.Fx,DAE.Fy,DAE.Fk;DAE.Gx,DAE.Gy,DAE.Gk;Jrow]));
                else
                    eigValues = eig(full([DAE.Fx, DAE.Fy; DAE.Gx, DAE.Gy]));
                end
                minEigValue = min(abs(eigValues));
                ResultData.minEigValueHis = [ResultData.minEigValueHis minEigValue];
            end
            %    ============cal eigenvalue
            [CurrentStatus,ResultData,Config] = sampleAllMeasurements(Config, ResultData, CurrentStatus);
            [ResultData, isOpfConverged] = obtainOpfControlCommand( CurrentStatus, ResultData, Config);
            ResultData.isOpfConverged = [ResultData.isOpfConverged isOpfConverged];
            if (isOpfConverged)
                disp(['opf converged for the time ', num2str(t)]);
                ResultData = addCmd2CtrlOperationQueue(ResultData, Config);
                ResultData = addNetLag2CtrlOperationQueue(ResultData, Config);
            end
            ResultData.nOpf = ResultData.nOpf + 1;
        end
        %
        [ResultData, hasOptEvent, opts ] = hasOperationEvent(Config, ResultData, t);
        %
        if hasOptEvent && Config.hasOpf
            nOpt = length(opts);
            for i = 1 : nOpt
%                 SW.con(:,4) = opts(i).vGen(ResultData.allGenIdx(1:SW.n));
%                 SW.con(:,10) = opts(i).pGen(ResultData.allGenIdx(1:SW.n)) + 1e-5;
                PV.con(:,5) = opts(i).vGen(ResultData.allGenIdx(SW.n + 1 : end));
                PV.con(:,4) = opts(i).pGen(ResultData.allGenIdx(SW.n + 1 : end));
            end
        end
        
    end
    
     
    t = actual_time;
    
end
   

disp(['haha =============>  simulation end with t = ', num2str(t)]);






%% compute delta difference at each step
% -----------------------------------------------------------------------
function diff_max = anglediff
global Settings Syn Bus DAE SW OMIB

diff_max = 0;

if ~Settings.checkdelta, return, end
if ~Syn.n, return, end

delta = DAE.x(Syn.delta);
[idx,ia,ib] = intersect(Bus.island,getbus(Syn));
if ~isempty(idx), delta(ib) = []; end

if isscalar(delta)
    delta = [delta; DAE.y(SW.refbus)];
end
delta_diff = abs(delta-min(delta));
diff_max = (max(delta_diff)*180/pi) > Settings.deltadelta;
if diff_max, return, end

