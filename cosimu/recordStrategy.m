function re = recordStrategy(Config,ResultData,fcsv)
    re = ResultData;
    Attacks = Config.falseDataAttacks;
    MDP = ResultData.MDPData;
    
    for k = 1:length(Attacks)
        fprintf(fcsv,['=======For attack ' num2str(k) ':\n']);
        
        
        fa = Attacks{k};  %攻击设置
        md = MDP{k};    %MDP计算结果
        fa.Nstate = fa.Nstate(1:length(fa.MDPStateName));
        states = zeros(1,length(fa.MDPStateName));
        if isfield(md,'stateOffset')
            statemin = fa.MDPStateLimits(:,1)-md.stateOffset;
            statemax = fa.MDPStateLimits(:,2)-md.stateOffset;
        else
            statemin = fa.MDPStateLimits(:,1);
            statemax = fa.MDPStateLimits(:,2);
        end
        
        statestep = (statemax-statemin)./(fa.Nstate(1:length(fa.MDPStateName))-2)';
        z = zeros(length(fa.Naction),prod(fa.Nstate));
        [Qmax,Action]=max(md.Q');
        info = '';
        for kk = 1:length(fa.MDPStateName)
            info = [info fa.MDPStateName{kk} ', '];
        end
        for kk = 1:length(fa.InjectionName)
            info = [info fa.InjectionName{kk} ', '];
        end
        
        fprintf(fcsv,[info '\n']);
        for s = 1:prod(fa.Nstate)
            
            if Qmax(s)>fa.minAttackValue % && nnz(md.Q(s,:))>=fa.maxLearnedAction
                Ratios = action2Ratio(Action(s),fa.Naction,fa.MDPBusFalseDataRatioStep,fa.RatioOffset);
                info = '';
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
                    info = [info '"[' lp ',' up ']",'];
                end
                for kk = 1:length(Ratios)
                    info = [info num2str(Ratios(kk)) ','];
                    z(kk,s) = Ratios(kk);
                end
                fprintf(fcsv,[info '\n']);
            end
            
            states(end) = states(end) + 1;
            for id = length(fa.Nstate):-1:2
                if states(id) == fa.Nstate(id)
                    states(id)=0;states(id-1)=states(id-1)+1;  %进位则继续往下计算,不进位则停止
                else break;
                end
            end
        end
%         figure;
%         plot3(x,y,z);
%         xlabel('state');ylabel('location');zlabel('error ratio');
%         title([pname ' attackid=' int2str(k)]);
%         grid on;
    end
    
end