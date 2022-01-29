

MAX_BALLS = 9
D_VELOCITY = 9

Balls = Class{}

function Balls:init(ball)
	self.balls = {}
	table.insert(self.balls, ball)
end

function Balls:extra()
	local tmp_balls = {}
	for i, ball in pairs(self.balls) do
		if (#self.balls + #tmp_balls + 2) < MAX_BALLS then
			local velocity = math.sqrt(ball.dx^2 + ball.dy^2)
			local ball_dx = Ball(ball.skin)
			local ball_dy = Ball(ball.skin)
			if ball.dy > 0 then
				ball_dy.dy = ball.dy + D_VELOCITY
				ball_dy.y = ball.y - ball.height - 2
				ball_dx.dy = velocity - D_VELOCITY
				ball_dx.y = ball.y + ball.height + 2
			else
				ball_dy.dy = ball.dy - D_VELOCITY
				ball_dy.y = ball.y + ball.height + 2
				ball_dx.dy = velocity + D_VELOCITY
				ball_dx.y = ball.y - ball.height - 2
			end
			if ball.dx > 0 then
				ball_dx.dx = ball.dx + D_VELOCITY
				ball_dx.x = ball.x + ball.width + 2
				ball_dy.dx = velocity - D_VELOCITY
				ball_dy.x = ball.x - ball.width - 2
			else
				ball_dx.dx = ball.dx - D_VELOCITY
				ball_dx.x = ball.x - ball.width - 2
				ball_dy.dx = velocity + D_VELOCITY
				ball_dy.x = ball.x + ball.width + 2
			end
			table.insert(tmp_balls, ball_dx)
			table.insert(tmp_balls, ball_dy)
		end
	end
	for i, ball in pairs(self.balls) do
		table.insert(tmp_balls, ball)
	end
	self.balls = tmp_balls
end

function Balls:speedUp()
	for i, ball in pairs(self.balls) do
		ball:speedUp()
	end
end

function Balls:speedDown()
	for i, ball in pairs(self.balls) do
		ball:speedDown()
	end
end

function Balls:update(dt)
	for i, ball in pairs(self.balls) do
		ball:update(dt)
	end
end

function Balls:render()
	for i, ball in pairs(self.balls) do
		ball:render()
	end
end