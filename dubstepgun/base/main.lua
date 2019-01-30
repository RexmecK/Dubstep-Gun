main = {
    projectiles = {}
}

function beatsec(bpm)
    return 12/bpm
end

function main:init()
    self.config = config.getParameter("musicGun")
end

function main:update()
    self:updateAim()
end

function main:fire()
    animation:play("shoot")
    local pos = vec2.add(mcontroller.position(), activeItem.handPosition(animator.partPoint(self.config.muzzle.part, self.config.muzzle.s)))
    local pos2 = vec2.add(mcontroller.position(), activeItem.handPosition(animator.partPoint(self.config.muzzle.part, self.config.muzzle.e)))

    local projectileid = world.spawnProjectile("bullet-4", pos, activeItem.ownerEntityId(), vec2.sub(pos2, pos), false, {speed = 250})
    self.projectiles[projectileid] = true

end

function main:updateProjectileTracker()
    for i,v in pairs(self.projectiles) do
        if world.entityExists(v) then

        else
            self.projectiles[i] = nil
        end
    end
end

function main:activate(firemode, shift)
    if firemode == "primary" then
        self:fire()
    end
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