#import "./dependencies.typ": cetz
#import "./utils.typ": get-style
#import cetz.draw: anchor, circle, content, hobby, line, merge-path, rotate, scope, set-origin, set-style
#import cetz.styles: merge

#let center-mark(symbol: ">") = {
    (end: ((pos: 50%, symbol: symbol, fill: black, anchor: "center"), (pos: 0%, symbol: ">", scale: 0)))
}

// Slash across a bus, with its width written next to it
#let bus-mark(position, angle, label, style) = {
    line(
        (rel: (radius: style.length / 2, angle: angle + style.angle), to: position),
        (rel: (radius: -style.length / 2, angle: angle + style.angle), to: position),
    )
    content(
        (rel: (radius: style.distance, angle: angle + 90deg), to: position),
        text(style.size, label),
        anchor: "center",
    )
}

#let lamp(pos, radius: .5, ..params) = {
    circle(pos, radius: radius, ..params)
    line((rel: (radius: radius, angle: 45deg), to: pos), (rel: (radius: -radius, angle: 45deg), to: pos), ..params)
    line((rel: (radius: radius, angle: -45deg), to: pos), (rel: (radius: -radius, angle: -45deg), to: pos), ..params)
}

#let adjust-arrow(type, ..params) = {
    scope(ctx => {
        let arrow-style = get-style(ctx).arrow
        let style = merge(arrow-style.at(type), params.named())
        style.scale *= arrow-style.scale

        let origin = (
            -style.ratio.at(0) * calc.cos(style.angle) * style.length,
            -style.ratio.at(1) * calc.sin(style.angle) * style.length,
        )

        if type == "sensor" {
            anchor("label", origin)
            anchor("wiper", (to: origin, rel: (-style.sensor-length, 0)))
        } else {
            anchor("wiper", origin)
        }

        set-origin(origin)
        rotate(style.angle)

        anchor("tip", (style.length, 0))

        set-style(
            stroke: style.stroke,
            mark: (
                end: style.symbol,
                scale: style.scale,
            ),
        )
        if type == "variable" {
            line("wiper", "tip", mark: (
                stroke: (thickness: 0pt),
                fill: style.stroke.paint,
            ))
        } else if type == "preset" {
            line("wiper", "tip", mark: (
                stroke: style.stroke,
                width: style.width,
            ))
        } else if type == "sensor" {
            line("wiper", "label", "tip", mark: (
                stroke: style.stroke,
            ))
        }
    })
    if type == "sensor" {
        anchor("label", "label")
    }
    anchor("wiper", "wiper")
    anchor("tip", "tip")
}

#let radiation-arrows(origin, ..params) = {
    scope(ctx => {
        let arrow-style = get-style(ctx).arrow
        let style = merge(arrow-style.radiation, params.named())
        style.scale *= arrow-style.scale

        set-origin(origin)
        rotate(style.angle)
        set-style(
            stroke: style.stroke,
            mark: (
                stroke: (thickness: 0pt),
                scale: style.scale,
                fill: style.stroke.paint,
            ),
        )

        let pos = if style.reversed { "start" } else { "end" }
        line((style.length, -style.distance), (0, -style.distance), mark: ((pos): style.symbol))
        line((style.length, +style.distance), (0, +style.distance), mark: ((pos): style.symbol))
    })
}

#let adjustable-arrow(node, ..params) = {
    scope(ctx => {
        let arrow-style = get-style(ctx).arrow
        let style = merge(arrow-style.adjustable, params.named())
        style.scale *= arrow-style.scale

        anchor("adjust", (to: node, rel: (0, style.length)))
        anchor("tip", node)

        line("adjust", "tip", stroke: style.stroke, mark: (
            stroke: (thickness: 0pt),
            end: style.symbol,
            scale: style.scale,
            fill: style.stroke.paint,
        ))
    })
    anchor("adjust", "adjust")
    anchor("a", "adjust")
    anchor("tip", "tip")
}

#let dc-sign() = {
    let width = 10pt
    let spacing = 1.5pt
    let vspace = 3pt
    let symbol-stroke = 0.55pt
    let tick-width = (width - 2 * spacing) / 3

    set-style(stroke: symbol-stroke)

    line((-width / 2, 0), (width / 2, 0))
    line((-width / 2, -vspace), (-width / 2 + tick-width, -vspace))
    line((-tick-width / 2, -vspace), (tick-width / 2, -vspace))
    line((width / 2, -vspace), (width / 2 - tick-width, -vspace))
}

