% give out action choice state; 0 for no attack; 1 for random attack; 2 for
% optimal attack
function ActionState = giveoutActionState(ActionHistory)
    ActionState = ones( 1,length(ActionHistory) );
    ActionState(2:end) = (ActionHistory(2:end)==ActionHistory(1:end-1))+1;
    ActionState = ActionState.*(ActionHistory~=-1);
    
    min2length = 2;
    for id = 2:length(ActionHistory)-min2length+1
        if ActionState(id)~=2 continue;end
        for idd = id+1:id+min2length-1
            if ActionState(idd)~=2
                ActionState(id)=1;
                break;
            end
        end
    end
end