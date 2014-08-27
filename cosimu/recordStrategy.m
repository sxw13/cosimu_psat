function re = recordStrategy(Config,ResultData)
    re = ResultData;
    Attacks = Config.falseDataAttacks;
    MDP = ResultData.MDPData;
    
    for k = 1:length(Attacks)
        disp(['=======For attack ' num2str(k) ':']);
        
        fa = Attacks{k};  %攻击设置
        md = MDP{k};    %MDP计算结果
        states = zeros(1,length(fa.Nstate));
        statemin = fa.MDPStateLimits(:,1);
        statemax = fa.MDPStateLimits(:,2);
        statestep = (statemax-statemin)./(fa.Nstate-2);
        
        [Qmax,Action]=max(md.Q');
        for s = 1:prod(fa.Nstate)
            
            if Qmax(s)>-0.99
                Ratios = action2Ratio(Action(s),fa.Naction,fa.MDPBusFalseDataRatioStep,fa.RatioOffset);
                info = [];
                for id = 1:length(fa.Nstate)
                    lp='';up='';
                    if states(id)==0
                        lp='-inf';up=num2str(statemin(id));
                    elseif states(id)==fa.Nstate(id)-1
                        lp=num2str(statemax(id));up='+inf';
                    else
                        lp=num2str(statemin(id)-(states(id)-1)*statestep(id));
                        up=num2str(statemin(id)-(states(id)-2)*statestep(id));
                    end
                    info = [info fa.MDPStateName{id} '=[' lp ',' up '], '];
                end
                info = [info '>>>>'];
                for k = 1:length(Ratios)
                    info = [info fa.InjectionName{k} ':' num2str(Ratios(k)) ', '];
                end
                disp(info);
            end
            
            states(end) = states(end) + 1;
            for id = length(fa.Nstate):-1:2
                if states(id) == fa.Nstate(id)
                    states(id)=0;states(id-1)=states(id-1)+1;  %进位则继续往下计算,不进位则停止
                else break;
                end
            end
        end
    end
    
end