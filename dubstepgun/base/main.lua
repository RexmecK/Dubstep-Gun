main = {
    state = "idle",
    timer1 = 0,
    beattimer1 = 0,
    cameracooldown = 0,
}

function beatsec(bpm)
    return 120/bpm
end

function main:init()
    self.config = config.getParameter("musicGun")
    self.beattimer = os.clock()
    camera.smooth = 16
end

function main:update(dt, firemode, shift)
    local osclocked = os.clock() 
    if firemode == "primary" then
        if self.state == "idle" then
            animator.playSound("prefire")
            self.state = "prefire"
            self.timer1 = osclocked + self.config.preFireTime
        elseif self.state == "prefire" then
            if self.timer1 <= osclocked then
                animator.playSound("loopfire", -1)
                self.state = "loopfire"
                self.beattimer1 = osclocked
            end
        elseif self.state == "loopfire" then
            if self.beattimer1 <= osclocked then
                local offset = self.beattimer1 - osclocked -- this is to let us to we are a little late
                self.beattimer1 = (osclocked + beatsec(self.config.bpm)) + offset
                self.cameracooldown = beatsec(self.config.bpm * 2)
                self:fire()
            end
        end
        if self.cameracooldown == 0 then
            camera.target = vec2.mul(vec2.sub(activeItem.ownerAimPosition(), mcontroller.position()), 0.5)
        else
            self.cameracooldown = math.max(self.cameracooldown - dt, 0)
            camera.target = vec2.add(vec2.mul(vec2.sub(activeItem.ownerAimPosition(), mcontroller.position()), 0.5), {((math.random(0,100) / 100) * 10) - 5,((math.random(0,100) / 100) * 10) - 5})
        end
    elseif firemode ~= "primary" and self.state ~= "idle" then
        if self.state ~= "prefire" then
            animator.stopAllSounds("loopfire")
            animator.playSound("endfire")
        else
            animator.stopAllSounds("prefire")
        end

        self.state = "idle"
        self.beattimer1 = 0
        self.timer1 = 0
        camera.target = {0,0}
    end
    world.debugText("beattimer = %s", (self.beattimer1) - osclocked, vec2.add(mcontroller.position(), {0,1}), "#ff0")
    world.debugText("timer1 = %s", self.timer1, vec2.add(mcontroller.position(), {0,2}), "#ff0")
    self:updateAim()
end

function main:fire()
    animation:play("shoot")
    local pos = vec2.add(mcontroller.position(), activeItem.handPosition(animator.partPoint(self.config.muzzle.part, self.config.muzzle.s)))
    local pos2 = vec2.add(mcontroller.position(), activeItem.handPosition(animator.partPoint(self.config.muzzle.part, self.config.muzzle.e)))

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

end

addClass("main")