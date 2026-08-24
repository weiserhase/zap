#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line

// Arithmetic logic unit, drawn with the usual notched left side.
//
// Anchors: `a` and `b` for the operands, `y` for the result, `op` on the bottom
// edge for the function select and `f` on the top edge for the status flags.
#let alu(name, node, text: [ALU], ..params) = {
    assert(params.pos().len() == 0, message: "alu supports only one node")

    // Drawing function
    let draw(ctx, position, style) = {
        let (width, height, notch, taper) = style

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        anchor("a", (-width / 2, height / 4))
        anchor("b", (-width / 2, -height / 4))
        anchor("y", (width / 2, 0))
        anchor("op", (-width / 4, -height / 2 + taper / 4))
        anchor("f", (-width / 4, height / 2 - taper / 4))

        line(
            (-width / 2, height / 2),
            (width / 2, height / 2 - taper),
            (width / 2, -height / 2 + taper),
            (-width / 2, -height / 2),
            (-width / 2, -notch),
            (-width / 2 + notch, 0),
            (-width / 2, notch),
            close: true,
            stroke: style.stroke,
            fill: style.fill,
        )

        if text != none {
            content((notch / 2, 0), text)
        }
    }

    // Component call
    component("alu", name, node, draw: draw, ..params)
}
