eq = {clock = 0}


function eq:loadTransforms()
	local configanimation = config.getParameter("animation") -- copy paste wtf
	local animations = {}
	
	if configanimation then
		animations = root.assetJson(itemDir(configanimation), {})
	end
	local animationCustom = config.getParameter("animationCustom", {})
	local animationTranformationGroup = sb.jsonMerge(animationCustom, animations).transformationGroups or {} 
	
	for i,v in pairs({"eq1","eq2","eq3"}) do
		local newtrans = {position = {0,0}, scale = {1,1}, scalePoint = {0,0}, rotation = 0, rotationPoint = {0,0}}

		if animationTranformationGroup[v].transform then
			newtrans = sb.jsonMerge(newtrans, animationTranformationGroup[v].transform)
		end

		transforms:add(v, newtrans,
			function(name,thisTransform, dt) 
				if animator.hasTransformationGroup(name) then --Check to prevent crashing
					local setting  = transforms.calculateTransform({
						position = thisTransform.position or {0,0},
						scale = vec2.mul(thisTransform.scale, {1, (math.sin(self.clock + i * math.pi) + 1) / 2}) or {1,1},
						scalePoint = thisTransform.scalePoint or {0,0},
						rotation = thisTransform.rotation or 0,
						rotationPoint = thisTransform.rotationPoint or {0,0}
					})
					
					animator.resetTransformationGroup(name) 
					animator.scaleTransformationGroup(name, setting.scale, setting.scalePoint)
					animator.rotateTransformationGroup(name, util.toRadians(setting.rotation), setting.rotationPoint)
					animator.translateTransformationGroup(name, setting.position)
				end
			end
		)
	end

	for i,v in pairs({"eq4","eq5","eq6", "eq7"}) do
		local newtrans = {position = {0,0}, scale = {1,1}, scalePoint = {0,0}, rotation = 0, rotationPoint = {0,0}}

		if animationTranformationGroup[v].transform then
			newtrans = sb.jsonMerge(newtrans, animationTranformationGroup[v].transform)
		end

		transforms:add(v, newtrans,
			function(name,thisTransform, dt) 
				if animator.hasTransformationGroup(name) then --Check to prevent crashing
					local setting  = transforms.calculateTransform({
						position = vec2.add(thisTransform.position, {0, ((math.sin(self.clock + (i / 4) * math.pi) + 1) / 2) * 1}) or {0,0},
						scale = thisTransform.scale or {1,1},
						scalePoint = thisTransform.scalePoint or {0,0},
						rotation = thisTransform.rotation or 0,
						rotationPoint = thisTransform.rotationPoint or {0,0}
					})
					
					animator.resetTransformationGroup(name) 
					animator.scaleTransformationGroup(name, setting.scale, setting.scalePoint)
					animator.rotateTransformationGroup(name, util.toRadians(setting.rotation), setting.rotationPoint)
					animator.translateTransformationGroup(name, setting.position)
				end
			end
		)
	end

	for i,v in pairs({"vu"}) do
		local newtrans = {position = {0,0}, scale = {1,1}, scalePoint = {0,0}, rotation = 0, rotationPoint = {0,0}}

		if animationTranformationGroup[v].transform then
			newtrans = sb.jsonMerge(newtrans, animationTranformationGroup[v].transform)
		end

		transforms:add(v, newtrans,
			function(name,thisTransform, dt) 
				if animator.hasTransformationGroup(name) then --Check to prevent crashing
					local setting  = transforms.calculateTransform({
						position = thisTransform.position or {0,0},
						scale = thisTransform.scale or {1,1},
						scalePoint = thisTransform.scalePoint or {0,0},
						rotation = thisTransform.rotation - 45 + ((math.sin(self.clock * 4 + i * math.pi) + 1) / 2) * -90 or 0,
						rotationPoint = thisTransform.rotationPoint or {0,0}
					})
					
					animator.resetTransformationGroup(name) 
					animator.scaleTransformationGroup(name, setting.scale, setting.scalePoint)
					animator.rotateTransformationGroup(name, util.toRadians(setting.rotation), setting.rotationPoint)
					animator.translateTransformationGroup(name, setting.position)
				end
			end
		)
	end

	for i,v in pairs({"knob1","knob2","knob3"}) do
		local newtrans = {position = {0,0}, scale = {1,1}, scalePoint = {0,0}, rotation = 0, rotationPoint = {0,0}}

		if animationTranformationGroup[v].transform then
			newtrans = sb.jsonMerge(newtrans, animationTranformationGroup[v].transform)
		end

		transforms:add(v, newtrans,
			function(name,thisTransform, dt) 
				if animator.hasTransformationGroup(name) then --Check to prevent crashing
					local setting  = transforms.calculateTransform({
						position = thisTransform.position or {0,0},
						scale = thisTransform.scale or {1,1},
						scalePoint = thisTransform.scalePoint or {0,0},
						rotation = thisTransform.rotation + ((math.sin(self.clock + i * math.pi) + 1) / 2) * -90 or 0,
						rotationPoint = thisTransform.rotationPoint or {0,0}
					})
					
					animator.resetTransformationGroup(name) 
					animator.scaleTransformationGroup(name, setting.scale, setting.scalePoint)
					animator.rotateTransformationGroup(name, util.toRadians(setting.rotation), setting.rotationPoint)
					animator.translateTransformationGroup(name, setting.position)
				end
			end
		)
	end
end

function eq:init()
	self.clock = os.clock()
	self:loadTransforms()
end

function eq:update()
	self.clock = os.clock() * 4
end

addClass("eq")