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
    local t = uis.createText()
    uis.setProp(t,"parent",f)
    uis.setProp(t,"size",{
        scaleX = 0.5,
        scaleY = 0.5,
        offX = 0,
        offY = 0
    })
    uis.setProp(t,"pos",{
        scaleX = 0.25,
        scaleY = 0.25,
        offX = 0,
        offY = 0
    })
    uis.setProp(t,"text","The quick brown fox jumped over the lazy dog.")
    while true do
        uis.setProp(t,"bg",clrs[math.random(1,#clrs)])
        uis.setProp(f,"bg",clrs[math.random(1,#clrs)])
        uis.setProp(t,"tc",clrs[math.random(1,#clrs)])
        sleep(0.05)
    end
end

parallel.waitForAll(uis.main,main)