function bus_new = addLoadLimits(Config,bus,allLoadIdx)
    bus_new = bus;
    load = bus(allLoadIdx,[3 4]);
    
    up = [Config.pLoadLimit(:,2) Config.qLoadLimit(:,2)]*100;
    lp = [Config.pLoadLimit(:,1) Config.qLoadLimit(:,1)]*100;
    
    idx = (load>up*Config.seSafetyMargin(2) & up>0);
    load(idx) = up(idx)*Config.seSafetyMargin(2);
    
    idx = (load<lp*Config.seSafetyMargin(1) & lp>0);
    load(idx) = lp(idx)*Config.seSafetyMargin(1);
    
    idx = (load>up*Config.seSafetyMargin(1) & up<0);
    load(idx) = up(idx)*Config.seSafetyMargin(1);
    
    idx = (load<lp*Config.seSafetyMargin(2) & lp<0);
    load(idx) = lp(idx)*Config.seSafetyMargin(2);
    
    bus_new(allLoadIdx,[3 4]) = load;
end