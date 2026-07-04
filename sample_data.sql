-- Пример данных для проекта Customer Orders BI Analysis

INSERT INTO customers (customer_id, customer_name, city, registration_date) VALUES
(1, 'Ivan Petrov', 'Moscow', '2026-01-10'),
(2, 'Anna Smirnova', 'Saint Petersburg', '2026-01-15'),
(3, 'Pavel Ivanov', 'Kazan', '2026-02-01'),
(4, 'Maria Volkova', 'Moscow', '2026-02-10'),
(5, 'Dmitry Sokolov', 'Novosibirsk', '2026-03-05'),
(6, 'Elena Orlova', 'Kazan', '2026-03-20'),
(7, 'Alexey Morozov', 'Moscow', '2026-04-01');

INSERT INTO orders (order_id, customer_id, order_date, amount, status) VALUES
(101, 1, '2026-04-05', 1200.00, 'paid'),
(102, 1, '2026-04-10', 450.00, 'paid'),
(103, 2, '2026-04-12', 800.00, 'unpaid'),
(104, 2, '2026-04-15', 1500.00, 'paid'),
(105, 3, '2026-04-20', 300.00, 'canceled'),
(106, 4, '2026-05-01', 700.00, 'paid'),
(107, 4, '2026-05-03', 950.00, 'paid'),
(108, 5, '2026-05-07', 200.00, 'unpaid'),
(109, 6, '2026-05-12', 1100.00, 'paid'),
(110, 6, '2026-05-15', 650.00, 'paid');
