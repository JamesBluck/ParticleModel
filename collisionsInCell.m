function Force = collisionNearPoint(K,r,x,C,F)
    for j = 1:length(C)
        p1 = x(:,C(j));  
        for k = 1:length(C)
            % Calculating Forces from Particle Collision
            if j ~= k
                p2 = x(:,C(k));

                Fp = particleCollisionForces(K,r,p1,p2);
                
                F(:,C(j)) = F(:,C(j)) + Fp;
                F(:,C(k)) = F(:,C(k)) - Fp;
            end
        end
    end
    Force = F;
end



