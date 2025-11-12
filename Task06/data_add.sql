-- 1. Добавление новых пользователей
INSERT INTO users (name, email, gender, register_date, occupation_id)
VALUES 
('Максим Лузин', 'maxim.luzin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Роман Лемясев', 'roman.lemyasev@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'engineer')),
('Михаил Марьин', 'mikhail.marin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'programmer')),
('Максим Ларькин', 'maxim.larkin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Вадим Орлов', 'vadim.orlov@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student'));


INSERT INTO movies (title, year)
VALUES 
('Интерстеллар', 2014),
('Начало', 2010),
('Паразиты', 2019);


INSERT INTO movies_genres (movie_id, genre_id)
VALUES 
-- Интерстеллар: Sci-Fi, Drama, Adventure
((SELECT id FROM movies WHERE title = 'Интерстеллар'), 
 (SELECT id FROM genres WHERE name = 'Sci-Fi')),
((SELECT id FROM movies WHERE title = 'Интерстеллар'), 
 (SELECT id FROM genres WHERE name = 'Drama')),
((SELECT id FROM movies WHERE title = 'Интерстеллар'), 
 (SELECT id FROM genres WHERE name = 'Adventure')),

-- Начало: Action, Sci-Fi, Thriller
((SELECT id FROM movies WHERE title = 'Начало'), 
 (SELECT id FROM genres WHERE name = 'Action')),
((SELECT id FROM movies WHERE title = 'Начало'), 
 (SELECT id FROM genres WHERE name = 'Sci-Fi')),
((SELECT id FROM movies WHERE title = 'Начало'), 
 (SELECT id FROM genres WHERE name = 'Thriller')),

-- Паразиты: Drama, Thriller
((SELECT id FROM movies WHERE title = 'Паразиты'), 
 (SELECT id FROM genres WHERE name = 'Drama')),
((SELECT id FROM movies WHERE title = 'Паразиты'), 
 (SELECT id FROM genres WHERE name = 'Thriller'));

-- 4. Добавление отзывов
INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES 
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Интерстеллар'), 5.0, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Начало'), 4.5, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Паразиты'), 4.8, strftime('%s', 'now'));

-- 5. Добавление тегов
INSERT INTO tags (user_id, movie_id, tag, timestamp)
VALUES 
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Интерстеллар'), 'эпичный научная фантастика', strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Начало'), 'сложный сюжет сны', strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Паразиты'), 'социальная сатира оскар', strftime('%s', 'now'));