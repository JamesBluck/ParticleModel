function [Forces, CompletedPairs] = processCell(ball,x,Forces,CompletedPairs,Grid,i,populatedCells)
k2 = [1 0 -1];
Pos = i + k2*Grid.cells_X + k2';
cellToCheck = ismembc(Pos,populatedCells);
%idx = find(cellToCheck);
Surrounding = Grid.data{Pos(cellToCheck)};
for j = 1:numel(Grid.data{i})
    % Consider Particle Collisions of Grid.data{i}(j) with all particles in
    % the current and surrounding cells  
    CurrentParticle = Grid.data{i}(j);
    checkParticleCellCollisions(CurrentParticle,Surrounding);  
end    
%     CurrentParticle = Grid.data{i}(j);
%     for k = idx'
%         p = Pos(k);
%         cell = Grid.data{p};
%         checkParticleCellCollisions(CurrentParticle,cell);
%     end

%     
%     for k = -1:1
%         for m = -1:1
%             Pos = i + m*Grid.cells_X + k;
%             if((1 <= Pos) && (Pos <= length(Grid.data)) && any(populatedCells == Pos))
%                 cell = Grid.data{Pos};
%                 [Forces,CompletedPairs] = checkParticleCellCollisions(ball,x,Forces,CompletedPairs,Grid.data{i}(j),cell);
%             end
%         end
%     end








    function checkParticleCellCollisions(p1,Cell)
        for k = 1:length(Cell)
            if CompletedPairs(Cell(k),p1)==0
                Fp = particleCollisionForces(ball,x(:,p1),x(:,Cell(k)));

                if(any(Fp))
                    CompletedPairs(Cell(k),p1)=1;

                    Forces(:,p1) = Forces(:,p1) + Fp;
                    Forces(:,Cell(k)) = Forces(:,Cell(k)) - Fp;
                end
            end
        end

%         % Find particles in Cell that haven't been completed yet
%         Comparison =  CompletedPairs(Cell,p1);
% 
%         incompleteCells = Cell(Comparison <1);
%         %distinctParticles = Cell(p1 ~= Cell);
% 
%         incompleteParticles = incompleteCells;%(ismember(incompleteCells, distinctParticles));
% 
%         % If there are incomplete cells, calculate collision forces
%         if ~isempty(incompleteParticles)
%             % Calculate collision forces for all incomplete cells
%             Fp = particleCollisionForces(ball, x(:, p1), x(:, incompleteParticles));
% 
%             % Find cells with non-zero forces
%             validCells = any(Fp, 1);
% 
%             % Update CompletedPairs matrix
%             CompletedPairs(p1, incompleteParticles(validCells)) = 1;
%             CompletedPairs(incompleteParticles(validCells), p1) = 1;
% 
%             % Update Forces matrix
%             Forces(:, p1) = Forces(:, p1) + sum(Fp(:, validCells), 2);
%             Forces(:, incompleteParticles(validCells)) = Forces(:, incompleteParticles(validCells)) - Fp(:, validCells);
%         end


        %         for k = 1:length(Cell)
        %             if p1~=Cell(k) && CompletedPairs(p1,Cell(k))==0
        %                 Fp = particleCollisionForces(ball,x(:,p1),x(:,Cell(k)));
        %
        %                 if(any(Fp))
        %                     CompletedPairs(p1,Cell(k))=1;
        %                     CompletedPairs(Cell(k),p1)=1;
        %
        %                     Forces(:,p1) = Forces(:,p1) + Fp;
        %                     Forces(:,Cell(k)) = Forces(:,Cell(k)) - Fp;
        %                 end
        %             end
        %         end
    end



end

