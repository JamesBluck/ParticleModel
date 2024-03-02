function F = wallForces(K,r,box,p)
persistent fLeft fDown fRight fUp 
fLeft = max(0, r+box(1,1) - p(1));
fDown = max(0, r + box(2,1) - p(2));
fRight = max(0,r + p(1) - box(1,2));
fUp = max(0,r + p(2) - box(2,2));

F = K.*[fLeft - fRight ; fDown - fUp];
end

