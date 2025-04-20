local function wire(source,target)
	local wire = Instance.new("Wire")
	wire.Name = `{source.ClassName} -> {target.ClassName}`
	wire.SourceInstance = source
	wire.TargetInstance = target
	wire.Parent = source
	return wire
end

local function getEffectsOutput(audioPlayer:AudioPlayer)
	local effects = audioPlayer:GetChildren()

	if #effects > 0 then
		wire(audioPlayer,effects[1])

		for i=2,#effects do
			wire(effects[i-1],effects[i])
		end

		return effects[#effects]
	end

	return audioPlayer
end

local function playSoundFromSource(playerTemplate: AudioPlayer, target: Instance, pitchAdjustment: number?)
	local audioPlayer = playerTemplate:Clone()
	if pitchAdjustment then
		audioPlayer.PlaybackSpeed *= pitchAdjustment
	end
	
	wire(getEffectsOutput(audioPlayer),target)

	audioPlayer.Parent = target

	audioPlayer:Play()
	audioPlayer.Ended:Once(function()
		audioPlayer:Destroy()
	end)
	return audioPlayer
end

return playSoundFromSource
