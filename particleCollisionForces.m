function F = particleCollisionForces(ball,p1,p2)
d = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2); % Euclidean Distance between Particles

if (0 < d) && (d < 2*ball.radius)
    theta = atan2(p1(2) - p2(2),p1(1) - p2(1)); % Angle Between Particles
    F =  ball.spring*(2*ball.radius - d).*[cos(theta); sin(theta)];
else
    F = 0;
end

end

