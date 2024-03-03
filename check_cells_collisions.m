function Force = check_cells_collisions(K,r,x,F,C,O)
for i = 1:length(C)
    for j = 1:length(O)
        if(C(i)~=O(j))
            Fp = particleCollisionForces(K,r,x(:,C(i)),x(:,O(j)));

            F(:,C(i)) = F(:,C(i)) + Fp;
            F(:,O(j)) = F(:,O(j)) - Fp;
        end
    end
end
Force = F;
end

