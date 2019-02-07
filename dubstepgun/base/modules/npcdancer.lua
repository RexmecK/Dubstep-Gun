npcDancer = {
	dancePools = {"armswingdance"},
	_enabled = false,
	stageHandDieFlag = false
}

function npcDancer:killStageHand()
	if self.stageHandDieFlag then
		world.setProperty(self.stageHandDieFlag, true)
		self.stageHandDieFlag = false
	end
end

function npcDancer:start() 
	self:killStageHand()
	self.stageHandDieFlag = sb.makeUuid()
	world.spawnStagehand(mcontroller.position(), "dubstepgunnpcdancer", {config = {dieFlag = self.stageHandDieFlag, ownerId = activeItem.ownerEntityId(), query = 100, dancePools = self.dancePools}})
end

function npcDancer:stop() 
	self:killStageHand()
end

function npcDancer:uninit()
	self:stop()
end


addClass("npcdancer")