function [xnew ,vnew] = SimulationStep (dt,x,v,ball,box,g)
%SimulationStep will run one timestep of the simulation
    global D 
    persistent NPx  NPy Xb Yb CompletedCells
    Forces = zeros(2,length(x));
    Forces2 = zeros(2,length(x));
    % Find Closest Grid Points of Particles 
    NPx = cell(1,G);
    NPy = cell(1,G);
    Xb = discretize(x(1,:),G);
    Yb = discretize(x(2,:),G);


    % For every Particle 
    for i = 1:length(x)
        % Calculating Forces from Wall Collision
        p1 = x(:,i);  
        Forces(:,i) = Forces(:,i) + wallForces(ball.spring,ball.radius,box,p1);
        Forces2(:,i) = Forces2(:,i) + wallForces(ball.spring,ball.radius,box,p1);
        % Storing Indexes of particles in same 'discretised bin'
        NPx{Xb(i)} = [NPx{Xb(i)} i];
        NPy{Yb(i)} = [NPy{Yb(i)} i];
    
        if(D)
            for j = 1:length(x)
                if i ~= j
                    p2 = x(:,j);
                    % Calculating Forces from Particle Collision
                    
            
                    Fp = particleCollisionForces(ball.spring,ball.radius,p1,p2);
                    Forces2(:,i) = Forces2(:,i) + Fp;
                    Forces2(:,j) = Forces2(:,j) - Fp;
                end
            end
        end
    end
    
    % Optimising Calculation of Particle Collisions by considering only
    % particles within the same discretised grid box. 

    %CompletedCells = zeros(G);
    if(D)
        for i = 1:G
            for j = 1:G
                %if CompletedCells(i,j) == 0
                    % Find Particles in Box i,j
                    C = NPx{i}(ismember(NPx{i},NPy{j}));
                    %if (~isempty(C) && length(C) > 1)      
                        % Check Collisions with Particles in the same box
                        % Centre Check
                        Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces);  
                        %CompletedCells(i,j) = 1;

                        
                        % North Check
                        if (j<G)
                           C = NPx{i}(ismember(NPx{i},NPy{j+1}));
                           Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
                           %CompletedCells(i,j+1) = 1;
                        end
%                         % South Check
%                         if (j>1)
%                            C = NPx{i}(ismember(NPx{i},NPy{j-1}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i,j-1) = 1;
%                         end
%                         % East Check
%                         if (i<G)
%                            C = NPx{i+1}(ismember(NPx{i+1},NPy{j}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i+1,j) = 1;
%                         end
%                         % West Check
%                         if (1<i)
%                            C = NPx{i-1}(ismember(NPx{i-1},NPy{j}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i-1,j) = 1;
%                         end
% 
% 
% 
%                         % North East Check
%                         if (i < G && j < G)
%                            C = NPx{i+1}(ismember(NPx{i+1},NPy{j+1}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i-1,j) = 1;
%                         end
% 
% 
%                         % South East Check
%                         if (i < G && j > 1)
%                            C = NPx{i+1}(ismember(NPx{i+1},NPy{j-1}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i-1,j) = 1;
%                         end
%                         
%                         % South West Check
%                         if (1 < i && 1 < j)
%                            C = NPx{i-1}(ismember(NPx{i-1},NPy{j-1}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i-1,j) = 1;
%                         end
%                         
%                         % North West Check
%                         if (1 < i && j < G)
%                            C = NPx{i-1}(ismember(NPx{i-1},NPy{j+1}));
%                            Forces = collisionsInCell(ball.spring,ball.radius,x,C,Forces); 
%                            %CompletedCells(i-1,j) = 1;
%                         end



                    %end
                %end
            end
        end
    end
    
    % Including Gravity
    Forces = Forces + [0; -g];


    

    % Updating Position and Velocity Vectors via Verlet 
    xnew =x+ dt.*v + dt^2.*Forces ; % mass is equal 1 !
    vnew =(xnew - x)./dt;
    
    xnew2 =x+ dt.*v + dt^2.*Forces2 ; % mass is equal 1 !
    vnew2 =(xnew - x)./dt;

    PALAL = norm(xnew - xnew2);
    LABAL = norm(Forces - Forces2);
    VALAL = norm(vnew - vnew2);

    disp(Forces ~= Forces2)

end

