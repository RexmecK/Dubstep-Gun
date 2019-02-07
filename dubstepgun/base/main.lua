main = {
    state = "idle",
    timer1 = 0,
    beattimer1 = 0,
    beatSync = true,

    cameracooldown = 0,
}

function beatsec(bpm)
    return 120/bpm
end

function main:init()
    activeItem.setCursor("/cursors/reticle0.cursor")
    self.config = config.getParameter("musicGun")
    npcDancer.dancePools = self.config.dancePools or {}
    self.beattimer = os.clock()
    camera.smooth = 8
    timeline:add("beatEvents", root.assetJson(pD("beatEvents.timeline")))
    timeline:setEvent("beatSync_on", function() self.beatSync = true end)
    timeline:setEvent("beatSync_off", function() self.beatSync = false end)
    timeline:setEvent("beatFire", function() self:fire() end)
    animator.stopAllSounds("idle")
    animator.playSound("idle", -1)
end

function main:lateInit()
    animation:play("draw")
end

function main:update(dt, firemode, shift)
    local osclocked = os.clock() 
    if firemode == "primary" and not animation:isPlaying("draw") then

        if self.state == "idle" then
            animator.stopAllSounds("idle")
            animator.playSound("prefire")
            self.state = "prefire"
            self.timer1 = osclocked + self.config.preFireTime
        elseif self.state == "prefire" then
            if self.timer1 <= osclocked then
                animator.stopAllSounds("loopfire")
                animator.playSound("loopfire", -1)
                timeline:play("beatEvents")
                self.state = "loopfire"
                self.beattimer1 = osclocked
                self.timer1 = osclocked + self.config.loopTime
                npcDancer:start() 
            end
        elseif self.state == "loopfire" then

            if self.timer1 <= osclocked then
                animator.stopAllSounds("loopfire")
                animator.playSound("loopfire", -1) --copied code wtf
                timeline:play("beatEvents")
                self.beattimer1 = osclocked
                self.timer1 = osclocked + self.config.loopTime
            end

            if self.beattimer1 <= osclocked then
                local offset = self.beattimer1 - osclocked -- this is to let us to we are a little late
                self.beattimer1 = (osclocked + beatsec(self.config.bpm)) + offset
                if self.beatSync then
                    self:fire()
                end
            end

        end

    elseif firemode ~= "primary" and self.state ~= "idle" then
        if self.state ~= "prefire" then
            animator.stopAllSounds("loopfire")
            animator.playSound("endfire")
        else
            animator.stopAllSounds("prefire")
        end
        timeline:stop("beatEvents")
        npcDancer:stop() 
        animator.playSound("idle", -1)

        self.state = "idle"
        self.beattimer1 = 0
        self.timer1 = 0
        camera.target = {0,0}
    end
    
    if self.state ~= "idle" and self.cameracooldown == 0 then
        camera.target = vec2.mul(vec2.sub(activeItem.ownerAimPosition(), mcontroller.position()), 0.125)
    elseif self.cameracooldown > 0 then
        self.cameracooldown = math.max(self.cameracooldown - dt, 0)
        camera.target = vec2.add(vec2.mul(vec2.sub(activeItem.ownerAimPosition(), mcontroller.position()), 0.125), {0,math.sin(os.clock() * 100   )*self.cameracooldown * 10})
    else
        camera.target = {0,0}
    end
    
    self:updateAim()
end

function main:fire()
    animation:play("shoot")
    local pos = vec2.add(mcontroller.position(), activeItem.handPosition(animator.partPoint(self.config.muzzle.part, self.config.muzzle.s)))
    local pos2 = vec2.add(mcontroller.position(), activeItem.handPosition(animator.partPoint(self.config.muzzle.part, self.config.muzzle.e)))

    self.cameracooldown = 0.3

    local projectileid = world.spawnProjectile("bullet-4", pos, activeItem.ownerEntityId(), vec2.sub(pos2, pos), false, root.assetJson(pD("projectileParam1.json")))
    beatProjectiles:add(projectileid)
end

function main:activate(firemode, shift)
    
end

function main:updateAim()
    local aimAngle,dir = activeItem.aimAngleAndDirection(0, activeItem.ownerAimPosition())

    aim.target = math.deg(aimAngle)
    aim.direction = dir
    arms.direction = dir
end


function main:uninit()
    animator.stopAllSounds("loopfire")
    animator.stopAllSounds("loopfire")
    animator.stopAllSounds("loopfire")
    animator.stopAllSounds("loopfire")
    npcDancer:stop() 

end

addClass("main")