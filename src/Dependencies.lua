-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'libs/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'libs/class'

-- a few global constants, centralized
require 'src/constants'

-- objects
require 'objects/Ball'
require 'objects/Brick'
require 'objects/Paddle'
require 'objects/Balls'
require 'objects/Powerup'

-- a class used to generate our brick layouts (levels)
require 'src/LevelMaker'

-- utility functions, mainly for splitting our sprite sheet into various Quads
-- of differing sizes for paddles, balls, bricks, etc.
require 'src/QuadOperate'

--
--require 'src/Utils'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'statemacine/StateMachine'
-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'statemacine/states/BaseState'
require 'statemacine/states/EnterHighScoreState'
require 'statemacine/states/GameOverState'
require 'statemacine/states/HighScoreState'
require 'statemacine/states/OptionsState'
require 'statemacine/states/PlayState'
require 'statemacine/states/ServeState'
require 'statemacine/states/StartState'
require 'statemacine/states/VictoryState'