function [xnew ,vnew] = SimulationStep (dt,x,v,ball,box,g,t)
%SimulationStep will run one timestep of the simulation
    global D G CompletedPairs CompletedPairs2
    Forces = zeros(2,length(x));
    Forces2 = zeros(2,length(x));
    
    CompletedPairs = zeros(length(x));
    CompletedPairs2 = zeros(length(x));

    if(D)
        grid_idx = floor(abs(x./(4*ball.radius)));
    
        num_cells_x = 1 + (box(1,2) - box(1,1))/(4*ball.radius);
    
        cell_indices = sub2ind([num_cells_x, num_cells_x], grid_idx(1,:)+1, grid_idx(2,:) + 1);
        cell_indices = cell_indices(:);
        particle_indices = (1:length(x))';
    
        grid = accumarray(cell_indices, particle_indices, [], @(x) {x});
    end

    % For every Particle 
    for i = 1:length(x)
        p1 = x(:,i); 
        if(~D)
            for j = 1:length(x)
                if i ~= j %&& CompletedPairs2(i,j)==0
                    p2 = x(:,j);
                    % Calculating Forces from Particle Collision                    
                    Fp = particleCollisionForces(ball.spring,ball.radius,p1,p2);
                    Forces(:,i) = Forces(:,i) + Fp;
                    Forces(:,j) = Forces(:,j) - Fp;
%                     if all(Fp)
%                         CompletedPairs2(i,j) = 1;
%                         CompletedPairs2(j,i) = 1;
%                         %disp(['Completed2: ',string(i),string(j)])
%                     end
                end
            end
        end
     



        % Calculating Forces from Wall Collision
         
        Forces(:,i) = Forces(:,i) + wallForces(ball.spring,ball.radius,box,p1);
        %Forces2(:,i) = Forces2(:,i) + wallForces(ball.spring,ball.radius,box,p1); 
    end
    

    if(D)
        for i = 1:length(grid)
            if(~isempty(grid{i}))
                for j = 1:length(grid{i})
                    % Center
                    Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i}); 

                    % North South
                    if(i+1 <= length(grid))
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i+1}); 
                    end
                    if(i-1 >= 1)
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i-1}); 
                    end
                    % East West
                    if(i+num_cells_x < length(grid))
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i+num_cells_x}); 
                    end
                    if(i-num_cells_x >= 1)
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i-num_cells_x}); 
                    end
                    % NE SE
                    if(i+num_cells_x+1 < length(grid))
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i+num_cells_x+1}); 
                    end
                    if(i+num_cells_x-1 < length(grid))
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i+num_cells_x-1}); 
                    end
                    % NW SW
                    if(i-num_cells_x+1 >= 1)
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i-num_cells_x+1}); 
                    end
                    if(i-num_cells_x-1 >= 1)
                        Forces = checkParticleCellCollisions(ball.spring,ball.radius,x,Forces,grid{i}(j),grid{i-num_cells_x-1}); 
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
 
%     PALAL = norm(xnew - xnew2);
     LABAL = norm(Forces - Forces2);
%     VALAL = norm(vnew - vnew2);

    

end

