function CurrentStatus = initialCurrentStatus(Config)

CurrentStatus = eval(Config.opfCaseName);
%CurrentStatus.gen(5,9) = Config.gen2;
for i = 1 : length(CurrentStatus.gen(:, 1))
    CurrentStatus.gen(i,[4,5]) = [9999, -9999];
end

if Config.enableLoadShape
    CurrentStatus.gen(:,[9 10]) = Config.LoadShapeRatio * CurrentStatus.gen(:,[9 10]);
end

% if Config.autoOPFLimit
%     CurrentStatus.gen(:,[9 10]) = Config.pGenLimit*diag(Config.opfSafetyMargin);
% end

% CurrentStatus.gen(:, [9,10,4,5]) = Config.loadmult * CurrentStatus.gen(:, [9,10,4,5]); % deal with load mult
CurrentStatus.genControllabilty = CurrentStatus.gen(:, [9,10,4,5]);

CurrentStatus.loadBase = CurrentStatus.bus(:,[3, 4]);

