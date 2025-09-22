#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import csv
import sqlite3
from pathlib import Path

class DatabaseGenerator:
    def __init__(self, dataset_path="dataset", db_name="movies_rating.db"):
        self.dataset_path = Path(dataset_path)
        self.db_name = db_name
        self.sql_script = "db_init.sql"
        
        # Структура таблиц
        self.tables = {
            'movies': {
                'columns': [
                    ('id', 'INTEGER PRIMARY KEY'),
                    ('title', 'TEXT'),
                    ('year', 'INTEGER'),
                    ('genres', 'TEXT')
                ],
                'source_file': 'movies.csv'
            },
            'ratings': {
                'columns': [
                    ('id', 'INTEGER PRIMARY KEY'),
                    ('user_id', 'INTEGER'),
                    ('movie_id', 'INTEGER'),
                    ('rating', 'REAL'),
                    ('timestamp', 'INTEGER')
                ],
                'source_file': 'ratings.csv'
            },
            'tags': {
                'columns': [
                    ('id', 'INTEGER PRIMARY KEY'),
                    ('user_id', 'INTEGER'),
                    ('movie_id', 'INTEGER'),
                    ('tag', 'TEXT'),
                    ('timestamp', 'INTEGER')
                ],
                'source_file': 'tags.csv'
            },
            'users': {
                'columns': [
                    ('id', 'INTEGER PRIMARY KEY'),
                    ('name', 'TEXT'),
                    ('email', 'TEXT'),
                    ('gender', 'TEXT'),
                    ('register_date', 'TEXT'),
                    ('occupation', 'TEXT')
                ],
                'source_file': 'users.txt'
            }
        }

    def generate_sql_script(self):
        """Генерация SQL-скрипта"""
        print("Генерация SQL-скрипта...")
        
        with open(self.sql_script, 'w', encoding='utf-8') as f:
            # Удаление существующих таблиц
            f.write("-- Удаление существующих таблиц\n")
            for table_name in self.tables.keys():
                f.write(f"DROP TABLE IF EXISTS {table_name};\n")
            
            f.write("\n")
            
            # Создание таблиц
            f.write("-- Создание таблиц\n")
            for table_name, table_info in self.tables.items():
                columns_def = ", ".join([f"{col[0]} {col[1]}" for col in table_info['columns']])
                f.write(f"CREATE TABLE {table_name} ({columns_def});\n")
            
            f.write("\n")
            
            # Вставка данных
            f.write("-- Вставка данных\n")
            for table_name, table_info in self.tables.items():
                source_file = self.dataset_path / table_info['source_file']
                if source_file.exists():
                    columns = [col[0] for col in table_info['columns']]
                    columns_str = ", ".join(columns)
                    
                    f.write(f"-- Данные для таблицы {table_name}\n")
                    
                    with open(source_file, 'r', encoding='utf-8') as csv_file:
                        reader = csv.reader(csv_file)
                        next(reader)  # Пропускаем заголовок
                        
                        for row in reader:
                            # Экранирование специальных символов
                            escaped_row = []
                            for value in row:
                                if value is None or value == '':
                                    escaped_row.append("NULL")
                                else:
                                    escaped_value = str(value).replace("'", "''")
                                    escaped_row.append(f"'{escaped_value}'")
                            
                            values_str = ", ".join(escaped_row)
                            f.write(f"INSERT INTO {table_name} ({columns_str}) VALUES ({values_str});\n")
                    
                    f.write("\n")
                else:
                    print(f"Предупреждение: Файл {source_file} не найден")
        
        print(f"SQL-скрипт {self.sql_script} успешно создан!")
        return True

    def create_database(self):
        """Создание базы данных напрямую из Python"""
        print("Создание базы данных...")
        
        # Удаляем существующую базу
        if os.path.exists(self.db_name):
            os.remove(self.db_name)
        
        # Создаем соединение с базой
        conn = sqlite3.connect(self.db_name)
        cursor = conn.cursor()
        
        try:
            # Создаем таблицы
            for table_name, table_info in self.tables.items():
                columns_def = ", ".join([f"{col[0]} {col[1]}" for col in table_info['columns']])
                cursor.execute(f"CREATE TABLE {table_name} ({columns_def})")
            
            # Вставляем данные
            for table_name, table_info in self.tables.items():
                source_file = self.dataset_path / table_info['source_file']
                if source_file.exists():
                    print(f"Загрузка данных в таблицу {table_name}...")
                    
                    with open(source_file, 'r', encoding='utf-8') as csv_file:
                        reader = csv.reader(csv_file)
                        next(reader)  # Пропускаем заголовок
                        
                        columns = [col[0] for col in table_info['columns']]
                        placeholders = ", ".join(["?"] * len(columns))
                        
                        batch_size = 1000
                        batch = []
                        
                        for row in reader:
                            # Обрабатываем пустые значения
                            processed_row = []
                            for value in row:
                                if value == '':
                                    processed_row.append(None)
                                else:
                                    processed_row.append(value)
                            
                            batch.append(tuple(processed_row))
                            
                            if len(batch) >= batch_size:
                                cursor.executemany(
                                    f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({placeholders})",
                                    batch
                                )
                                batch = []
                        
                        # Вставляем оставшиеся данные
                        if batch:
                            cursor.executemany(
                                f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({placeholders})",
                                batch
                            )
            
            conn.commit()
            print(f"База данных {self.db_name} успешно создана!")
            return True
            
        except Exception as e:
            print(f"Ошибка при создании базы данных: {e}")
            conn.rollback()
            return False
        finally:
            conn.close()

def main():
    generator = DatabaseGenerator()
    
    # Проверяем существование каталога dataset
    if not generator.dataset_path.exists():
        print(f"Ошибка: Каталог {generator.dataset_path} не найден!")
        print("Пожалуйста, создайте каталог 'dataset' и поместите в него CSV файлы:")
        print("- movies.csv")
        print("- ratings.csv")
        print("- tags.csv")
        print("- users.csv")
        return 1
    
    # Генерируем SQL-скрипт
    generator.generate_sql_script()
    
    # Создаем базу данных
    success = generator.create_database()
    
    return 0 if success else 1

if __name__ == "__main__":
    exit(main())