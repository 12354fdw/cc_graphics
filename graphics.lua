local module = {}

module.NATIVE = term.native()

--[[
	Instance format:
	{
		parent = "",
		id = "asfgdfh"
		type = "Frame",
		pos = {
			scaleX,
			scaleY,
			offX,
			offY,
		},
		size = {
			scaleX,
			scaleY,
			offX,
			offY,
		},
		bg = colors.black
	}
]]

local instances = {Low={},High={}}
local drawed = {}

function module.createFrame()
	local id = generateId()
	instances.High[id] = {
		parent = "",
		type = "Frame",
		id = id,
		pos = {
			scaleX = 0,
			scaleY = 0,
			offX = 0,
			offY = 0,
		},
		size = {
			scaleX = 0,
			scaleY = 0,
			offX = 0,
			offY = 0,
		},
		bg = colors.black,
	}
	return {mode="High",id=id}
end

function module.createText()
	local id = generateId()
	instances.Low[id] = {
		parent = "",
		type = "Text",
		id = id,
		pos = {
			scaleX = 0,
			scaleY = 0,
			offX = 0,
			offY = 0,
		},
		size = {
			scaleX = 0,
			scaleY = 0,
			offX = 0,
			offY = 0,
		},
		bg = colors.black,
		tc = colors.white,
		text = "text"
	}
	return {mode="Low",id=id}
end

function module.createButton()
	local id = generateId()
	instances.Low[id] = {
		parent = "",
		type = "Button",
		id = id,
		pos = {
			scaleX = 0,
			scaleY = 0,
			offX = 0,
			offY = 0,
		},
		size = {
			scaleX = 0,
			scaleY = 0,
			offX = 0,
			offY = 0,
		},
		bg = colors.black,
		tc = colors.white,
		text = "text",
		clickable = true,
		activation = function() end
	}
	return {mode="Low",id=id}
end

function generateId()
	local r = ""
	for i = 1, 20 do
		r = r .. utf8.char(math.random(32, 255))
	end
	return r
end

function module.setProp(id, path, value)
    local data = instances[id.mode][id.id]
	if not data then
		error("Attempt to set property of " .. id .. " but it does not exist")
        return
	end

    local tokens = {}
    for token in path:gmatch("[%w_]+") do
        table.insert(tokens, token)
    end

    local current = data
    for i, token in ipairs(tokens) do
        if current[token] == nil then
            error("Failed to find '" .. token .. "' in '" .. path .. "' for '" .. id .. "'")
            return
        end

        if i == #tokens then
            current[token] = value
        else
            current = current[token]
        end
    end
end

function convertToAbs(instance)
	local data = findData(instance)
	if not data then
		error("Instance not found: " .. instance)
		return
	end


	local function gatherParentData(currentData, parentData)
		if currentData.parent == term.native() then

			table.insert(parentData, term.native())
			return parentData
		else

			local parent = findData(currentData.parent)
			if not parent then
				return parentData
			end
			table.insert(parentData, currentData)
			return gatherParentData(parent, parentData)
		end
	end

	local allParentData = gatherParentData(data, {})

	local absPos, absSize = {offX = 0, offY = 0, scaleX = 0, scaleY = 0}, {offX = 0, offY = 0, scaleX = 0, scaleY = 0}
	for i = #allParentData, 1, -1 do
		local parentData = allParentData[i]

		absPos.offX = absPos.offX + parentData.pos.offX + parentData.pos.scaleX * absSize.offX
		absPos.offY = absPos.offY + parentData.pos.offY + parentData.pos.scaleY * absSize.offY
		absSize.offX = absSize.offX + parentData.size.offX + parentData.size.scaleX * absSize.offX
		absSize.offY = absSize.offY + parentData.size.offY + parentData.size.scaleY * absSize.offY
	end

	return absPos, absSize
end


function udimConvert(t,p)
	local sx, sy = p.getSize()
	return t.scaleX * sx + (t.offX+1), t.scaleY * sy + (t.offY+1)
end

function findData(id)
	for i, buffer in pairs(instances) do
		for i,v in pairs(buffer) do
			if v.id == id then
				return v
			end
		end
	end
	return nil
end

function findInstance(id)
	for i,v in pairs(drawed) do
		if i == id then
			return v
		end
	end
	return nil
end

local i = 1
function render()
    while true do
        term.clear()
		drawed = {}
		
		local bufferOrder = {"High","Low"}
        for _, buffer in pairs(bufferOrder) do
			term.setCursorPos(1, 1)
			term.clearLine()
			term.write("drawing frame " .. i..", "..buffer.." buffer")
			term.setCursorPos(1, 2)
			for i,v in pairs(instances[buffer]) do
				if not v.parent then
					break
				end

				if v.type == "Frame" then
					local parent = v.parent
					if type(v.parent.id) == "string" then
						parent = findInstance(v.parent.id)
						if not parent then
							break
						end
					end
					local sx, sy = udimConvert(v.size,parent)
					local px, py = udimConvert(v.pos,parent)
					local win = window.create(parent, px, py, sx, sy)
					drawed[v.id] = win
					win.setBackgroundColor(v.bg)
					win.clear()
				end

				if v.type == "Text" then
					local parent = v.parent
					if type(v.parent.id) == "string" then
						parent = findInstance(v.parent.id)
						if not parent then
							break
						end
					end
					local sx, sy = udimConvert(v.size,parent)
					local px, py = udimConvert(v.pos,parent)
					local win = window.create(parent, px, py, sx, sy)
					drawed[v.id] = win
					win.setBackgroundColor(v.bg)
					win.setTextColor(v.tc)
					win.clear()
					term.redirect(win)
					print(v.text)
					term.redirect(module.NATIVE)
					win.setTextColor(colors.white)
				end


				if v.type == "Button" then
					local parent = v.parent
					if type(v.parent.id) == "string" then
						parent = findInstance(v.parent.id)
						if not parent then
							break
						end
					end
					local sx, sy = udimConvert(v.size,parent)
					local px, py = udimConvert(v.pos,parent)
					local win = window.create(parent, px, py, sx, sy)
					drawed[v.id] = win
					win.setBackgroundColor(v.bg)
					win.setTextColor(v.tc)
					win.clear()
					term.redirect(win)
					print(v.text)
					term.redirect(module.NATIVE)
					win.setTextColor(colors.white)
				end
			end
        end
		i = i + 1
		sleep(0.1)
    end
end

function module.clearAll()
	instances = {}
end

function module.main()
	term.clear()
	term.setCursorPos(1,1)
	print("graphic init.")
	render()
end

function isInBounds(x, y, boxX, boxY, width, height)
    return x >= boxX and x <= boxX + width - 1 and y >= boxY and y <= boxY + height - 1
end

function module.buttonHandler()
	print("buttonHandler ACTIVE")
	while true do 
		local event, button, x, y = os.pullEvent("mouse_click")
		for i,buffer in pairs(instances) do

			for i,v in pairs(buffer) do
				if not v.clickable then
					break
				end
				--local pos,size = convertToAbs(v.id)
				local px, py = udimConvert(v.pos,module.NATIVE)
				local sx, sy = udimConvert(v.size,module.NATIVE)
				if isInBounds(x,y,px,py,sx,sy) then
					v.activation()
				end

			end

		end
	end
end

-- to use this DO
--[[ 
parallel.waitForAny(
	[MODULE_NAME].main,
	[MODULE_NAME].buttonHandler, - IF YOU ARE USING BUTTONS
	[MAIN_TASK])

]]
return module
