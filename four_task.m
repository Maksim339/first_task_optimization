% additional_noisy_measurements.m
% Здесь используется переменная y_values из файла noisy_measurements.m
% Убедитесь, что noisy_measurements.m запущен перед этим файлом

v = zeros(size(x));
for i = 1:length(v)
    if rand() < 0.1
        v(i) = 10 + 10 * rand();
        if rand() < 0.5
            v(i) = -v(i);
        end
    end
end
z_values_new = y_values + w + v;

figure;
plot(x, y_values, 'b', 'LineWidth', 2);
hold on;
plot(x, z_values_new, 'r', 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('Values');
title('Истинные значения многочлена и новые зашумленные измерения');
legend('Истинные значения', 'Новые зашумленные измерения');
