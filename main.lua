love.graphics.setDefaultFilter("nearest")

GameWidth = 1280
GameHeight = 720

BridgeHeight = 600
MinTruckX = -200
MaxTruckX = 200
TruckSpeed = 100
CrateSize = 60
CrateFallSpeed = 300

KeyForward = "w"
KeyBack = "s"
KeyMusic = "m"
KnowsTutorial = false

--Assets
TruckImages = {
	base = love.graphics.newImage("res/truck0.png"),
	brake = love.graphics.newImage("res/truck_brake.png"),
	small_smoke = love.graphics.newImage("res/truck_small_smoke.png"),
	smoke = love.graphics.newImage("res/truck_smoke.png"),
	storage = {}
}

for i = 1, 15 do
	TruckImages.storage[i] = love.graphics.newImage("res/truck"..i..".png")
end

BackgroundImages = {
	bridge = love.graphics.newImage("res/bridge.png"),
	sky = love.graphics.newImage("res/background.png"),
	trees = love.graphics.newImage("res/trees.png"),
	mountains = love.graphics.newImage("res/mountains.png"),
	deliver = love.graphics.newImage("res/deliver.png")
}

CrateImage = love.graphics.newImage("res/crate.png")
UIImage = love.graphics.newImage("res/ui.png")
MusicIcon = love.graphics.newImage("res/music_icon.png")
Music = love.audio.newSource("res/robozozo.ogg", "static")
Music:setVolume(0.1)
Music:setLooping(true)
DrawMusicIcon = true

CrateSound = love.audio.newSource("res/crate.ogg", "static")
CrateSound:setVolume(0.2)
MoneySound = love.audio.newSource("res/money.ogg", "static")
MoneySound:setVolume(0.2)

GameLogo = love.graphics.newImage("res/logo.png")

TreesSpeed = 300
MountainsSpeed = 60

Font = love.graphics.newFont("res/PressStart2P-Regular.ttf", 30)
SmallFont = love.graphics.newFont("res/PressStart2P-Regular.ttf", 24)

--States

CurrentState = nil
MenuState = require("menu")
WastedState = require("wasted")
GameState = require("game")

function setState(state)
	CurrentState = state
	CurrentState.init()
end

function stateUpdate(dt)
	if CurrentState ~= nil then
		CurrentState.update(dt)
	end
end

function stateDraw()
	if CurrentState ~= nil then
		CurrentState.draw()
	end
end

function stateKeyEvent(key)
	if CurrentState ~= nil then
		CurrentState.keyEvent(key)
	end
end

--Main Code

function love.load()
	love.window.setMode(GameWidth, GameHeight)
	love.window.setTitle("LD40 - Heavy Shipping - by Wincroufte")
	love.graphics.setFont(Font)
	setState(MenuState)
	Music:play()
end

function love.update(dt)
	stateUpdate(dt)
end

function love.draw()
	stateDraw()
end

function love.keypressed(key)
	stateKeyEvent(key)
end