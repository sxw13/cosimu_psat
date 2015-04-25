function busNumbers = selectBus(casedata,NAttackedBus)
if nargin<2
    NAttackedBus = 3;
end

branch = casedata.branch;
bus = casedata.bus;
NBus = length(bus(:,1));
busNumbers = bus(randi(NBus),1);
% busNumbers = 36;
linkBusIds = [];
for idx0 = 2:NAttackedBus
    for busid = bus(:,1)'
        if isempty(find(busNumbers==busid,1)) && isempty(find(linkBusIds==busid,1))
            idx1 = branch(:,1)==busid;
            idx2 = branch(:,2)==busid;
            tBus = [branch(idx1,2);branch(idx2,1)];
            isContain = 0;
            for busid2 = tBus'
                if ~isempty(find(busNumbers==busid2,1))
                    isContain = 1;
                    break;
                end
            end
            if isContain
                linkBusIds = [linkBusIds busid];
            end
        end
    end
    
    newid = randi(length(linkBusIds));
    busNumbers = [busNumbers linkBusIds(newid)];
    linkBusIds = linkBusIds([1:newid-1 newid+1:length(linkBusIds)]);
end
busNumbers = sort(busNumbers);