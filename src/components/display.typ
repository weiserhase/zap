#import "../component.typ": component, interface
#import "../dependencies.typ": cetz
#import "../mini.typ": bus-mark
#import "../utils.typ": get-style
#import cetz.draw: anchor, circle, content, line, rect

#let segments-of = (
    "0": ("a", "b", "c", "d", "e", "f"),
    "1": ("b", "c"),
    "2": ("a", "b", "g", "e", "d"),
    "3": ("a", "b", "g", "c", "d"),
    "4": ("f", "g", "b", "c"),
    "5": ("a", "f", "g", "c", "d"),
    "6": ("a", "f", "g", "e", "c", "d"),
    "7": ("a", "b", "c"),
    "8": ("a", "b", "c", "d", "e", "f", "g"),
    "9": ("a", "b", "c", "d", "f", "g"),
    "A": ("a", "b", "c", "e", "f", "g"),
    "B": ("c", "d", "e", "f", "g"),
    "C": ("a", "d", "e", "f"),
    "D": ("b", "c", "d", "e", "g"),
    "E": ("a", "d", "e", "f", "g"),
    "F": ("a", "e", "f", "g"),
)

// Seven segment display.
//
// The lit segments are given either by `digit` (0 to 9 and A to F) or by an
// explicit `segments` list. `dot` adds the decimal point, `none` leaves it out,
// `false` draws it unlit and `true` lights it up.
//
// `pins` chooses how the display is connected: `"bus"` gives a single input
// carrying one bit per segment, `"single"` one input per segment, and `none`
// draws the bare digit. With pins, the `a` to `g` (and `dp`) anchors sit at the
// end of the leads, otherwise they sit on the segments themselves.
#let seven-segment(
    name,
    node,
    digit: none,
    segments: none,
    dot: none,
    pins: none,
    frame: auto,
    ..params,
) = {
    assert(segments == none or std.type(segments) == array, message: "segments must be none or an array")
    assert(dot in (none, true, false), message: "dot must be none, true or false")
    assert(pins in (none, "bus", "single"), message: "pins must be none, `bus` or `single`")
    assert(params.pos().len() == 0, message: "seven-segment supports only one node")

    // Drawing function
    let draw(ctx, position, style) = {
        let (width, height, thickness, gap, padding, spacing, length, label-width) = style

        let lit = if segments != none {
            segments
        } else if digit != none {
            segments-of.at(upper(str(digit)), default: ())
        } else {
            ()
        }
        let on = if style.on == auto { style.stroke.paint } else { style.on }
        let frame = if frame == auto { pins != none } else { frame }

        // Segment shapes: elongated hexagons, horizontal or vertical
        let shape(center, size, horizontal) = {
            let (cx, cy) = center
            let (half, edge) = (size / 2, thickness / 2)
            if horizontal {
                (
                    (cx - half, cy),
                    (cx - half + edge, cy + edge),
                    (cx + half - edge, cy + edge),
                    (cx + half, cy),
                    (cx + half - edge, cy - edge),
                    (cx - half + edge, cy - edge),
                )
            } else {
                (
                    (cx, cy - half),
                    (cx + edge, cy - half + edge),
                    (cx + edge, cy + half - edge),
                    (cx, cy + half),
                    (cx - edge, cy + half - edge),
                    (cx - edge, cy - half + edge),
                )
            }
        }
        let bar = width - gap
        let column = height / 2 - gap
        let placement = (
            a: ((0, height / 2), bar, true),
            b: ((width / 2, height / 4), column, false),
            c: ((width / 2, -height / 4), column, false),
            d: ((0, -height / 2), bar, true),
            e: ((-width / 2, -height / 4), column, false),
            f: ((-width / 2, height / 4), column, false),
            g: ((0, 0), bar, true),
        )

        // Envelope
        let dot-width = if dot == none { 0 } else { gap + thickness }
        let column-width = if pins == "single" { label-width } else { 0 }
        let left = -(width / 2 + thickness / 2 + padding + column-width)
        let right = width / 2 + thickness / 2 + padding + dot-width
        let ports = ("a", "b", "c", "d", "e", "f", "g") + if dot == none { () } else { ("dp",) }
        let leads = if pins == "single" { ports.len() } else if pins == "bus" { 1 } else { 0 }
        let inner = calc.max(height + thickness + 2 * padding, calc.max(0, leads - 1) * spacing + 2 * padding)

        if frame {
            interface((left, -inner / 2), (right, inner / 2))
            rect((left, -inner / 2), (right, inner / 2), stroke: style.stroke, fill: style.fill)
        } else {
            interface(
                (-(width / 2 + thickness / 2), -(height / 2 + thickness / 2)),
                (width / 2 + thickness / 2 + dot-width, height / 2 + thickness / 2),
            )
        }

        // Segments
        for (segment, (center, size, horizontal)) in placement {
            line(
                ..shape(center, size, horizontal),
                close: true,
                stroke: style.stroke,
                fill: if segment in lit { on } else { style.off },
            )
        }
        if dot != none {
            circle(
                (width / 2 + gap + thickness, -height / 2),
                radius: thickness / 2,
                stroke: style.stroke,
                fill: if dot { on } else { style.off },
            )
        }

        // Connections
        if pins == none {
            for (segment, (center, ..)) in placement {
                anchor(segment, center)
            }
            if dot != none {
                anchor("dp", (width / 2 + gap + thickness, -height / 2))
            }
        } else if pins == "bus" {
            anchor("in", (left - length, 0))
            line((left, 0), "in", stroke: get-style(ctx).wire.stroke)
            bus-mark(
                (left - length / 2, 0),
                0deg,
                str(ports.len()),
                get-style(ctx).wire.bits,
            )
        } else {
            for (index, port) in ports.enumerate() {
                let y = (ports.len() - 1) * spacing / 2 - index * spacing
                anchor(port, (left - length, y))
                line((left, y), (left - length, y), stroke: get-style(ctx).wire.stroke)
                content((left + padding / 2, y), text(0.75em, port), anchor: "west")
            }
        }
    }

    // Component call
    component("seven-segment", name, node, draw: draw, ..params)
}
