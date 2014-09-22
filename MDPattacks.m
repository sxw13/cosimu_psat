% MDPattack({'Config.falseDataSchema = 0'},'noAttack');
ResultData = MDPattack([],'LoadShape2edit',ResultData.MDPData);
% MDPattack({'Config.loadShapeCsvFile=''LoadShapeSimpleHigh.csv'''},'LoadShapeHigh');
% MDPattack({'Config.loadShapeCsvFile=''LoadShapeSimpleConsequence.csv'''},'LoadShapeConsequence');
% MDPattack({'Config.loadShapeCsvFile=''LoadShapeSimple2.csv''',...
%     'Config.falseDataAttacks{1, 1}.LearningEndTime = 16 * 3600'}, 'smartAttack');