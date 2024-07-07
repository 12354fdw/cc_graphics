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
    local t = uis.createText()
    uis.setProp(t,"parent",term.current())
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
        uis.setProp(t,"tc",clrs[math.random(1,#clrs)])
        sleep(0.01)
    end
end

parallel.waitForAll(uis.main,main)