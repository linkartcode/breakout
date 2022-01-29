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

OptionsState = Class{__includes = BaseState}

function OptionsState:enter(params)
    self.currentPaddle = params.currentPaddle or 1
    self.music = params.music
    self.highScores = params.highScores
    self.highlighted = 1
end

function OptionsState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.highlighted = self.highlighted == 1 and 2 or 1
    end
    if love.keyboard.wasPressed('left') then
        if self.highlighted == 1 then
            self.music = not self.music
            if self.music then
                gSounds['music']:play()
            else
                gSounds['music']:pause()
            end
        else
            if self.currentPaddle == 1 then
                gSounds['no-select']:play()
            else
                gSounds['select']:play()
                self.currentPaddle = self.currentPaddle - 1
            end
        end
    elseif love.keyboard.wasPressed('right') then
        if self.highlighted == 1 then
            self.music = not self.music
            if self.music then
                gSounds['music']:play()
            else
                gSounds['music']:pause()
            end
        else
            if self.currentPaddle == 4 then
                gSounds['no-select']:play()
            else
                gSounds['select']:play()
                self.currentPaddle = self.currentPaddle + 1
            end
        end
    end

    -- select paddle and move on to the serve state, passing in the selection
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') 
        or love.keyboard.wasPressed('space') then
        gSounds['confirm']:play()

        gStateMachine:change('start', {
           currentPaddle = self.currentPaddle,
           highScores = self.highScores,
           music = self.music,
           highlighted = 2
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function OptionsState:render()
    -- instructions
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your options", 0, VIRTUAL_HEIGHT / 6, VIRTUAL_WIDTH, 'center')

    local music_status = self.music and "ON" or "OFF"
    
    if self.highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Music "..music_status, 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    if self.highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Select your paddle with left and right!", 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press Enter or Space to confirm!)", 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 6,
        VIRTUAL_WIDTH, 'center')
        
    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.currentPaddle == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
   
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1, 1)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1, 1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)],
        VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end