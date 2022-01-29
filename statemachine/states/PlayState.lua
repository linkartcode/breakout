--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

CHANCE_BALLS = 5
CHANCE_PADDLE_REDUCE = 10
CHANCE_PADDLE_INCREASE = 10
CHANCE_BALL_SPEED_UP = 10
CHANCE_BALL_SPEED_DOWN = 10
CHANCE_EXTRA_LIFE = 3
CHANCE_KEY = 1

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = Balls(params.ball)
    self.level = params.level

    -- give ball random starting velocity
    self.balls.balls[1].dx = math.random(-200 * math.sqrt(self.level) * 0.2, 200 * math.sqrt(self.level) * 0.2)
    self.balls.balls[1].dy = math.random(-50, -70)

    self.powerups = {}
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('p') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('p') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.balls:update(dt)
    for i, powerup in pairs(self.powerups) do
        powerup:update(dt)
    end
    for i, powerup in pairs(self.powerups) do
        if powerup:isout() then
            table.remove(self.powerups, i)
        end
    end

    for i, ball in pairs(self.balls.balls) do
        
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
            gSounds['paddle-hit']:play()
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- add to score
                self.score = self.score + (brick.tier * 200 + brick.color * 25)

                -- trigger the brick's hit function, which removes it from play
                brick:hit()
                self:generatePowerUp(brick.x, brick.y)

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = ball
                    })
                end

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game
                    ball:speedInc()
                break
            end
        end

        -- if ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls.balls, i)
            if (#self.balls.balls < 1) then
                self.health = self.health - 1
                gSounds['hurt']:play()

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                else
                    if self.paddle.size > 2 then
                        self.paddle:changeSize(2)
                    end
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level
                    })
                end
            end
        end
    end
    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    for i, powerup in pairs(self.powerups) do
        if (powerup:collides(self.paddle)) then
            self:powerupAct(powerup.type)
            table.remove(self.powerups, i)
            gSounds["confirm"]:play()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    for i, powerup in pairs(self.powerups) do
        powerup:render()
    end

    self.paddle:render()
    self.balls:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end

function PlayState:generatePowerUp(x, y)
    if getRandom(CHANCE_BALLS) then
        table.insert(self.powerups, Powerup(x, y, 8))
    elseif getRandom(CHANCE_BALL_SPEED_UP) then
        table.insert(self.powerups, Powerup(x, y, 4))
    elseif getRandom(CHANCE_BALL_SPEED_DOWN) then
        table.insert(self.powerups, Powerup(x, y, 5))
    elseif getRandom(CHANCE_EXTRA_LIFE) then
        table.insert(self.powerups, Powerup(x, y, 2))
    elseif getRandom(CHANCE_PADDLE_INCREASE) then
        table.insert(self.powerups, Powerup(x, y, 7))
    elseif getRandom(CHANCE_PADDLE_REDUCE) then
        table.insert(self.powerups, Powerup(x, y, 6))
    end
end

function PlayState:powerupAct(type)
    if type == 2 then
        self:healthPlus()
    elseif type == 4 then
        self.balls:speedUp()
    elseif type == 5 then
        self.balls:speedDown()
    elseif type == 7 then
        self.paddle:changeSize(self.paddle.size + 1)
    elseif type == 6 then
        self.paddle:changeSize(self.paddle.size - 1)
    elseif type == 8 then
        self.balls:extra()
    end
end

function PlayState:healthPlus()
    self.health = math.min(3, self.health + 1)
    gSounds['recover']:play()
end
