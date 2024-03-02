[I,J] = meshgrid(linspace(0,10,10),linspace(0,10,10));
P = [I(:),J(:)];
hold on;
for i = 1:1:100
        % North Check
        if (mod(i,10) ~= 0)
           plot(P(i,1),P(i,2),'*r');
        end

        % North East Check
        if (mod(i+11,10) ~= 1 && i+11 <= 100)
            %plot(P(i,1),P(i,2),'*r');
        end
    
        % East Check
        if (i+10<=100)
            %plot(P(i,1),P(i,2),'*r');
        end
        
        % South East Check
        if (mod(i+9,10) ~= 0 && i+9 <= 100)
            %plot(P(i,1),P(i,2),'*r');
        end

        % South Check
        if (mod(i-1,10) ~= 0)
            %plot(P(i,1),P(i,2),'*r');
        end

        % South West Check
        if (mod(i-11,10) ~= 0 && i-11 >= 1)
            %plot(P(i,1),P(i,2),'*r');
        end

        % West Check
        if (i-10>=1)
            %plot(P(i,1),P(i,2),'*r');
        end

        % North West Check
        if (mod(i-9,10) ~= 1 && i-9 >= 1)
            %plot(P(i,1),P(i,2),'*r');
        end
end
%plot(P(2,1),P(2,2),'*r');

xlim([0 10])
ylim([0 10])
%k = dsearchn(P,x');


