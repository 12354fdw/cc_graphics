local uis = require("graphics")

local clrs = {
    colors.white,
    colors.orange,
    colors.magenta,
    colors.lightBlue,
    colors.yellow,
    colors.lime,
    colors.pink,
    colors.gray,
    colors.lightGray,
    colors.cyan,
    colors.purple,
    colors.blue,
    colors.brown,
    colors.green,
    colors.red,
    colors.black
}

function main()
    local f = uis.createFrame()
    uis.setProp(f,"parent",term.current())
    uis.setProp(f,"size",{
        scaleX = 0.5,
        scaleY = 0.5,
        offX = 0,
        offY = 0
    })
    uis.setProp(f,"pos",{
        scaleX = 0.25,
        scaleY = 0.25,
        offX = 0,
        offY = 0
    })
    while true do
        uis.setProp(f,"bg",clrs[math.random(1,#clrs)])
        sleep(0.01)
    end
end

parallel.waitForAll(uis.main,main)
