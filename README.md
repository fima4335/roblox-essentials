# Roblox Essentials 🚀

**Самый полезный набор модулей для любой Roblox-игры**

Это не просто библиотека — это всё, что нужно почти каждому разработчику.  
Копируешь модули и сразу используешь.

## Что входит

| Модуль | Описание |
|--------|----------|
| **Maid** | Автоматическая очистка соединений, объектов и тасков |
| **Signal** | Быстрые и лёгкие события (лучше BindableEvent) |
| **Promise** | Простая реализация Promise для асинхронного кода |
| **DataStore** | Надёжный wrapper для DataStore с кэшем и повторами |
| **Notifications** | Красивые уведомления игрокам |
| **TableUtils** | Удобные функции для работы с таблицами |
| **NumberFormat** | Форматирование чисел (1.2K, 3.4M, 1.5B) |
| **PlayerUtils** | Полезные функции для работы с игроками |

## Установка

1. Скачай репозиторий
2. Скопируй папку `src` в **ReplicatedStorage** (или в ServerStorage/где удобно)
3. Требуй модули:

```lua
local Essentials = game.ReplicatedStorage.Essentials
local Maid = require(Essentials.Maid)
local Signal = require(Essentials.Signal)
local Notifications = require(Essentials.Notifications)
```

## Примеры

### Maid
```lua
local maid = Maid.new()

maid:GiveTask(workspace.ChildAdded:Connect(function()
	print("Новый объект!")
end))

maid:GiveTask(somePart) -- удалит при очистке

maid:DoCleaning() -- очистить всё
```

### Signal
```lua
local mySignal = Signal.new()

mySignal:Connect(function(value)
	print("Получили:", value)
end)

mySignal:Fire(123)
```

### Notifications
```lua
Notifications:Notify(player, "Добро пожаловать!", Color3.fromRGB(0, 255, 100))
Notifications:Success(player, "Покупка успешна!")
Notifications:Error(player, "Недостаточно монет")
```

### NumberFormat
```lua
local NumberFormat = require(Essentials.NumberFormat)
print(NumberFormat(1500))      --> 1.5K
print(NumberFormat(2500000))   --> 2.5M
print(NumberFormat(1200000000)) --> 1.2B
```

## Почему это полезно

- Не нужно писать одно и то же в каждом проекте
- Проверенный и чистый код
- Лёгкий и быстрый
- Легко расширяется

## Лицензия

MIT — делай что хочешь.

---

**Сделано с ❤️ для сообщества Roblox**
