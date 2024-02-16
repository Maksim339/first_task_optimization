% coefficients_estimation.m
% Здесь используется переменная z_values из файла noisy_measurements.m
% Убедитесь, что noisy_measurements.m запущен перед этим файлом

% 1. Метод наименьших квадратов
coeffs_least_squares = polyfit(x, z_values, 5);
y_least_squares = polyval(coeffs_least_squares, x);

% 2. Минимизация суммы модулей ошибок
error_function = @(coeffs) sum(abs(polyval(coeffs, x) - z_values));
initial_coeffs_l1 = zeros(1, 6);
coeffs_l1 = fminsearch(error_function, initial_coeffs_l1);
y_l1 = polyval(coeffs_l1, x);

% 3. Минимизация суммы значений штрафной функции
penalty_function = @(coeffs) sum(abs(polyval(coeffs, x) - z_values).^0.5);
initial_coeffs_penalty = zeros(1, 6);
coeffs_penalty = fminsearch(penalty_function, initial_coeffs_penalty);
y_penalty = polyval(coeffs_penalty, x);

% 4. Чебышевская аппроксимация
% Инициализация начальных коэффициентов и определение функции ошибки
initial_coeffs_chebyshev = zeros(1, 6);
chebyshev_error_function = @(coeffs) max(abs(polyval(coeffs, x) - z_values));
coeffs_chebyshev = fminsearch(chebyshev_error_function, initial_coeffs_chebyshev);
y_chebyshev = polyval(coeffs_chebyshev, x);

l2_error_least_squares = calculateL2Error(y_values, y_least_squares);
l2_error_l1 = calculateL2Error(y_values, y_l1);
l2_error_penalty = calculateL2Error(y_values, y_penalty);
l2_error_chebyshev = calculateL2Error(y_values, y_chebyshev);


disp(['L2 ошибка наименьших квадратов: ', num2str(l2_error_least_squares)]);
disp(['L2 ошибка минимизации суммы модулей ошибок: ', num2str(l2_error_l1)]);
disp(['L2 ошибка штрафной функции: ', num2str(l2_error_penalty)]);
disp(['L2 ошибка Чебышевской аппроксимации: ', num2str(l2_error_chebyshev)]);

% Построение графика
figure;
plot(x, y_values, 'b', 'LineWidth', 2); 
hold on;
plot(x, y_least_squares, 'g', 'LineWidth', 2);
plot(x, y_l1, 'm', 'LineWidth', 2); 
plot(x, y_penalty, 'c', 'LineWidth', 2); 
plot(x, y_chebyshev, 'k', 'LineWidth', 2); 
legend('Истинные значения', 'Наименьшие квадраты', 'Минимизация суммы модулей ошибок', 'Штрафная функция', 'Чебышевская аппроксимация');
grid on;
xlabel('x');
ylabel('Values');
title('Сравнение различных методов аппроксимации');

function l2_error = calculateL2Error(true_values, approx_values)
    % Вычисление L2 ошибки между истинными и аппроксимированными значениями
    l2_error = sqrt(mean((true_values - approx_values).^2));
end
