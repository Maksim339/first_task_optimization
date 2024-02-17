# Отчет о Работе №1. Аппроксимация.

## Введение

В данной работе была поставлена задача построения многочлена пятой степени, удовлетворяющего определенным ограничениям, а также аппроксимации этого многочлена с использованием различных методов на фоне внесения белого гауссовского шума и дополнительной случайной помехи.

## Описание Работы

### Задача 1: Построение Многочлена

Многочлен пятой степени $`p(x)`$ был построен с учетом следующих ограничений:
- $`0 \leq p(x[i]) \leq 5 `$  для $`x[i] = 0.1i `$, где $` i = 0, ..., 100 `$.
- Специфические ограничения в определенных точках, такие как $` p(0) \leq 1 `$, $` p(3) \geq 4 `$, и т.д.

Был использован метод оптимизации с помощью инструментов YALMIP и SDPT3 в MATLAB для нахождения коэффициентов многочлена.

#### График 1
![img.png](graphs/img.png)

На первом графике представлен построенный многочлен на интервале от 0 до 10.

### Задача 2: Зашумленные Измерения

К истинным значениям многочлена был добавлен белый гауссовский шум с дисперсией 0.3 для создания зашумленных измерений.

#### График 2
![img_1.png](graphs/img_1.png)

На втором графике изображены истинные значения многочлена и зашумленные измерения.

### Задача 3: Аппроксимация

Использовались четыре метода аппроксимации для оценки коэффициентов многочлена по зашумленным измерениям:
1. Метод наименьших квадратов.
2. Минимизация суммы модулей ошибок.
3. Минимизация суммы значений штрафной функции $` \sqrt[|t|] `$.
4. Чебышевская аппроксимация.

#### График 3
![img_2.png](graphs/img_2.png)

На третьем графике представлены истинные значения многочлена, зашумленные измерения и результаты всех четырех методов аппроксимации.

### Задача 4: Дополнительное Зашумление

Была добавлена дополнительная помеха к зашумленным измерениям. Помеха принимает значение 0 с вероятностью 0.9 и случайное значение от -20 до 20 (по модулю не менее 10) с вероятностью 0.1.

#### График 4
![img_5.png](graphs/img_5.png)


### Задача 5: Аппроксимация по дополнительному зашумлению

Была добавлена дополнительная помеха к зашумленным измерениям. Помеха принимает значение 0 с вероятностью 0.9 и случайное значение от -20 до 20 (по модулю не менее 10) с вероятностью 0.1.

#### График 5
![img_4.png](graphs/img_4.png)

На четвертом графике представлены истинные значения многочлена и зашумленные измерения с дополнительной помехой.

## Анализ и Сравнение Результатов

Сравнительный анализ различных методов аппроксимации был проведен на основе L2 ошибки (среднеквадратической ошибки) между истинными значениями многочлена и значениями, полученными с помощью каждого метода. Было обнаружено, что [описание результатов сравнения различных методов, их эффективности и точности в контексте обоих типов шума].

## Выводы

