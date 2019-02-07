function init()
	config = config.getParameter("config")
end
  
function uninit()
	
end
  
function update()
	if config.dieFlag and world.getProperty(config.dieFlag) then
		world.setProperty(config.dieFlag, nil)
		stagehand.die()
	end

	if config.ownerId then
		if world.entityExists(config.ownerId) then
			stagehand.setPosition(world.entityPosition(config.ownerId))
		end
	end

	local query = world.npcQuery(stagehand.position(), config.query or 50)

	if not config.dancePools or #config.dancePools == 0 then return end

	for i,v in pairs(query) do
		world.callScriptedEntity(v, "npc.dance", config.dancePools[math.random(1, #config.dancePools)])
	end
end