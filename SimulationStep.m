function [xnew ,vnew] = SimulationStep (dt,x,v,ball,box,g)
%SimulationStep will run one timestep of the simulation
    global D  

    Forces = zeros(2,length(x));
    CompletedPairs = sparse(length(x),length(x));


    % Non-Optimised Simulation
    if (~D)
        for i = 1:length(x)
            p1 = x(:,i);

            % Calculating Forces from Wall Collision
            Forces(:,i) = Forces(:,i) + wallForces(ball,box,p1);
            
            for j = 1:length(x)
                % DO I NEED TO PREVENT DOUBLE CHECK? COME BACK TO THIS
                if i ~= j && CompletedPairs(i,j)==0
                    p2 = x(:,j);

                    % Calculating Forces from Particle Collision
                    Fp = particleCollisionForces(ball,p1,p2);
                    

                    % Marking Pair as Complete
                    if all(Fp)
                        CompletedPairs(i,j) = 1;
                        CompletedPairs(j,i) = 1;
                        Forces(:,i) = Forces(:,i) + Fp;
                        Forces(:,j) = Forces(:,j) - Fp;
                    end
                end
            end
        end
    end



    % Optimised Simulation
    if(D)        
        % Discretise Particles into Boxes
        Grid = setupGrid(4*ball.radius,3,box,x);



        % Find Particles close to Boundary Walls
        xBoundary = bsxfun(@or,Grid.idx(1,:) <= Grid.Translation, Grid.idx(1,:) >= Grid.cells_X - Grid.Translation);
        yBoundary = bsxfun(@or,Grid.idx(2,:) <= Grid.Translation, Grid.idx(2,:) >= Grid.cells_Y - Grid.Translation);
        Boundary = find(bsxfun(@or,xBoundary,yBoundary));

        % Calculating Forces from Wall Collision 
        for i = Boundary
           Forces(:,i) = Forces(:,i) + wallForces(ball,box,x(:,i));
        end
        

        populatedCells = sort(find(~cellfun('isempty',Grid.data)))';
        for i = populatedCells
            [Forces,CompletedPairs] = processCell(ball,x,Forces,CompletedPairs,Grid,i,populatedCells);            
        end
    end


    % Including Gravity
    Forces = Forces + [0; -g];

    % Updating Position and Velocity Vectors via Verlet 
    xnew =x+ dt.*v + dt^2.*Forces ; % mass is equal 1 !
    vnew =(xnew - x)./dt;

end
