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

require 'src/QuadOperate'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'statemachine/StateMachine'

require 'statemachine/states/BaseState'
require 'statemachine/states/EnterHighScoreState'
require 'statemachine/states/GameOverState'
require 'statemachine/states/HighScoreState'
require 'statemachine/states/OptionsState'
require 'statemachine/states/PlayState'
require 'statemachine/states/ServeState'
require 'statemachine/states/StartState'
require 'statemachine/states/VictoryState'