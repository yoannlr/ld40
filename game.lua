state = {}

scrolling = {
	mountains = {
		speed = 100,
		x1 = 0,
		x2 = 1280
	},
	trees = {
		speed = 300,
		x1 = 0,
		x2 = 1280
	},
	bridge = {
		speed = 400,
		x1 = 0,
		x2 = 0,
		y = 0
	}
}

truck = {}
truck.x = 0
truck.storage = 0
truck.width = 400
truck.height = 150
truck.drawX = GameWidth / 2 - truck.width / 2
truck.immuneToCrates = false
truck.money = 0
truck.brake = false
truck.smoke = false

cratesTimer = 2
nextDeliver = 4000

message = {
	text = nil,
	x = nil,
	y = nil,
	width = nil,
}

header = {
	text = nil,
	duration = nil,
	x = nil,
}

happyHeaders = {"Money money !", "Yay !", "Oh yeah !", "Nice !", "Good !"}

crates = {}

function spawnCrate(x)
	local c = {}
	c.x = x
	c.y = -100
	c.d = math.random(1, 100)
	if math.random(2) == 2 then
		c.d = c.d * -1
	end
	table.insert(crates, c)
end

function updateWeight()
	TruckSpeed = 100 - 5 * truck.storage
	scrolling.bridge.speed = 400 - 3 * (100 - TruckSpeed)
	scrolling.trees.speed = 300 - 2 * (100 - TruckSpeed)
	scrolling.mountains.speed = 100 - (100 - TruckSpeed)
end

function resetSpeed()
	TruckSpeed = 100
	scrolling.bridge.speed = 400
	scrolling.trees.speed = 300
	scrolling.mountains.speed = 100
end

function resetGame()
	resetSpeed()
	scrolling.mountains.x1 = 0
	scrolling.mountains.x2 = 1280
	scrolling.trees.x1 = 0
	scrolling.trees.x2 = 1280
	scrolling.bridge.x1 = 0
	scrolling.bridge.x2 = 1280
	scrolling.bridge.y = 0
	nextDeliver = 4000
	truck.x = -180
	truck.money = 0
	header.text = nil
	message.text = nil
end

function cratesUpdate(dt)
	for i,crate in pairs(crates) do
		crate.y = math.floor(crate.y + CrateFallSpeed * dt + 0.6)
		crate.x = math.floor(crate.x - TruckSpeed * dt - crate.d * dt + 0.6)
		
		if crate.x >= truck.x and crate.x <= truck.x + truck.width and crate.y >= BridgeHeight - truck.height and crate.y <= BridgeHeight then
			if not truck.immuneToCrates then
				truck.storage = truck.storage + 1
				table.remove(crates, i)
				CrateSound:play()
				updateWeight()
			end
		end

		if crate.y > GameHeight + 100 then
			table.remove(crates, i)
		end
	end
end

function cratesDraw()
	for _,crate in pairs(crates) do
		love.graphics.draw(CrateImage, GameWidth / 2 - CrateSize / 2 - truck.width / 2 + crate.x, crate.y)
	end
end

function addMessage(text, x, y)
	message.text = text
	message.x = x
	message.y = y
	message.width = Font:getWidth(message.text)
end

function addHeader(text, duration)
	header.text = text
	header.duration = duration
	header.x = 640 - SmallFont:getWidth(header.text) / 2
end

function state.init()
	math.randomseed(os.time())
	resetGame()
	truck.storage = math.random(2, 8)
	updateWeight()
	if not KnowsTutorial then
		addHeader("Use " .. string.upper(KeyForward) .. " and " .. string.upper(KeyBack) .. " to strafe !", 2)
		KnowsTutorial = true
	end
end

