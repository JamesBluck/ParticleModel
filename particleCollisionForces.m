function F = particleCollisionForces(K,r,p1,p2)
d = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2); % Euclidean Distance between Particles

if (0 < d) && (d < 2*r)
    theta = atan2(p1(2) - p2(2),p1(1) - p2(1)); % Angle Between Particles
    F =  K*(2*r - d).*[cos(theta); sin(theta)];
else
    F = 0;
end

end

