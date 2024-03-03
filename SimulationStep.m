function [xnew ,vnew] = SimulationStep (dt,x,v,ball,box,g)
%SimulationStep will run one timestep of the simulation
    global D  

    Forces = zeros(2,length(x));
    CompletedPairs = zeros(length(x));

    

    % For every Particle 
    for i = 1:length(x)
        p1 = x(:,i); 
        if(~D)
            for j = 1:length(x)
                % DO I NEED TO PREVENT DOUBLE CHECK? ASK JAN SIEBER
                if i ~= j && CompletedPairs2(i,j)==0
                    p2 = x(:,j);
                    % Calculating Forces from Particle Collision                    
                    Fp = particleCollisionForces(ball.spring,ball.radius,p1,p2);
                    Forces(:,i) = Forces(:,i) + Fp;
                    Forces(:,j) = Forces(:,j) - Fp;
                     if all(Fp)
                         CompletedPairs(i,j) = 1;
                         CompletedPairs(j,i) = 1;
                         %disp(['Completed2: ',string(i),string(j)])
                     end
                end
            end
        end

        % Calculating Forces from Wall Collision
         
        Forces(:,i) = Forces(:,i) + wallForces(ball.spring,ball.radius,box,p1); 
    end
    
    


    if(D)        
        grid_idx = floor(abs(x./(4*ball.radius)));
        num_cells_x = 1 + (box(1,2) - box(1,1))/(4*ball.radius);
    
        cell_indices = sub2ind([num_cells_x, num_cells_x], grid_idx(1,:)+1, grid_idx(2,:) + 1);
        cell_indices = cell_indices(:);
        particle_indices = (1:length(x))';
    
        grid = accumarray(cell_indices, particle_indices, [], @(x) {x});
  
        populatedCells = find(~cellfun('isempty',grid))';
        for i = populatedCells
            %if(populatedCells)
                for j = 1:length(grid{i})
                    % Center
                    if(length(grid{i}) > 1)
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i}); 
                    end
                    
                    % North South
                    if(i+1 <= length(grid))
                        if(~isempty(grid{i+1}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+1});
                        end
                    end
                    if(i-1 >= 1)
                        if(~isempty(grid{i-1}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-1}); 
                        end
                    end
                    % East West
                    if(i+num_cells_x < length(grid))
                        if(~isempty(grid{i+num_cells_x}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+num_cells_x}); 
                        end
                    end
                    if(i-num_cells_x >= 1)
                        if(~isempty(grid{i-num_cells_x}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-num_cells_x}); 
                        end
                    end
                    % NE SE
                    if(i+num_cells_x+1 < length(grid))
                        if(~isempty(grid{i+num_cells_x+1}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+num_cells_x+1}); 
                        end
                    end

                    if(i+num_cells_x-1 < length(grid))
                        if(~isempty(grid{i+num_cells_x-1}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+num_cells_x-1}); 
                        end
                    end
                    % NW SW
                    if(i-num_cells_x+1 >= 1)
                        if(~isempty(grid{i-num_cells_x+1}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-num_cells_x+1}); 
                        end 
                    end
                    if(i-num_cells_x-1 >= 1)
                        if(~isempty(grid{i-num_cells_x-1}))
                            [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-num_cells_x-1}); 
                        end
                    end


                end
            %end
        end
    end
    % Including Gravity
    Forces = Forces + [0; -g];


    

    % Updating Position and Velocity Vectors via Verlet 
    xnew =x+ dt.*v + dt^2.*Forces ; % mass is equal 1 !
    vnew =(xnew - x)./dt;

end

