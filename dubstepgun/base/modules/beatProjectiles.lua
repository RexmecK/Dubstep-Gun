beatProjectiles = {
    trails = {},
    projectiles = {}
}

function direction(dir)
    if dir < 0 then return -1 else return 1 end
end

function beatProjectiles:update(dt)
    local todraw = {}
    for i,v in pairs(self.trails) do
        if v.timeToLive == 0 then
            self.trails[i] = nil
        else
            table.insert(todraw, 
                {
                    position = v.line[1],
                    line = {{0,0}, vec2.sub(v.line[2], v.line[1])},
                    width = 2,
                    color = {
                        v.color[1],
                        v.color[2],
                        v.color[3],
                        math.floor((v.color[4] or 255) * (v.timeToLive / v.timeToLiveOriginal))
                    } 
                }
            )
            self.trails[i].timeToLive = math.max(v.timeToLive - dt,0)
        end
    end
    for i,v in pairs(self.projectiles) do
        if not world.entityExists(i) then 
            self.projectiles[i] = nil
        else
            local entpos = world.entityPosition(i)
            local dist = world.distance(entpos, v.lastpos)
            local dir = direction(dist[1])
            local projectileAngle = vec2.angle(dist)
            local entpos2 = vec2.add(entpos, vec2.rotate( {0,( math.max(math.sin(v.time * math.pi * 3)^10, 0) * 4 + 0.25) * dir}, projectileAngle) )
            table.insert(todraw, {position = v.lastline[1], line = {{0,0}, vec2.sub(v.lastline[2], v.lastline[1])}, width = 2, color = {0,128,255,255}, fullbright = true})
            table.insert(todraw, {position = v.lastline[2], line = {{0,0}, vec2.sub(entpos2, v.lastline[2])}, width = 3, color = {255,255,255,255}, fullbright = true})

            local entpos2b = vec2.add(entpos, vec2.rotate( {0,( -math.max(math.sin(v.time * math.pi * 3)^10, 0) * 4 - 0.25 ) * dir}, projectileAngle) )
            
            table.insert(todraw, {position = v.lastlineb[1], line = {{0,0}, vec2.sub(v.lastlineb[2], v.lastlineb[1])}, width = 2, color = {0,128,255,255}, fullbright = true})
            table.insert(todraw, {position = v.lastlineb[2], line = {{0,0}, vec2.sub(entpos2b, v.lastlineb[2])}, width = 3, color = {255,255,255,255}, fullbright = true})

            self:linetrail(v.lastlineb, 1, {160,126,255,255})
            self:linetrail(v.lastline, 1, {160,126,255,255})
            self:linetrail({v.lastpos, entpos}, 1, {160,126,255,255})
            self.projectiles[i] = {time = v.time + dt, lastline = {v.lastline[2], entpos2},lastlineb = {v.lastlineb[2], entpos2b}, lastpos = entpos}
        end
    end
    activeItem.setScriptedAnimationParameter("globalDrawables", todraw)
end

function beatProjectiles:linetrail(line, timetolive, color)
    self.trails[sb.makeUuid()] = {line = line, timeToLive = timetolive, timeToLiveOriginal = timetolive, color = color}
end

function beatProjectiles:add(id)  
    if not world.entityExists(id) then return end
    local entpos = world.entityPosition(id)
    self.projectiles[id] = {time = 0, lastline = {entpos, entpos},lastlineb = {entpos, entpos}, lastpos = entpos}
end

addClass("beatProjectiles")