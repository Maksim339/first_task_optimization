% Подключение YALMIP и SDPT3
yalmip('clear');
clc;

% Определение переменных для коэффициентов многочлена
a = sdpvar(6,1);

% Формирование ограничений и вектора точек x
Constraints = [];
x = 0:0.1:10;
Constraints = [];
for i = 1:length(x)
    Constraints = [Constraints, 0 <= p(x(i)) <= 5];
end

Constraints = [Constraints, p(0) <= 1, p(3) >= 4, p(7) <= 1, 2 <= p(10) <= 3];

% Определение целевой функции
Objective = a(6)^2 + a(5)^2 + a(4)^2;

% Решение задачи оптимизации
options = sdpsettings('solver','sdpt3');
sol = optimize(Constraints,Objective,options);


% Проверка, была ли задача решена
if sol.problem == 0
    % Решение найдено
    a_value = value(a);
    
    % Вычисление истинных значений многочлена
    y_values = arrayfun(@(x) a_value(1) + a_value(2)*x + a_value(3)*x^2 + a_value(4)*x^3 + a_value(5)*x^4 + a_value(6)*x^5, x);
    
    v = zeros(size(x));
for i = 1:length(v)
    if rand() < 0.1
        % Генерация значений в диапазоне [-20, -10] U [10, 20]
        v(i) = 10 + 10 * rand();
        if rand() < 0.5
            v(i) = -v(i);
        end
    end
end

% Вычисление новых зашумленных измеренных значений
z_values_new = y_values + w + v;

% Построение графика истинных значений многочлена и новых зашумленных измерений
figure;
plot(x, y_values, 'b', 'LineWidth', 2);
hold on;
plot(x, z_values_new, 'r', 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('Values');
title('Истинные значения многочлена и новые зашумленные измерения');
legend('Истинные значения', 'Новые зашумленные измерения');
else
    disp('Не удалось найти решение');
end

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

% Использование fminsearch для минимизации максимального отклонения
coeffs_chebyshev = fminsearch(chebyshev_error_function, initial_coeffs_chebyshev);
y_chebyshev = polyval(coeffs_chebyshev, x);

% Рассчет ошибок
l2_error_least_squares = calculateL2Error(y_values, y_least_squares);
l2_error_l1 = calculateL2Error(y_values, y_l1);
l2_error_penalty = calculateL2Error(y_values, y_penalty);
l2_error_chebyshev = calculateL2Error(y_values, y_chebyshev);


disp(['L2 ошибка наименьших квадратов: ', num2str(l2_error_least_squares)]);
disp(['L2 ошибка минимизации суммы модулей ошибок: ', num2str(l2_error_l1)]);
disp(['L2 ошибка штрафной функции: ', num2str(l2_error_penalty)]);
disp(['L2 ошибка Чебышевской аппроксимации: ', num2str(l2_error_chebyshev)]);


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






