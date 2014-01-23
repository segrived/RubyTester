# RubyTester
RubyTester - система тестирования студентов, написанная на языке Ruby с использованием фреймворка Ruby On Rails.

## Установка
* Убедиться, что MongoDB установлен и настроен
* Настроить параметры подключения к MongoDB в `/config/mongoid.yml`
* Установить необходимый набор gem'ов командой `bundle install`
* Создать индексы командой `rake db:mongoid:create_indexes`
* Создать аккаунт администратора командой `rake db:seed`
* Войти в систему используя логин `rubytester` и пароль `rubytester`
* Сменить стандартный пароль для администратора системы

## Запуск сервера
Запустить сервер можно используя команду `rails s Puma`

## Замечания
Возможно, что необходимо будет также установить node.js (либо можно использовать gem `therubytracer`)

## Резервное копирование и восстановление данных
Для резервного копирования можно воспользоваться командой `rake db:data:dump`. Для восстановления данных из дампа — `rake db:data:load`.