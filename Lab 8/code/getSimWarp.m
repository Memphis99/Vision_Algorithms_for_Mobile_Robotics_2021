function W = getSimWarp(dx, dy, alpha_deg, lambda)
% alpha given in degrees, as indicated
    alpha_deg=alpha_deg*pi/180;
    W=lambda*[cos(alpha_deg), -sin(alpha_deg), dx; sin(alpha_deg), cos(alpha_deg), dy];
end
