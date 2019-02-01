timeline = {
	_tracks = {},
	_functions = {}
}

function timeline:update()
	for i,v in pairs(self._tracks) do
		if v.playing then
			local currentTime = os.clock() - v.playedTime
			local keycount = 0
			for i2,v2 in pairs(v.track) do
				if v2.time > currentTime then
					for i3, v3 in pairs(v2.events) do
						self:fireEvent(v3)
					end
					self._tracks[i].playedkeys[i2] = v2
					self._tracks[i].keys[i2] = nil
				end
				keycount = keycount + 1
			end
			if keycount == 0 then 
				self._tracks[i].playing = false
			end
		end
	end
end

function timeline:play(name)
	self._tracks[name].playing = true
	self._tracks[name].playedTime = os.clock
end

-- [{"events" : ["func1"], "time" : 2.0}]
function timeline:add(name, a)
	self._tracks[name] = {playing = false, playedTime = 0, keys = a, playedkeys = {}}
end

function timeline:addEvent(name, func)

end

function timeline:fireEvent(name)

end

addClass("timeline")