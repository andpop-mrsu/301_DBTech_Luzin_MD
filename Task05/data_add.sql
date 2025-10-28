-- Файл data_add.sql
-- Добавление новых данных в нормализованную базу

-- 1. Добавление новых пользователей (себя и соседей по группе)
INSERT OR IGNORE INTO users (name, email, gender, occupation_id)
VALUES 
('Максим Лузин', 'maxim.luzin@example.com', 'male', 
    (SELECT id FROM occupations WHERE name = 'student')),
('Роман Лемясев', 'roman.lemyasev@example.com', 'male', 
    (SELECT id FROM occupations WHERE name = 'engineer')),
('Михаил Марьин', 'mikhail.marin@example.com', 'male', 
    (SELECT id FROM occupations WHERE name = 'programmer')),
('Максим Ларькин', 'maxim.larkin@example.com', 'male', 
    (SELECT id FROM occupations WHERE name = 'student')),
('Вадим Орлов', 'vadim.orlov@example.com', 'male', 
    (SELECT id FROM occupations WHERE name = 'student'));

-- 2. Добавление новых фильмов
INSERT OR IGNORE INTO movies (title, year)
VALUES 
('Интерстеллар', 2014),
('Начало', 2010),
('Паразиты', 2019);

-- 3. Добавление жанров для новых фильмов (если их еще нет)
INSERT OR IGNORE INTO genres (name) 
VALUES 
('Sci-Fi'),
('Thriller'), 
('Drama'),
('Action'),
('Adventure');

-- 4. Связывание фильмов с жанрами
INSERT OR IGNORE INTO movies_genres (movie_id, genre_id)
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

-- 5. Добавление отзывов от себя 
INSERT OR IGNORE INTO ratings (user_id, movie_id, rating)
VALUES 
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Интерстеллар'), 5.0),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Начало'), 4.5),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Паразиты'), 4.8);

-- 6. Добавление тегов от себя 
INSERT OR IGNORE INTO tags (user_id, movie_id, tag)
VALUES 
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Интерстеллар'), 'эпичный научная фантастика'),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Начало'), 'сложный сюжет сны'),
((SELECT id FROM users WHERE email = 'maxim.luzin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Паразиты'), 'социальная сатира оскар');