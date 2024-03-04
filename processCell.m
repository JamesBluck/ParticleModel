function [Forces, CompletedPairs] = processCell(ball,x,Forces,CompletedPairs,Grid,i,populatedCells)
k2 = [1 0 -1];
Pos = i + k2*Grid.cells_X + k2';
cellsToCheck = ismembc(Pos,populatedCells);
Particles = Grid.data{Pos(cellsToCheck)};
for j = 1:numel(Grid.data{i})
    % Consider Particle Collisions of Grid.data{i}(j) with all particles in
    % the current and surrounding cells
    CurrentParticle = Grid.data{i}(j);
    for k = 1:length(Particles)
        %if CompletedPairs(Particles(k),CurrentParticle)==0
            Fp = particleCollisionForces(ball,x(:,CurrentParticle),x(:,Particles(k)));

            if(any(Fp))
                %CompletedPairs(Particles(k),CurrentParticle)=1;

                Forces(:,CurrentParticle) = Forces(:,CurrentParticle) + Fp;
                Forces(:,Particles(k)) = Forces(:,Particles(k)) - Fp;
            end
        %end
    end
end
end

