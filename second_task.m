x = 0:0.1:10;
y_values = arrayfun(@(x) a_value(1) + a_value(2)*x + a_value(3)*x.^2 + a_value(4)*x.^3 + a_value(5)*x.^4 + a_value(6)*x.^5, x);
w = sqrt(0.3) * randn(size(x));
z_values = y_values + w;

figure;
plot(x, y_values, 'b', 'LineWidth', 2);
hold on;
plot(x, z_values, 'r', 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('Values');
title('Истинные значения многочлена и зашумленные измерения');
legend('Истинные значения', 'Зашумленные измерения');
