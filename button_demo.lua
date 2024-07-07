local uis = require("graphics")

local clicked = 0

function main()
    local t = uis.createText()
    uis.setProp(t,"parent",term.current())
    uis.setProp(t,"size",{
        scaleX = 0.25,
        scaleY = 0.5,
        offX = 0,
        offY = 0
    })
    uis.setProp(t,"pos",{
        scaleX = 0.5,
        scaleY = 0.25,
        offX = 0,
        offY = 0
    })
    uis.setProp(t,"bg",colors.green)
    uis.setProp(t,"text","Clicked: "..clicked)

    local b = uis.createButton()
    uis.setProp(b,"parent",term.current())
    uis.setProp(b,"text","Click me!")
    uis.setProp(b,"size",{
        scaleX = 0.25,
        scaleY = 0.5,
        offX = 0,
        offY = 0
    })
    uis.setProp(b,"pos",{
        scaleX = 0.25,
        scaleY = 0.25,
        offX = 0,
        offY = 0
    })
    uis.setProp(b,"bg",colors.blue)
    uis.setProp(b,"activation", function ()
        clicked = clicked + 1
        uis.setProp(t,"text","Clicked: "..clicked)
    end)
end

parallel.waitForAll(uis.buttonHandler,uis.main,main)