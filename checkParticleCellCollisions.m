function [Force,CompletedPairs] = checkParticleCellCollisionssss(ball,x,F,CompletedPairs,p1,Cell)
for i = 1:length(Cell)
    if p1~=Cell(i) && CompletedPairs(p1,Cell(i))==0
        Fp = particleCollisionForces(ball,x(:,p1),x(:,Cell(i)));
        if(all(Fp))
            CompletedPairs(p1,Cell(i))=1;
            CompletedPairs(Cell(i),p1)=1;

            F(:,p1) = F(:,p1) + Fp;
            F(:,Cell(i)) = F(:,Cell(i)) - Fp;
        end
    end
end
Force = F;
end
