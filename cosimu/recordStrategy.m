function re = recordStrategy(Config,ResultData,pname)
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
        [x,y] = meshgrid(1:prod(fa.Nstate),1:length(fa.Naction));
        z = zeros(length(fa.Naction),prod(fa.Nstate));
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
                        lp=num2str(statemin(id)+(states(id)-1)*statestep(id));
                        up=num2str(statemin(id)+states(id)*statestep(id));
                    end
                    info = [info fa.MDPStateName{id} '=[' lp ',' up '], '];
                end
                info = [info '>>>>'];
                for kk = 1:length(Ratios)
                    info = [info fa.InjectionName{kk} ':' num2str(Ratios(kk)) ', '];
                    z(kk,s) = Ratios(kk);
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
        figure;
        plot3(x,y,z);
        xlabel('state');ylabel('location');zlabel('error ratio');
        title([pname ' attackid=' int2str(k)]);
        grid on;
    end
    
end