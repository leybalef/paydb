# [Домой](./README.MD)
### Описание схемы `user`

## Таблицы

### `settings`
Список настроек доступных пользователю
| Название поля | Тип данных | Описание поля          |
|----------------|------------|------------------------|
| id_list        | int2       | Первичный ключ, автоинкрементный идентификатор настроек |
| list_contact   | varchar(50)| Содержит контактные данные |

### `user_settings`
| Название поля  | Тип данных   | Описание поля          |
|----------------|--------------|------------------------|
| id_contact     | int8         | Первичный ключ, автоинкрементный идентификатор контакта |
| contact        | varchar(50)  | Контактная информация  |
| type_contact   | int2         | Тип контакта           |
| uuid_drive     | varchar(50)  | UUID, связывает настройки с пользователем |
| enable         | bool         | Включены ли настройки  |
| required       | bool         | Обязательны ли настройки |
| type_settings  | `settings_enum`| Категория настроек     |

### `usergroup`
| Название поля  | Тип данных     | Описание поля          |
|----------------|----------------|------------------------|
| id_usergroup   | smallserial    | Первичный ключ, идентификатор группы пользователей |
| name_usergroup | varchar(255)   | Имя группы             |
| change_role    | `usergroup_enum` | Тип изменения роли (автоматически или ручками)    |

### `users`
| Название поля   | Тип данных     | Описание поля          |
|-----------------|----------------|------------------------|
| idpriv          | serial4        | Уникальный идентификатор пользователя |
| fljson_privilege| jsonb          | Данные о привилегиях пользователя |
| uuid_key        | uuid           | Первичный ключ пользователя |
| login           | varchar(50)    | Логин пользователя     |
| pass_hash       | varchar(50)    | Хешированный пароль    |
| datetime        | timestamp(6)   | Время создания записи  |
| enable          | bool           | Активен ли пользователь|

#### `mv_phone` (Материализованное представление)
| Название поля | Тип данных | Описание поля          |
|---------------|------------|------------------------|
| uuid_drive    | uuid       | UUID, связывает пользователя с настройками |
| contact       | varchar    | Контактная информация пользователя |

---
---

## Перечисления (Enums)
**settings_enum**
- `cont`
- `core`
- `role`
- `firm`

**usergroup_enum**
- `auto`
- `hand`

---
---
## Функции

**`f_phone(xphone bpchar)`**
- Возвращает текущий баланс пользователя по номеру телефона.

**`f_role()`**
- Возвращает список ролей для автоматического назначения.

**`f_tr_user_contact()`**
- Триггерная функция, обновляющая материализованное представление `mv_phone`.

---
---

## Триггеры

**`f_tr_user_contact`**
- Применяется после вставки или обновления в `user_settings`.
- Вызывает `f_tr_user_contact` для обновления `mv_phone`.