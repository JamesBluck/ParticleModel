function [xnew ,vnew] = SimulationStep (dt,x,v,ball,box,g)
%SimulationStep will run one timestep of the simulation
    global D  

    Forces = zeros(2,length(x));
    Forces2 = zeros(2,length(x));
    CompletedPairs = zeros(length(x));
    % Non-Optimised Simulation
    if (~D)
        for i = 1:length(x)
            p1 = x(:,i);

            % Calculating Forces from Wall Collision
            Forces(:,i) = Forces(:,i) + wallForces(ball.spring,ball.radius,box,p1);
            
            for j = 1:length(x)
                % DO I NEED TO PREVENT DOUBLE CHECK? COME BACK TO THIS
                if i ~= j && CompletedPairs(i,j)==0
                    p2 = x(:,j);

                    % Calculating Forces from Particle Collision
                    Fp = particleCollisionForces(ball.spring,ball.radius,p1,p2);
                    Forces(:,i) = Forces(:,i) + Fp;
                    Forces(:,j) = Forces(:,j) - Fp;

                    % Marking Pair as Complete
                    if all(Fp)
                        CompletedPairs(i,j) = 1;
                        CompletedPairs(j,i) = 1;
                    end
                end
            end
        end
    end



    % Optimised Simulation
    if(D)        
        % Discretise Particles into Boxes
        grid_idx = 1 + floor(abs(x./(4*ball.radius)));
        num_cells_X =  1 + (box(1,2) - box(1,1))/(4*ball.radius);
        num_cells_Y =  1 + (box(2,2) - box(2,1))/(4*ball.radius);
        
        % Find Particles close to Boundary Walls
        xBoundary = bsxfun(@or,grid_idx(1,:) <= 1, grid_idx(1,:) >= num_cells_X - 1);
        yBoundary = bsxfun(@or,grid_idx(2,:) <= 1, grid_idx(2,:) >= num_cells_Y - 1);
        Boundary = find(bsxfun(@or,xBoundary,yBoundary));
        
        % Calculating Forces from Wall Collision 
        for i = Boundary
           Forces(:,i) = Forces(:,i) + wallForces(ball.spring,ball.radius,box,x(:,i));
        end
        
        % Converting to linear indexing
        cell_indices = sub2ind([num_cells_X, num_cells_Y], grid_idx(1,:), grid_idx(2,:));
        cell_indices = cell_indices(:);
        particle_indices = (1:length(x))';
    
        grid = accumarray(cell_indices, particle_indices, [], @(x) {x});


        populatedCells = find(~cellfun('isempty',grid))';
        for i = populatedCells
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
                if(i+num_cells_X < length(grid))
                    if(~isempty(grid{i+num_cells_X}))
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+num_cells_X});
                    end
                end
                if(i-num_cells_X >= 1)
                    if(~isempty(grid{i-num_cells_X}))
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-num_cells_X});
                    end
                end

                % NE SE
                if(i+num_cells_X+1 < length(grid))
                    if(~isempty(grid{i+num_cells_X+1}))
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+num_cells_X+1});
                    end
                end
                if(i+num_cells_X-1 < length(grid))
                    if(~isempty(grid{i+num_cells_X-1}))
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i+num_cells_X-1});
                    end
                end

                % NW SW
                if(i-num_cells_X+1 >= 1)
                    if(~isempty(grid{i-num_cells_X+1}))
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-num_cells_X+1});
                    end
                end
                if(i-num_cells_X-1 >= 1)
                    if(~isempty(grid{i-num_cells_X-1}))
                        [Forces,CompletedPairs] = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,CompletedPairs,grid{i}(j),grid{i-num_cells_X-1});
                    end
                end
            end
        end
    end



    % Including Gravity
    Forces = Forces + [0; -g];

    % Updating Position and Velocity Vectors via Verlet 
    xnew =x+ dt.*v + dt^2.*Forces ; % mass is equal 1 !
    vnew =(xnew - x)./dt;

end
