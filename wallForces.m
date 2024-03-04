function F = wallForces(ball,box,p)

fLeft = max(0, ball.radius+box(1,1) - p(1));
fDown = max(0, ball.radius + box(2,1) - p(2));
fRight = max(0,ball.radius + p(1) - box(1,2));
fUp = max(0,ball.radius + p(2) - box(2,2));

F = ball.spring.*[fLeft - fRight ; fDown - fUp];

end

