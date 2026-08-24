#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import "../../mini.typ": pins-extent, pins-labels, place-pins
#import cetz.draw: content, rect

// Generic rectangular block, with freely placed pins on all four sides.
//
// Each pin is a dictionary accepting the following keys:
// - `content`: the label drawn inside the block, a pin without content is a gap
// - `side`: `west`, `east`, `north` or `south`, defaults to `west`
// - `name`: an anchor name for the pin, on top of the positional `pin<i>` one
// - `clock`: draws the dynamic input wedge next to the pin
// - `invert`: draws an inversion bubble outside of the pin
#let block(name, node, pins: (), text: none, ..params) = {
    assert(std.type(pins) == array, message: "pins must be an array")
    assert(params.pos().len() == 0, message: "block supports only one node")

    // Drawing function
    let draw(ctx, position, style) = {
        let (min-width, min-height, spacing, h-spacing, padding, bubble) = style

        let extent = pins-extent(pins, spacing: spacing, h-spacing: h-spacing, padding: padding)
        let labels = pins-labels(ctx, pins)
        let title = if text == none { (0, 0) } else { cetz.util.measure(ctx, text) }

        // The title has to fit between the labels facing each other, each label
        // taking its own room plus a padding on each of its sides
        let room(size) = if size == 0 { padding } else { 2 * padding + size }
        let width = calc.max(min-width, extent.width, title.first() + 2 * room(calc.max(labels.west.width, labels.east.width)))
        let height = calc.max(min-height, extent.height, title.last() + 2 * room(calc.max(labels.north.height, labels.south.height)))

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        rect((-width / 2, -height / 2), (width / 2, height / 2), fill: style.fill, stroke: style.stroke)
        if text != none {
            content((0, 0), text)
        }

        place-pins(
            pins,
            (width, height),
            spacing: spacing,
            h-spacing: h-spacing,
            padding: padding,
            bubble: bubble,
            stroke: style.stroke,
            fill: style.fill,
        )
    }

    // Component call
    component("block", name, node, draw: draw, ..params)
}
