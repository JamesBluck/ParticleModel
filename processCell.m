function [Forces, CompletedPairs] = processCell(ball,x,Forces,CompletedPairs,Grid,i)
for j = 1:length(Grid.data{i})
    % Consider Particle Collisions of Grid.data{i}(j) with all particles in
    % the current and surrounding cells 
    for k = -1:1
        for m = -1:1
            Pos = i + m*Grid.cells_X + k;
            if((1 <= Pos) && (Pos <= length(Grid.data)))
                [Forces,CompletedPairs] = checkParticleCellCollisions(ball,x,Forces,CompletedPairs,Grid.data{i}(j),Grid.data{Pos});
            end
        end
    end
end
end