#let ac-sign(size: 1, waveform: "sine") = {
    assert(
        waveform in ("sine", "sin", "square", "rect", "rectangular", "triangle", "tri", "sawtooth", "saw", "saw-tooth"),
        message: "waveform must be sine, square, triangle, or sawtooth",
    )

    let waveform = if waveform in ("sine", "sin") {
        "sine"
    } else if waveform in ("square", "rect", "rectangular") {
        "square"
    } else if waveform in ("triangle", "tri") {
        "triangle"
    } else {
        "sawtooth"
    }
    let width = 10pt * size
    let height = 4pt * size
    let symbol-stroke = 0.55pt

    set-style(stroke: symbol-stroke)

    if waveform == "square" {
        let height-mod = height / 1.5
        line(
            (0, 0),
            (rel: (0, height-mod)),
            (rel: (width / 2, 0)),
            (rel: (0, -2 * height-mod)),
            (rel: (width / 2, 0)),
            (rel: (0, height-mod)),
        )
    } else if waveform == "triangle" {
        line(
            (0, 0),
            (rel: (width / 4, height)),
            (rel: (width / 4, -height)),
            (rel: (width / 4, height)),
        )
    } else if waveform == "sawtooth" {
        line(
            (0, 0),
            (rel: (width / 2, height)),
            (rel: (0, -height)),
            (rel: (width / 2, height)),
        )
    } else {
        // Default to sine wave
        hobby(
            (-width / 2, 0),
            (-width / 4, height / 2),
            (width / 4, -height / 2),
            (width / 2, 0),
        )
    }
}

#let clock-wedge(size: 1) = {
    let width = 5pt * size
    let height = 10pt * size
    let symbol-stroke = 0.55pt

    set-style(stroke: symbol-stroke)

    merge-path({
        line((0, height / 2), (width, 0))
        line((0, -height / 2), (width, 0))
    })
}

// Side of a pin, as used by the components drawing a box with pins around it
#let pin-side(pin) = {
    let side = pin.at("side", default: "west")
    assert(side in ("west", "east", "north", "south"), message: "pin side must be west, east, north or south")
    side
}

// Room needed by the pins of each side of a box
#let pins-extent(pins, spacing: .55, h-spacing: .9, padding: .28) = {
    let count(side) = pins.filter(pin => pin-side(pin) == side).len()
    let span(side, gap) = calc.max(0, count(side) - 1) * gap + 2 * padding
    (
        width: calc.max(span("north", h-spacing), span("south", h-spacing)),
        height: calc.max(span("west", spacing), span("east", spacing)),
    )
}

// Room taken by the labels of the pins of each side
#let pins-labels(ctx, pins, wedge: .2) = {
    let extent(side) = {
        let sizes = pins
            .filter(pin => pin-side(pin) == side)
            .map(pin => {
                let (width, height) = cetz.util.measure(ctx, pin.at("content", default: []))
                let room = if pin.at("clock", default: false) { wedge } else { 0 }
                if side in ("west", "east") { (width + room, height) } else { (width, height + room) }
            })
        (
            width: calc.max(0, ..sizes.map(size => size.first())),
            height: calc.max(0, ..sizes.map(size => size.last())),
        )
    }
    (west: extent("west"), east: extent("east"), north: extent("north"), south: extent("south"))
}

// Draws the pins of a box of the given size, with their label, anchors,
// inversion bubble and dynamic input wedge
#let place-pins(pins, size, spacing: .55, h-spacing: .9, padding: .28, bubble: .09, wedge: .2, stroke: auto, fill: none) = {
    let (width, height) = size
    let count(side) = pins.filter(pin => pin-side(pin) == side).len()

    let counters = (west: 0, east: 0, north: 0, south: 0)
    for (index, pin) in pins.enumerate() {
        assert(std.type(pin) == dictionary, message: "pins must be dictionaries")
        let side = pin-side(pin)
        let gap = if side in ("west", "east") { spacing } else { h-spacing }
        let offset = (count(side) - 1) * gap / 2 - counters.at(side) * gap
        counters.at(side) += 1

        let (edge, direction) = if side == "west" {
            ((-width / 2, offset), (-1, 0))
        } else if side == "east" {
            ((width / 2, offset), (1, 0))
        } else if side == "north" {
            ((-offset, height / 2), (0, 1))
        } else {
            ((-offset, -height / 2), (0, -1))
        }

        // The inversion bubble sits outside of the box, the pin behind it
        let inverted = pin.at("invert", default: false)
        if inverted {
            circle(
                (edge.at(0) + direction.at(0) * bubble, edge.at(1) + direction.at(1) * bubble),
                radius: bubble,
                fill: fill,
                stroke: stroke,
            )
        }
        let distance = if inverted { 2 * bubble } else { 0 }
        let position = (edge.at(0) + direction.at(0) * distance, edge.at(1) + direction.at(1) * distance)

        anchor("pin" + str(index + 1), position)
        if "name" in pin {
            anchor(pin.name, position)
        }

        // Labels of clocked pins leave room for the wedge
        let clocked = pin.at("clock", default: false)
        content(edge, pin.at("content", default: ""), anchor: side, padding: padding + if clocked { wedge } else { 0 })
        if clocked {
            let angle = if side == "west" { 0deg } else if side == "east" { 180deg } else if side == "north" { -90deg } else { 90deg }
            content(edge, [#cetz.canvas({ clock-wedge() })], anchor: "west", angle: angle)
        }
    }
}
