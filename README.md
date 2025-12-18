It's my small collection of splits and script for autosplits

That's all what you need to know:
- SM64_OMM_Multigame.lua - autosplit script for [LibreSplit](https://github.com/LibreSplit/LibreSplit).
- LiveSplit - folder, containing all splits i use for games. For more info check [this](https://github.com/PeachyPeachSM64/sm64ex-omm/tree/master?tab=readme-ov-file#livesplit-autosplit). TL;DR put file in according game and rename it to `splits.lss`.
- LibreSplit - folder, containing splits for app. Contains single game splits and multigame splits.

## Game names
|Name|Full name|
|-|-|
|SM64|Super Mario 64|
|SMSR|Super Mario Star Road|
|SM74|Super Mario 74|
|SM74EE|Super Mario 74 Extreme Edition|
|SMMS|Super Mario Moonshine|

## Adding more OMM romhacks/games
To add new game, you should add:
```lua
GAMES[i] = {
    processName = 'some_process.exe',
    doneAfterSegment = 69
}
```
Where:
- `i` - last index (ALL INDEXES MUST GO IN ORDER)
- `processName` - name of the game process (duh)
- `doneAfterSegment` - Stop timer after this stage is done. For example, if sm64 have 32 segments (where 32nd is grand star), you should put 31