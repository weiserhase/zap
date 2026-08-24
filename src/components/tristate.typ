#import "../component.typ": component, interface
#import "../dependencies.typ": cetz
#import cetz.draw: anchor, circle, line

// Three-state buffer, with its enable entering the top edge.
#let tristate(name, node, invert: false, invert-enable: false, ..params) = {
    assert(std.type(invert) == bool, message: "invert must be of type bool")
    assert(std.type(invert-enable) == bool, message: "invert-enable must be of type bool")
    assert(params.pos().len() == 0, message: "tristate supports only one node")

    // Drawing function
    let draw(ctx, position, style) = {
        let (width, height, bubble) = style

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        anchor("in", (-width / 2, 0))
        anchor("out", (width / 2 + if invert { 2 * bubble } else { 0 }, 0))
        anchor("en", (0, height / 4 + if invert-enable { 2 * bubble } else { 0 }))

        line(
            (-width / 2, height / 2),
            (width / 2, 0),
            (-width / 2, -height / 2),
            close: true,
            stroke: style.stroke,
            fill: style.fill,
        )
        if invert {
            circle((width / 2 + bubble, 0), radius: bubble, stroke: style.stroke, fill: style.fill)
        }
        if invert-enable {
            circle((0, height / 4 + bubble), radius: bubble, stroke: style.stroke, fill: style.fill)
        }
    }

    // Component call
    component("tristate", name, node, draw: draw, ..params)
}
