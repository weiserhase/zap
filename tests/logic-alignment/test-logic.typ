#import "/src/lib.typ": cetz, component, interface
#import cetz.draw: anchor

#let test-logic-gate(
    name,
    node,
    north: false,
    west: false,
    east: false,
    south: false,
    radius: 0.18,
    width: 2.0,
    height: 1.2,
    inset: 0.0,
    text: none,
    ..params,
) = {
    assert(type(north) == bool, message: "north must be a bool")
    assert(type(west) == bool, message: "west must be a bool")
    assert(type(east) == bool, message: "east must be a bool")
    assert(type(south) == bool, message: "south must be a bool")
    assert(inset >= 0, message: "inset must be >= 0")
    assert(2 * inset < width, message: "inset must be smaller than half width")
    assert(2 * inset < height, message: "inset must be smaller than half height")

    let draw(ctx, position, style) = {
        interface((-width / 2, -height / 2), (width / 2, height / 2), io: false)

        let fill = style.at("fill", default: none)
        let stroke = style.at("stroke", default: auto)
        let left = -width / 2 + inset
        let right = width / 2 - inset
        let top = height / 2 - inset
        let bottom = -height / 2 + inset

        cetz.draw.rect(
            (left, top),
            (right, bottom),
            fill: fill,
            stroke: stroke,
        )

        if text != none {
            cetz.draw.content("bounds.center", text, anchor: "center")
        }

        if north {
            cetz.draw.circle((0, top), radius: radius, fill: fill, stroke: stroke)
        }
        if west {
            cetz.draw.circle((left, 0), radius: radius, fill: fill, stroke: stroke)
        }
        if east {
            cetz.draw.circle((right, 0), radius: radius, fill: fill, stroke: stroke)
        }
        if south {
            cetz.draw.circle((0, bottom), radius: radius, fill: fill, stroke: stroke)
        }
        // anchor("default", (0, 0))
    }

    component("test-logic-gate", name, node, draw: draw, ..params)
}