function state.update(dt)
	truck.brake = false
	truck.smoke = false

	if love.keyboard.isDown(KeyBack) then
		truck.brake = true
		if truck.x > MinTruckX then
			truck.x = math.floor(truck.x - TruckSpeed * dt + 0.6)
		end
	else
		if truck.x < 0 then
			truck.x = math.floor(truck.x + (TruckSpeed + 20) * dt + 0.6)
		end
	end

	if love.keyboard.isDown(KeyForward) then
		truck.smoke = true
		if truck.x < MaxTruckX then
			truck.x = math.floor(truck.x + (TruckSpeed + 20) * dt + 0.6)
		end
	else
		if truck.x > 0 then
			truck.x = math.floor(truck.x - TruckSpeed * dt + 0.6)
		end
	end

	cratesUpdate(dt)
	cratesTimer = cratesTimer - dt
	if cratesTimer <= 0 then
		spawnCrate(truck.x + math.random(0, 600))
		cratesTimer = math.random(0, 4)
	end

	for k,v in pairs(scrolling) do
		v.x1 = math.floor(v.x1 - v.speed * dt + 0.6)

		if v.x1 <= -1280 then
			v.x1 = 0
			v.x2 = 1280
		end

		v.x2 = v.x1 + 1280
	end

	nextDeliver = math.floor(nextDeliver - scrolling.bridge.speed * dt + 0.6)

	if nextDeliver < 0 and nextDeliver > -10 then
		truck.money = truck.money + 200 * truck.storage
		truck.storage = 0
		resetSpeed()
		truck.immuneToCrates = true
		addHeader(happyHeaders[math.random(1, #happyHeaders)], 2)
		if not MoneySound:isPlaying() then
			MoneySound:play()
		end
	elseif nextDeliver < -1280 then
		nextDeliver = math.random(10, 60) * 400
		truck.storage = math.random(2, 4)
		addMessage("SHIP " .. tostring(truck.storage) .. " CRATES !", 375 + truck.x, 520)
		updateWeight()
		truck.immuneToCrates = false
	end

	if message.text ~= nil then
		message.x = math.floor(message.x - scrolling.bridge.speed * dt + 0.6)
		if message.x < -message.width then
			message.text = nil
		end
	end

	if header.text ~= nil then
		header.duration = header.duration - dt
		if header.duration <= 0 then
			header.text = nil
			header.duration = nil
		end
	end

	if truck.storage > 15 then
		scrolling.bridge.y = math.floor(scrolling.bridge.y + 400 * dt + 0.6)
		addHeader("Goodbye world !", 2)
		if scrolling.bridge.y > 300 then
			setState(WastedState)
		end
	end
end

function state.draw()
	love.graphics.setFont(Font)
	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(BackgroundImages.sky, 0, 0)
	love.graphics.draw(BackgroundImages.mountains, scrolling.mountains.x1, 0)
	love.graphics.draw(BackgroundImages.mountains, scrolling.mountains.x2, 0)
	love.graphics.draw(BackgroundImages.trees, scrolling.trees.x1, 0)
	love.graphics.draw(BackgroundImages.trees, scrolling.trees.x2, 0)

	if nextDeliver < 1280 then
		love.graphics.draw(BackgroundImages.deliver, nextDeliver, scrolling.bridge.y)
	end

	cratesDraw()

	if message.text ~= nil then
		love.graphics.print(message.text, message.x, message.y)
	end

	love.graphics.draw(TruckImages.base, truck.drawX + truck.x, BridgeHeight - truck.height + scrolling.bridge.y)

	if truck.brake then
		love.graphics.draw(TruckImages.brake, truck.drawX + truck.x, BridgeHeight - truck.height + scrolling.bridge.y)
	end

	if truck.smoke then
		love.graphics.draw(TruckImages.smoke, truck.drawX + truck.x, BridgeHeight - 2 * truck.height + scrolling.bridge.y)
	else
		love.graphics.draw(TruckImages.small_smoke, truck.drawX + truck.x, BridgeHeight - 2 * truck.height + scrolling.bridge.y)
	end

	if truck.storage > 0 and truck.storage < 16 then
		love.graphics.draw(TruckImages.storage[truck.storage], truck.drawX + truck.x, BridgeHeight - truck.height + scrolling.bridge.y)
	elseif truck.storage > 15 then
		love.graphics.draw(TruckImages.storage[15], truck.drawX + truck.x, BridgeHeight - truck.height + scrolling.bridge.y)
	end

	love.graphics.draw(BackgroundImages.bridge, scrolling.bridge.x1, scrolling.bridge.y)
	love.graphics.draw(BackgroundImages.bridge, scrolling.bridge.x2, scrolling.bridge.y)

	love.graphics.draw(UIImage, 0, 0)
	if truck.storage ~= 0 then
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", 78, 673, 10 * truck.storage, 28)
		love.graphics.setColor(255, 255, 255)
	end

	love.graphics.setFont(SmallFont)

	if header.text ~= nil then
		love.graphics.print(header.text, header.x + truck.x, 380 + scrolling.bridge.y)
	end

	love.graphics.setColor(0, 0, 0)
	love.graphics.print(truck.money, 353, 682)
	love.graphics.setColor(255, 255, 255)

	if DrawMusicIcon then
		love.graphics.draw(MusicIcon, 0, 0)
	end
end

function state.keyEvent(key)
	if key == "m" then
		if Music:isPlaying() then
			DrawMusicIcon = false
			Music:stop()
		else
			DrawMusicIcon = true
			Music:play()
		end
	end
end

return state
