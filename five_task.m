% Подключение YALMIP и SDPT3
yalmip('clear');
clc;

% Определение переменных для точного многочлена
a_exact = sdpvar(6,1);

% Функция для точного многочлена
p_exact = @(x) a_exact(1) + a_exact(2)*x + a_exact(3)*x.^2 + a_exact(4)*x.^3 + a_exact(5)*x.^4 + a_exact(6)*x.^5;

% Формирование вектора точек x
x = 0:0.1:10;

% Определение ограничений
Constraints = [];
for i = 1:length(x)
    Constraints = [Constraints, 0 <= p_exact(x(i)) <= 5];
end
Constraints = [Constraints, p_exact(0) <= 1, p_exact(3) >= 4, p_exact(7) <= 1, 2 <= p_exact(10) <= 3];

% Целевая функция
Objective = a_exact(1)^2 + a_exact(2)^2 + a_exact(3)^2 + a_exact(4)^2 + a_exact(5)^2 + a_exact(6)^2;

% Настройка параметров решателя
options = sdpsettings('solver','sdpt3');

% Решение задачи оптимизации
sol = optimize(Constraints,Objective,options);

if sol.problem == 0
    a_value = value(a_exact);
    y_values = arrayfun(@(x) a_value(1) + a_value(2)*x + a_value(3)*x^2 + a_value(4)*x^3 + a_value(5)*x^4 + a_value(6)*x^5, x);
    
    % Генерация зашумленных данных
    w = sqrt(0.3) * randn(size(x));
    v = zeros(size(x));
    for i = 1:length(v)
        if rand() < 0.1
            v(i) = 10 + 10 * rand();
            if rand() < 0.5
                v(i) = -v(i);
            end
        end
    end
    z_values = y_values + w + v;

    % Определение отдельных переменных для каждой аппроксимации
    a_ls = sdpvar(6,1);
    a_l1 = sdpvar(6,1);
    a_penalty = sdpvar(6,1);
    a_chebyshev = sdpvar(6,1);

    % Метод наименьших квадратов
    Objective_least_squares = norm(z_values - (a_ls(1) + a_ls(2)*x + a_ls(3)*x.^2 + a_ls(4)*x.^3 + a_ls(5)*x.^4 + a_ls(6)*x.^5), 2);
    optimize(Constraints, Objective_least_squares, options);
    y_least_squares = value(a_ls(1) + a_ls(2)*x + a_ls(3)*x.^2 + a_ls(4)*x.^3 + a_ls(5)*x.^4 + a_ls(6)*x.^5);

    % Минимизация суммы модулей ошибок
    Objective_l1 = norm(z_values - (a_l1(1) + a_l1(2)*x + a_l1(3)*x.^2 + a_l1(4)*x.^3 + a_l1(5)*x.^4 + a_l1(6)*x.^5), 1);
    optimize(Constraints, Objective_l1, options);
    y_l1 = value(a_l1(1) + a_l1(2)*x + a_l1(3)*x.^2 + a_l1(4)*x.^3 + a_l1(5)*x.^4 + a_l1(6)*x.^5);

    % Минимизация суммы значений штрафной функции
    fun_penalty = @(a) sum(sqrt(abs(z_values - (a(1) + a(2)*x + a(3)*x.^2 + a(4)*x.^3 + a(5)*x.^4 + a(6)*x.^5))));
    a0_penalty = zeros(6, 1); % Начальная точка для оптимизации
    options_penalty = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
    [a_penalty_optimized, ~] = fmincon(fun_penalty, a0_penalty, [], [], [], [], [], [], [], options_penalty);
    y_penalty_numeric = a_penalty_optimized(1) + a_penalty_optimized(2)*x + a_penalty_optimized(3)*x.^2 + a_penalty_optimized(4)*x.^3 + a_penalty_optimized(5)*x.^4 + a_penalty_optimized(6)*x.^5;

    % Чебышевская аппроксимация
    Objective_chebyshev = norm(z_values - (a_chebyshev(1) + a_chebyshev(2)*x + a_chebyshev(3)*x.^2 + a_chebyshev(4)*x.^3 + a_chebyshev(5)*x.^4 + a_chebyshev(6)*x.^5), 'inf');
    optimize(Constraints, Objective_chebyshev, options);
    y_chebyshev = value(a_chebyshev(1) + a_chebyshev(2)*x + a_chebyshev(3)*x.^2 + a_chebyshev(4)*x.^3 + a_chebyshev(5)*x.^4 + a_chebyshev(6)*x.^5);

    % Построение графика всех результатов
    figure;
    plot(x, y_values, 'b', 'LineWidth', 2); % Истинные значения
    hold on;
    plot(x, z_values, 'r', 'LineWidth', 2); % Зашумленные измерения
    plot(x, y_least_squares, 'g', 'LineWidth', 2); % Наименьшие квадраты
    plot(x, y_l1, 'm', 'LineWidth', 2); % Минимизация суммы модулей ошибок
    plot(x, y_penalty_numeric, 'c', 'LineWidth', 2); % Штрафная функция
    plot(x, y_chebyshev, 'k', 'LineWidth', 2); % Чебышевская аппроксимация
    legend('Истинные значения', 'Зашумленные измерения', 'Наименьшие квадраты', 'Минимизация суммы модулей ошибок', 'Штрафная функция', 'Чебышевская аппроксимация');
    grid on;
    xlabel('x');
    ylabel('Values');
    title('Сравнение различных методов аппроксимации');
else
    disp('Не удалось найти решение');
end
