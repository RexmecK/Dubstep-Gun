require "/scripts/util.lua"
require "/scripts/vec2.lua"

enabled = false
localmessage = nil
messaged = false
ownerid = 0

function update(dt)
	if animationConfig.animationParameter("entityID") and not localmessage and not messaged then
		localmessage = world.sendEntityMessage(animationConfig.animationParameter("entityID"), "isLocal")
		ownerid = animationConfig.animationParameter("entityID")
	end
	
	if enabled then
		localAnimator.clearDrawables()
		updateDrawables(dt)
	elseif localmessage and localmessage:finished() then	
		enabled = localmessage:result()
		messaged = true
	end
end


function updateDrawables(dt)
	--your localAnimator functions here
end