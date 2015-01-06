function idxAddOn  = findMeas4Bus(Config, measureName, busId)
%FINDMEAS4BUS Summary of this function goes here
%   Detailed explanation goes here
cd psat/tests
    eval(Config.caseName(1:end-2));
cd ..
cd ..
% initial PSAT global variables
% simplePF(Config, csTemp);
% rdTemp = initialResultData(Config, csTemp);
idxAddOn = [];
switch measureName
    case 'ploadMeas'
        idxLd = find(PQ.con(:,1)==busId);
        if ~isempty(idxLd)
            idxAddOn = idxLd;
        end
      
    case 'qloadMeas'
        idxLd = find(PQ.con(:,1)==busId);
        if ~isempty(idxLd)
            idxAddOn = idxLd;
        end
    
    case 'genPMeas'
        idxG = find([SW.con(:,1);PV.con(:,1)]==busId);
        if ~isempty(idxG)
            idxAddOn = idxG;
        end
   
    case 'genQMeas'
        idxG = find([SW.con(:,1);PV.con(:,1)]==busId);
        if ~isempty(idxG)
            idxAddOn = idxG;
        end
 
    case 'busVMeasPu'
        if ~isempty(find(Bus.con(:,1)==busId,1))
            idxAddOn = busId;
        end

    case 'plineHeadMeas'
        idxLine = find(Line.con(:,1)==busId);
        if ~isempty(idxLine)
            idxAddOn = idxLine;
        end
   
    case 'plineTailMeas'
        idxLine = find(Line.con(:,2)==busId);
        if ~isempty(idxLine)
            idxAddOn = idxLine;
        end

    case 'qlineHeadMeas'
        idxLine = find(Line.con(:,1)==busId);
        if ~isempty(idxLine)
            idxAddOn = idxLine;
        end

    case 'qlineTailMeas'
        idxLine = find(Line.con(:,2)==busId);
        if ~isempty(idxLine)
            idxAddOn = idxLine;
        end

    otherwise

end

if ~isempty(idxAddOn)
    
%      measureID = [measureName, '(', num2str(idxAddOn), ')'];
else
    disp(['no such measurement for', measureName, ': bus ', num2str(busId)]);
end

end



