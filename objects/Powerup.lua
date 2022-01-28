BASE_DY = 30

Powerup = Class{}

function Powerup:init(x, y, type)

	self.x = x
	self.y = y
	self.width = 16
	self.height = 16
	self.type = type
	self.dy = BASE_DY
end

function Powerup:update(dt)
	self.y = self.y + self.dy * dt
end

function Powerup:render()
	love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type],
        self.x, self.y)
end

function Powerup:collides(paddle)
	if (self.x + self.width) < paddle.x or self.x > (paddle.x + paddle.width) then 
		return false
	end
	if (self.y + self.height) < paddle.y or self.y > (paddle.y + paddle.height) then
		return false
	end
	return true
end

function Powerup:isout()
	if self.y > VIRTUAL_HEIGHT then
		return true
	end
	return false
end