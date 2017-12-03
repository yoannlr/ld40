state = {}

keyboardMode = 1

function state.init()
end

function state.update(dt)
end

function state.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(BackgroundImages.sky, 0, 0)
	love.graphics.draw(BackgroundImages.mountains, 0, 0)
	love.graphics.draw(BackgroundImages.trees, 0, 0)
	love.graphics.draw(BackgroundImages.bridge, 0, 0)
	love.graphics.draw(GameLogo, 340, 375)

	love.graphics.setFont(Font)
	love.graphics.printf("Press ENTER to start !", 0, 300, 1280, "center")

	love.graphics.setFont(SmallFont)
	if keyboardMode == 1 then
		love.graphics.printf("Use QWERTY - Change with arrows", 0, 680, 1280, "center")
	elseif keyboardMode == 2 then
		love.graphics.printf("Use AZERTY - Change with arrows", 0, 680, 1280, "center")
	else
		love.graphics.printf("Use QWERTZ - Change with arrows", 0, 680, 1280, "center")
	end
end

function state.keyEvent(key)
	if key == "up" or key == "left" then
		if keyboardMode - 1 > 0 then
			keyboardMode = keyboardMode - 1
		end
	elseif key == "down" or key == "right" then
		if keyboardMode + 1 < 4 then
			keyboardMode = keyboardMode + 1
		end
	elseif key == "return" then
		if keyboardMode == 2 then
			KeyForward = "z"
		end
		CurrentState.initialized = false
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
