# iterm-tab-colors

Плагин Claude Code: красит вкладку iTerm2 по состоянию сессии — видно издалека, какая из вкладок ждёт тебя, а какая ещё работает.

| Цвет | Состояние |
|---|---|
| 🟠 оранжевый | Claude работает (промпт отправлен, тулзы крутятся) |
| 🟣 фиолетовый | ждёт тебя: запрос пермишена или вопрос |
| 🟢 зелёный | закончил ход |
| 🔴 красный | ход упал с ошибкой |

Работает только в iTerm2 (проприетарные escape-коды `OSC 6`). Скрипт сам находит tty сессии, поднимаясь по родительским процессам (у хуков Claude Code stdout перехвачен, `/dev/tty` отвязан), и не красит чужие вкладки из фоновых/демон-сессий.

## Установка

В Claude Code:

```
/plugin marketplace add VenchasS/iterm-tab-colors
/plugin install iterm-tab-colors@iterm-tab-colors
```

Или из локальной копии: `/plugin marketplace add /путь/к/iterm-tab-colors`.

Быстро попробовать без установки:

```sh
claude --plugin-dir /путь/к/iterm-tab-colors/plugin
```

## Сброс цвета

Вкладка остаётся крашеной после выхода из Claude Code. Сбросить руками:

```sh
sh plugin/scripts/tab-color.sh reset
```
