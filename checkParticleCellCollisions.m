function [Force,CompletedPairs] = checkParticleCellCollisions(K,r,x,F,CompletedPairs,p1,Cell)

%F(:,24)
if ~isempty(Cell)
    for i = 1:length(Cell)
        if(p1~=Cell(i) && CompletedPairs(p1,Cell(i))==0)
            Fp = particleCollisionForces(K,r,x(:,p1),x(:,Cell(i)));
            if(all(Fp))
                CompletedPairs(p1,Cell(i))=1;
                CompletedPairs(Cell(i),p1)=1;
                %disp(['Completed1: ',string(p1),string(Cell(i)),string(Fp')]);
                %disp([string(F(:,p1)')]);
                %disp([string(F(:,Cell(i))')]);
            end
            F(:,p1) = F(:,p1) + Fp;
            F(:,Cell(i)) = F(:,Cell(i)) - Fp;
        end
    end
end
Force = F;
end
