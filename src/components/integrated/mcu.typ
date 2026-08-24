#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line, polygon, rect, scope, translate

#let opposite-anchor(side) = {
    if "west" in side { "east" } else if "north" in side { "south" } else if "east" in side { "west" } else if "south" in side { "north" }
}

#let mcu(name, node, pins: (), invert: false, ..params) = {
    assert(params.pos().len() == 0, message: "mcu supports only one node")
    assert(type(pins) == array or type(pins) == int, message: "pins should be an array or integer")

    // Drawing function
    let draw(ctx, position, style) = {
        let pins = if type(pins) == int {
            let pins_west = calc.ceil(pins / 2)
            range(pins).map(i => (
                content: str(i + 1),
                side: if i < pins_west { "west" } else { "east" },
            ))
        } else {
            pins
        }
        let side-of(pin) = {
            let side = pin.at("side", default: "west")
            if side in ("west", "east", "north", "south") { side } else { "west" }
        }
        let count(side) = pins.filter(pin => side-of(pin) == side).len()

        let height = calc.max(style.min-height, calc.max(count("west"), count("east")) * style.spacing + 2 * style.padding)
        let width = calc.max(style.width, calc.max(count("north"), count("south")) * style.h-spacing + 2 * style.padding)
        interface((-width / 2, -height / 2), (width / 2, height / 2))

        rect((-width / 2, -height / 2), (width / 2, height / 2), fill: style.fill, stroke: style.stroke)

        let counters = (west: 0, east: 0, north: 0, south: 0)
        for (index, pin) in pins.enumerate() {
            assert(type(pin) == dictionary, message: "pins must be dictionnaries")
            let side = side-of(pin)
            counters.at(side) += 1
            let counter = counters.at(side)

            let position = if side == "west" {
                (-width / 2, height / 2 - counter * style.spacing)
            } else if side == "east" {
                (width / 2, height / 2 - counter * style.spacing)
            } else if side == "north" {
                (-width / 2 + counter * style.h-spacing, height / 2)
            } else {
                (-width / 2 + counter * style.h-spacing, -height / 2)
            }

            anchor("pin" + str(index + 1), position)
            content("pin" + str(index + 1), pin.at("content", default: ""), anchor: side, padding: style.padding)
        }
    }

    // Component call
    component("mcu", name, node, draw: draw, ..params)
}
