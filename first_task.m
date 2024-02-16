% build_polynomial.m
yalmip('clear');
clc;

a = sdpvar(6,1);
p = @(x) a(1) + a(2)*x + a(3)*x.^2 + a(4)*x.^3 + a(5)*x.^4 + a(6)*x.^5;
x = 0:0.1:10;

Constraints = [];
for i = 1:length(x)
    Constraints = [Constraints, 0 <= p(x(i)) <= 5];
end
Constraints = [Constraints, p(0) <= 1, p(3) >= 4, p(7) <= 1, 2 <= p(10) <= 3];

Objective = a(6)^2 + a(5)^2 + a(4)^2;
options = sdpsettings('solver','sdpt3');
sol = optimize(Constraints,Objective,options);

if sol.problem == 0
    a_value = value(a);
    disp('Коэффициенты многочлена:');
    disp(a_value);

    fplot(@(x) value(p(x)), [0, 10]);
    grid on;
    xlabel('x');
    ylabel('p(x)');
    title('Многочлен пятой степени');
else
    disp('Не удалось найти решение');
end
