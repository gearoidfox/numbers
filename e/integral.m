function auc =  integral(b)
% evaluate integral of 1/x from x=1 to x=b
    [x, y] = ode45(@(x,y) 1/x, [1, b], 1);
    auc = y(end) - y(1);
end
