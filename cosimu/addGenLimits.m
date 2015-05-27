function gen2 = addGenLimits(Config,gen)
    gen2 = gen;
    idx = gen(:,2)<Config.pGenLimit(:,1)*100 | gen(:,2)>Config.pGenLimit(:,2)*100;
    gen2(idx,2) = Config.pGenMLE(idx)*100;
end