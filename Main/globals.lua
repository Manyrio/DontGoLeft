--======= general locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

SELECTED_SCENE = "test"

SELECTED_WORLD = false


EVENT_UPDATE = {}
EVENT_DRAW = {}
EVENT_KEYDOWN = {}
EVENT_KEYUP = {}

CAMERA = {}
CAMERA.X = 0
CAMERA.Y = 0

CAMERA.offsetX = SCREEN_WIDTH/2
CAMERA.offsetY = SCREEN_HEIGHT/2

GAME = {}
GAME.SPEED = 1
GAME.TIME = 0

mouse = {}
mouse.x = 0
mouse.y = 0

GRAVITY = 500

TUB_SIZE = 16

BUCKET_XCOUNT = floor(SCREEN_WIDTH/TUB_SIZE + 0.5)
BUCKET_YCOUNT = floor(SCREEN_HEIGHT/TUB_SIZE + 0.5)

BUCKET_WIDTH = BUCKET_XCOUNT*TUB_SIZE
BUCKET_HEIGHT = BUCKET_YCOUNT*TUB_SIZE

CRASH_WHEN_GOING_TO_THE_LEFT = false

math.randomseed(40)

--=============================================
World = {}

KEYDOWN_BINDING = {}

KEYPRESS_BINDING = {}
KEYRELEASE_BINDING = {}

--=============================================

GUI = {}
