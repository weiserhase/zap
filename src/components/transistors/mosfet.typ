#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import "../node.typ": node as junction
#import "../wire.typ": wire
#import cetz.draw: anchor, circle, line, mark, set-style

// MOSFET drawn vertically with the gate on the left.
//
// n-type: drain on top, source at the bottom, bulk arrow pointing towards the channel
// p-type: source on top, drain at the bottom, bulk arrow pointing away from the channel
//
// The bulk is tied to the source by default, left free on the `b` anchor with `bulk: "external"`,
// or not drawn at all with `bulk: none`, the arrow then sitting on the source lead.
#let mosfet(
    name,
    node,
    type: "n",
    channel: none,
    envelope: false,
    mode: "enhancement",
    bulk: "internal",
    ..params,
) = {
    // `channel` is kept as an alias of `type`
    let type = if channel != none { channel } else { type }

    assert(std.type(envelope) == bool, message: "envelope must be of type bool")
    assert(mode in ("enhancement", "depletion"), message: "mode must be `enhancement` or `depletion`")
    assert(type in ("p", "n"), message: "type must be `p` or `n`")
    assert(bulk in ("internal", "external", none), message: "bulk must be `internal`, `external` or none")

    // Drawing function
    let draw(ctx, position, style) = {
        let (width, height, gate-width, gate-length, gate-distance, segment-spacing, radius) = style

        // The p-type symbol is the n-type one mirrored vertically
        let sgn = if type == "n" { 1 } else { -1 }
        let bar-length = (gate-width - 2 * segment-spacing) / 3
        let offset = bar-length + segment-spacing // distance of the drain and source segments to the center
        let gate-x = -height - gate-distance

        interface((gate-x, -width / 2), (0, width / 2))

        anchor("d", (0, sgn * width / 2))
        anchor("s", (0, -sgn * width / 2))
        anchor("g", (gate-x - gate-length, 0))
        if bulk == "internal" {
            anchor("b", (0, -sgn * offset))
        } else if bulk == "external" {
            anchor("b", (0, 0))
        }

        set-style(stroke: style.stroke)
        if envelope {
            circle((gate-x / 2, 0), radius: radius, fill: style.fill, name: "c")
        }

        // Gate electrode and channel
        line((gate-x, -gate-width / 2), (rel: (0, gate-width)))
        if mode == "enhancement" {
            for i in range(3) {
                line((-height, -gate-width / 2 + i * (bar-length + segment-spacing)), (rel: (0, bar-length)))
            }
        } else {
            line((-height, -gate-width / 2), (rel: (0, gate-width)))
        }

        // Gate, drain and source connections
        wire("g", (gate-x, 0))
        wire((-height, offset), (0, offset), (0, width / 2))
        wire((-height, -offset), (0, -offset), (0, -width / 2))

        if bulk == none {
            // Without bulk, the arrow sits on the source lead
            mark(
                (-height / 2, -sgn * offset),
                (rel: (height, 0)),
                symbol: if type == "n" { ">" } else { "<" },
                fill: black,
                anchor: "center",
            )
        } else {
            // Bulk connection, routed to the source or left to the user
            if bulk == "internal" {
                wire((-height, 0), (0, 0), "b")
                junction("bulk", "b")
            } else {
                wire((-height, 0), (0, 0))
            }
            mark(
                (-height / 2, 0),
                (if type == "n" { -height } else { 0 }, 0),
                symbol: ">",
                fill: black,
                anchor: "center",
            )
        }
    }

    // Component call
    component("mosfet", name, node, draw: draw, ..params)
}

#let pmos(name, node, ..params) = mosfet(name, node, type: "p", ..params)
#let nmos(name, node, ..params) = mosfet(name, node, type: "n", ..params)
#let pmosd(name, node, ..params) = mosfet(name, node, type: "p", mode: "depletion", ..params)
#let nmosd(name, node, ..params) = mosfet(name, node, type: "n", mode: "depletion", ..params)
