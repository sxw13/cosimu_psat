%%
ratios = linspace(0,1,1001);
n = length(ratios);
sh = zeros(1,n);
mpc = case39;
m = size(mpc.bus,1);

opt = mpoption('VERBOSE',0, 'OUT_ALL', 0, 'OPF_ALG', 580); %using IPOPT
opt0 = mpoption('VERBOSE',0, 'OUT_ALL', 0); %using MIPS
for k = 1:n
    loadRatio = ratios(k);
    mpc = case39;
    % mpc.bus(:,12) = mpc.bus(:,12)/1.06*1.1;
    % mpc.bus(:,13) = mpc.bus(:,13)/0.94*0.9;
    mpc.bus(:,3) = mpc.bus(:,3)*loadRatio;  % Pload
    mpc.bus(:,4) = mpc.bus(:,4)*loadRatio;  % Qload
%     mpc.bus(:,12) = ones(m,1)*1.1;  % vmax
%     mpc.bus(:,13) = ones(m,1)*0.9;  % vmin
    disp(['load ratio = ' num2str(loadRatio)]);
    [ResultData, success] = opf(mpc,opt0);
    if ~success [ResultData, success]=opf(mpc,opt); end
    sh(k)=success;
end

%%
    loadRatio = 0.574;
%     loadRatio = 1;
    opt = mpoption('VERBOSE',0, 'OUT_ALL', 0, 'OPF_ALG', 580); %using IPOPT
    mpc = case39;
    [m,n] = size(mpc.bus);
    % mpc.bus(:,12) = mpc.bus(:,12)/1.06*1.1;
    % mpc.bus(:,13) = mpc.bus(:,13)/0.94*0.9;
    mpc.bus(:,3) = mpc.bus(:,3)*loadRatio;  % Pload
    mpc.bus(:,4) = mpc.bus(:,4)*loadRatio;  % Qload
    mpc.bus(:,12) = ones(m,1)*1.1;  % vmax
    mpc.bus(:,13) = ones(m,1)*0.9;  % vmin
%     mpc.gen(:,2) = mpc.gen(:,2)*loadRatio;
    disp(['load ratio = ' num2str(loadRatio)]);
    Result = opf(mpc,opt);
%%
    pfr = runpf(mpc);
    mpc.bus(:,8) = pfr.bus(:,8);
    mpc.bus(:,9) = pfr.bus(:,9);
    Result = opf(mpc);


% mpc = case_ieee39;
% % mpc.bus(:,12) = mpc.bus(:,12)/1.06*1.1;
% % mpc.bus(:,13) = mpc.bus(:,13)/0.94*0.9;
% mpc.bus(:,3) = mpc.bus(:,3)*0.6094;  % Pload
% mpc.bus(:,4) = mpc.bus(:,4)*0.6094;  % Qload
% [ResultData, success] = opf(mpc);