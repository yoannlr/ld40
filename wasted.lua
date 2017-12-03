state = {}

function state.init()
end

function state.update(dt)
end

function state.draw()
	love.graphics.draw(BackgroundImages.sky, 0, 0)
	love.graphics.draw(BackgroundImages.mountains, scrolling.mountains.x1, 0)
	love.graphics.draw(BackgroundImages.mountains, scrolling.mountains.x2, 0)
	love.graphics.draw(BackgroundImages.trees, scrolling.trees.x1, 0)
	love.graphics.draw(BackgroundImages.trees, scrolling.trees.x2, 0)

	love.graphics.setFont(Font)
	love.graphics.printf("WASTED !", 0, 400, 1280, "center")
	love.graphics.setFont(SmallFont)
	love.graphics.printf("Your truck was to heavy !", 0, 440, 1280, "center")
	love.graphics.printf("You earned " .. truck.money .. " coins", 0, 480, 1280, "center")
	love.graphics.printf("Press ENTER to restart", 0, 680, 1280, "center")
end

function state.keyEvent(key)
	if key == "return" then
		setState(GameState)
	elseif key == "m" then
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