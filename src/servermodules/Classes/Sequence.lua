local RunService = game:GetService("RunService")
local Trove = require(game:GetService("ReplicatedStorage").Modules.Packages.Trove) -- replace with direct path to your Trove module
local START_FRAME = 0
local WARN_NEGATIVE_SPEED = "Attempt to set sequence speed below 0, defaulting to 0 speed instead"
local Sequence = {}
Sequence.__index = Sequence

function Sequence.new(Data)
	local self = setmetatable({}, Sequence)

	self.Name = Data.Name or "Sequence"
	self._Frames = {}
	self._Speed = Data.Speed or 1
	self._CurrentFrame = Data.StartFrame or START_FRAME
	self._Trove = Trove.new()
	self._Running = true

	self:AddFrames(Data.Frames)
	self._Trove:Add(function()
		self._Running = false
	end)

	self._MaxFrame = self:GetMaxFrame()
	self._RanFrames = {}
	self._Event = self._Trove:Add(Instance.new("BindableEvent", script))

	return self
end

function Sequence:Play(...)
	local Arguments = ...
	task.spawn(function()
		while self._CurrentFrame <= self._MaxFrame do
			if not self._Running then
				--task.wait()
				return
			end

			self:UpdateCurrentFrame()

			local Frame = self:GetFrame()
			local Callbacks = self:GetCallbacksAtFrame(Frame)

			self:RunCallbacks(Callbacks, Frame, Arguments)

			for PotentiallySkippedFrame, Callbacks in self._Frames do
				if PotentiallySkippedFrame > Frame then
					continue
				end
				if Callbacks.SkipTested then
					continue
				end
				Callbacks.SkipTested = true
				self:RunCallbacks(Callbacks, Frame, Arguments)
			end
		end

		self:Destroy()
	end)
end

function Sequence:RunCallbacks(Callbacks, Frame, Arguments)
	for _, Callback in Callbacks do
		if typeof(Callback) ~= "table" then
			continue
		end
		self:Call(Callback, Frame, Arguments)
	end
end

function Sequence:Call(Callback, CurrentFrame, ...)
	local CallbackFunction = Callback.Callback
	local CallbackFrequency = Callback.CallbackFrequency
	local Ran = Callback.Ran

	if CurrentFrame % CallbackFrequency ~= 0 then
		return
	end
	if Ran then
		return
	end
	Callback.Ran = true

	CallbackFunction(self, ...)
end

function Sequence:GetEvent()
	return self._Event
end

function Sequence:GetMaxFrame()
	local Frames = self._Frames
	local LowestFrame = 0

	for Frame in pairs(Frames) do
		if Frame > LowestFrame then
			LowestFrame = Frame
		end
	end

	return LowestFrame
end

function Sequence:UpdateCurrentFrame()
	local Incrementation = task.wait() * 60 * self:GetSpeed()
	local CurrFrame = self._CurrentFrame

	self._CurrentFrame = CurrFrame + Incrementation
end

function Sequence:GetFrames()
	return self._Frames
end

function Sequence:GetUnfloorFrame()
	return self._CurrentFrame
end

function Sequence:GetFrame()
	return math.floor(self._CurrentFrame)
end

function Sequence:GetSpeed()
	return self._Speed
end

function Sequence:SetSpeed(Speed)
	if Speed < 0 then
		Speed = 0
		warn(WARN_NEGATIVE_SPEED)
	end
	self._Speed = Speed
end

function Sequence:AddFrames(Frames)
	for _, FrameData in Frames do
		local FrameParameters = self:GetFrameParameters(FrameData)

		self:ProcessAndAddFrame(FrameParameters)
	end
end

function Sequence:GetFrameParameters(FrameData)
	local FrameRangeLowerBound, FrameRangeUpperBound, CallbackFrequency, Callback = unpack(FrameData)

	if typeof(FrameRangeUpperBound) == "function" then
		Callback = FrameRangeUpperBound
		FrameRangeUpperBound = FrameRangeLowerBound
		CallbackFrequency = 1
	end

	if typeof(CallbackFrequency) == "function" then
		Callback = CallbackFrequency
		CallbackFrequency = 1
	end

	return {
		FrameRangeLowerBound = FrameRangeLowerBound,
		FrameRangeUpperBound = FrameRangeUpperBound,
		CallbackFrequency = CallbackFrequency,
		Callback = Callback
	}
end

function Sequence:ProcessAndAddFrame(FrameParameters)
	local FrameRangeLowerBound, FrameRangeUpperBound = FrameParameters.FrameRangeLowerBound, FrameParameters.FrameRangeUpperBound

	if FrameRangeUpperBound ~= FrameRangeLowerBound then
		for RangedFrame = FrameRangeLowerBound, FrameRangeUpperBound do
			self:AddCallbackToFrame(FrameParameters.Callback, RangedFrame, FrameParameters.CallbackFrequency)
		end
	else
		self:AddCallbackToFrame(FrameParameters.Callback, FrameRangeLowerBound, FrameParameters.CallbackFrequency)
	end
end

function Sequence:AddCallbackToFrame(Callback, Frame, CallbackFrequency)
	local CallbackTable = self:GetCallbacksAtFrame(Frame)

	table.insert(self._Frames[Frame], {
		Callback = Callback,
		CallbackFrequency = CallbackFrequency
	})
end

function Sequence:GetCallbacksAtFrame(Frame)
	if not self._Frames[Frame] then
		return self:AddCallbackTable(Frame)
	end

	return self._Frames[Frame]
end

function Sequence:AddCallbackTable(Frame)
	self._Frames[Frame] = {}

	return self._Frames[Frame]
end

function Sequence:Pause()
	if self._Paused then
		return
	end

	self._Paused = self:GetSpeed()

	self:SetSpeed(0)
end

function Sequence:Unpause()
	if self._Paused then
		self:SetSpeed(self._Paused)
		self._Paused = nil
	end
end

function Sequence:SkipTo(Frame)
	self:AddRanFlagAtPriorFrames(Frame)
	self._CurrentFrame = Frame
end

function Sequence:AddRanFlagAtPriorFrames(NewFrame)
	for Frame, FrameCallbacks in pairs(self._Frames) do
		if Frame > NewFrame then
			continue
		end
		FrameCallbacks.Ran = true
		for _, Callback in FrameCallbacks do
			Callback.Ran = true
		end
	end
end

function Sequence:ClearRanCache(StartFrame)
	for Frame, FrameCallbacks in pairs(self._Frames) do
		if Frame < StartFrame then
			continue
		end
		FrameCallbacks.Ran = nil
	end
end

function Sequence:Restart(StartFrame, ...)
	local StartFrame = StartFrame or START_FRAME
	self:ClearRanCache(StartFrame)
	self._CurrentFrame = StartFrame
	if not self._Running then
		self._Running = true
		self:Play(...)
	end
end

function Sequence:Stop()
	self._Running = false
end

function Sequence:IsPlaying()
	return self._Running
end

function Sequence:Destroy()
	self._Running = false
	self._Trove:Destroy()
end

return Sequence