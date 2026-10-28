# Roblox Essentials 🚀

**Самый полезный набор модулей для любой Roblox-игры**  
Идеально для разработки на **ПК** в Roblox Studio.

Это не просто библиотека — это всё, что нужно почти каждому разработчику.  
Копируешь модули и сразу используешь.

## Что входит (всё уже готово)

| Модуль | Описание |
|--------|----------|
| **Maid** | Автоматическая очистка соединений, объектов и тасков |
| **Signal** | Быстрые и лёгкие события (лучше BindableEvent) |
| **Promise** | Простая реализация Promise для асинхронного кода |
| **DataStore** | Надёжный wrapper для DataStore с кэшем и повторами |
| **Notifications** | Красивые анимированные уведомления игрокам |
| **TableUtils** | Удобные функции для работы с таблицами |
| **NumberFormat** | Форматирование чисел (1.2K, 3.4M, 1.5B) |
| **PlayerUtils** | Полезные функции для работы с игроками |

## Установка (на ПК в Studio)

1. Скачай репозиторий (Code → Download ZIP) или клонируй
2. Распакуй и скопируй папку `src` в **ReplicatedStorage** (переименуй в `Essentials` для удобства)
3. Требуй модули:

```lua
local Essentials = game.ReplicatedStorage:WaitForChild("Essentials") -- или src

local Maid = require(Essentials.Maid)
local Signal = require(Essentials.Signal)
local Promise = require(Essentials.Promise)
local DataStore = require(Essentials.DataStore)
local Notifications = require(Essentials.Notifications)
local TableUtils = require(Essentials.TableUtils)
local NumberFormat = require(Essentials.NumberFormat)
local PlayerUtils = require(Essentials.PlayerUtils)
```

## Примеры использования

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

### Promise
```lua
local p = Promise.new(function(resolve, reject)
	task.wait(1)
	resolve("Готово!")
end)

p:andThen(function(result)
	print(result)
end):catch(function(err)
	warn(err)
end)
```

### DataStore
```lua
local store = DataStore.new("PlayerData")

local data = store:GetPlayerData(player, {Coins = 0, Level = 1})
data.Coins += 100
store:SavePlayerData(player, data)
```

### Notifications (клиент)
```lua
Notifications.Success("Покупка успешна!")
Notifications.Error("Недостаточно монет")
Notifications.Info("Новый уровень!")
Notifications.Warning("Осторожно!")
```

### NumberFormat
```lua
print(NumberFormat(1500))       --> 1.5K
print(NumberFormat(2500000))    --> 2.5M
print(NumberFormat(1200000000)) --> 1.2B
```

### PlayerUtils
```lua
PlayerUtils.Teleport(player, Vector3.new(0, 10, 0))
PlayerUtils.Heal(player)
PlayerUtils.SetSpeed(player, 30)

local target = PlayerUtils.FindByName("Rob", true) -- частичный поиск
```

### TableUtils
```lua
local copy = TableUtils.DeepCopy(myTable)
local merged = TableUtils.Merge(t1, t2)
print(TableUtils.Count(myTable))
```

## Почему это полезно именно на ПК

- Работаешь в Roblox Studio на компьютере — всё копируется за 10 секунд
- Не нужно писать одно и то же в каждом проекте
- Проверенный и чистый код
- Лёгкий и быстрый
- Легко расширяется под свои нужды

## Лицензия

MIT — делай что хочешь.

---

**Сделано с ❤️ для сообщества Roblox**  
Репозиторий: https://github.com/fima4335/roblox-essentials
