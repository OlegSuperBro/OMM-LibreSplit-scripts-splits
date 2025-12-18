local GAMES = {}

GAMES[0] = {
    processName = 'sm64.smex',
    doneAfterSegment = 31
}
GAMES[1] = {
    processName = 'sm64.smsr.exe',
    doneAfterSegment = 39
}
-- GAMES[2] = {
--     processName = 'sm64.sm74.exe',
--     doneAfterSegment = 0
-- }

local codes = {
    RESET = -1,
    START = -2,
}

local started = false

local isGameChanging = false

local currentGameIndex = 0
local currentGameStage = 0

local splitPtr = 0x0

process(GAMES[0].processName)

function updateGameProcess()
    process(GAMES[currentGameIndex].processName)
end

function startup()
    refreshRate = 60
    useGameTime = false
end

function state()
    splitPtr = sig_scan("4F 4D 4D 41 55 54 4F 53 50 4C 49 54", 0) + 0xC
end

function getCurrentState()
    return readAddress("int", splitPtr)
end

function start()
    local shouldStart = getCurrentState() == codes.START

    if shouldStart then
        started = true
    end

    return shouldStart
end

function split()
    local state = getCurrentState()

    if state > currentGameStage then
        if state > GAMES[currentGameIndex].doneAfterSegment then 
            print(string.format("state %d is bigger than %d. reseting variables", state, GAMES[currentGameIndex].doneAfterSegment))
            isGameChanging = true
            currentGameStage = 0
            currentGameIndex = currentGameIndex + 1
            splitPtr = 0x0
            print("Game is done. Starting wait for next game in \"reset\" stage")
            return true
        end

        currentGameStage = state
        return true
    end

    return false
end

function isLoading()
    if (isGameChanging and splitPtr ~= 0 and (getCurrentState() == codes.START)) then
        isGameChanging = false
    end
    return isGameChanging
end

function reset()
    -- This looks weird, but let me explain
    -- This splitter stops execution when trying to change process via process()
    -- But i need to stop timer and only then stop that execution or else it will continue counting.
    -- This function is called as last one and after isLoading, which means it's the only place that can execute code,
    -- After timers is paused via isLoading
    if (isGameChanging) then
        updateGameProcess()
    end


    local shouldReset = getCurrentState() == codes.RESET
    
    return shouldReset and started and (currentGameIndex == 0)
end
