#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line

// Trapezoidal multiplexer or demultiplexer.
//
// mux:   `ports` data inputs on the tall left side, one output on the right
// demux: one input on the left, `ports` data outputs on the tall right side
//
// In both cases the select input sits on the bottom edge, and the data ports are
// numbered from 0, so the port number is the value the select input must take.
#let multiplexer(
    name,
    node,
    ports: 2,
    labels: auto,
    reverse: false,
    ..params,
) = {
    assert(std.type(ports) == int and ports >= 2, message: "ports must be an integer greater than 1")
    assert(labels == auto or labels == none or std.type(labels) == array, message: "labels must be auto, none or an array")
    assert(std.type(reverse) == bool, message: "reverse must be of type bool")
    assert(params.pos().len() == 0, message: "multiplexer supports only one node")

    // Drawing function
    let draw(ctx, position, style) = {
        let (width, spacing, padding, cut, min-height) = style

        let height = calc.max(min-height, (ports - 1) * spacing + 2 * padding)
        let labels = if labels == auto { range(ports).map(str) } else { labels }
        // The tall side carries the data ports, the short one the single port
        let sgn = if reverse { -1 } else { 1 }
        let (data, single) = (-sgn * width / 2, sgn * width / 2)

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        for port in range(ports) {
            anchor(
                (if reverse { "out" } else { "in" }) + str(port),
                (data, (ports - 1) * spacing / 2 - port * spacing),
            )
        }
        anchor(if reverse { "in" } else { "out" }, (single, 0))
        anchor("sel", (0, -height / 2 + cut / 2))

        line(
            (data, height / 2),
            (single, height / 2 - cut),
            (single, -height / 2 + cut),
            (data, -height / 2),
            close: true,
            stroke: style.stroke,
            fill: style.fill,
        )

        if labels != none {
            // Half the padding only, so that the outer labels stay clear of the slanted edges
            for (port, label) in labels.enumerate() {
                content(
                    (rel: (sgn * padding / 2, 0), to: (data, (ports - 1) * spacing / 2 - port * spacing)),
                    label,
                    anchor: if reverse { "east" } else { "west" },
                )
            }
        }
    }

    // Component call
    component("mux", name, node, draw: draw, ..params)
}

#let mux(name, node, ..params) = multiplexer(name, node, ..params, reverse: false)
#let demux(name, node, ..params) = multiplexer(name, node, ..params, reverse: true)
