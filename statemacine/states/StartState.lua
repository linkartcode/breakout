--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

StartState = Class{__includes = BaseState}

function StartState:enter(params)
    self.highScores = params.highScores
    self.currentPaddle = params.currentPaddle or 1
    self.highlighted = params.highlighted or 1
    self.music = params.music or true
end

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') then
        self.highlighted = math.max(self.highlighted - 1, 1)
        gSounds['paddle-hit']:play()
    elseif love.keyboard.wasPressed('down') then
        self.highlighted = math.min(self.highlighted + 1, 3)
        gSounds['paddle-hit']:play()
    end

    -- confirm whichever option we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') 
            or love.keyboard.wasPressed('space') then
        gSounds['confirm']:play()

        if self.highlighted == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(self.currentPaddle),
                bricks = LevelMaker.createMap(1),
                health = 3,
                score = 0,
                highScores = self.highScores,
                level = 1,
                recoverPoints = 5000
            })
        elseif self.highlighted == 2 then
            gStateMachine:change('options', {
                currentPaddle = self.currentPaddle,
                highScores = self.highScores,
                music = self.music
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if we're highlighting 1, render that option blue
    if self.highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 50,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    if self.highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("OPTIONS", 0, VIRTUAL_HEIGHT / 2 + 70,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    if self.highlighted == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end