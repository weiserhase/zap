#import "../component.typ": component, interface
#import "../dependencies.typ": cetz
#import "../mini.typ": pin-side, pins-extent, pins-labels, place-pins
#import cetz.draw: anchor, content, line, rect

// Default pins of a framed register or register bank
#let default-pins = (
    (name: "d", content: "D", side: "west"),
    (name: "q", content: "Q", side: "east"),
    (name: "clk", content: "CLK", side: "south", clock: true),
)

// Turns `values` into one content per cell, padded on the left
#let cells-of(values, bits) = {
    let cells = if values == none {
        ()
    } else if std.type(values) == int {
        let (digits, rest) = ((), values)
        while rest > 0 {
            digits.push(str(calc.rem(rest, 2)))
            rest = calc.div-euclid(rest, 2)
        }
        digits.rev()
    } else if std.type(values) == str {
        values.clusters()
    } else {
        values
    }

    let padding = if std.type(values) in (int, str) { "0" } else { none }
    cells = range(calc.max(0, bits - cells.len())).map(_ => padding) + cells
    cells.slice(cells.len() - bits)
}

// Draws the cells of one row, from the most to the least significant bit
#let draw-row(origin, bits, cells, style) = {
    let (x, y) = origin
    for bit in range(1, bits) {
        line((x + bit * style.cell-width, y - style.cell-height / 2), (rel: (0, style.cell-height)))
    }
    for bit in range(bits) {
        let value = cells.at(bit, default: none)
        if value != none {
            content(
                (x + (bit + 0.5) * style.cell-width, y),
                if std.type(value) in (int, float) { str(value) } else { value },
            )
        }
    }
}

// Room left around the cells for the pin labels and the bit indices
#let frame-margins(ctx, pins, indices, style) = {
    let labels = pins-labels(ctx, pins)
    let index-height = if indices {
        style.distance + cetz.util.measure(ctx, text(0.7em, "0")).last()
    } else {
        0
    }
    // A label takes its own room, plus a padding on each of its sides
    let room(size) = if size == 0 { style.padding } else { 2 * style.padding + size }
    (
        horizontal: room(calc.max(labels.west.width, labels.east.width)),
        vertical: room(calc.max(labels.north.height, labels.south.height)) + index-height,
    )
}

// Resolves the `pins` parameter, `auto` giving the default set
#let resolve-pins(pins) = {
    if pins == auto { default-pins } else if pins == none { () } else { pins }
}

// Single register, drawn as one cell per storable bit. With `pins` or `frame`,
// the cells are enclosed in a frame carrying the connections.
#let register(
    name,
    node,
    bits: 8,
    values: none,
    indices: false,
    frame: auto,
    pins: none,
    ..params,
) = {
    assert(std.type(bits) == int and bits >= 1, message: "bits must be a positive integer")
    assert(std.type(indices) == bool, message: "indices must be of type bool")
    assert(pins in (none, auto) or std.type(pins) == array, message: "pins must be none, auto or an array")
    assert(params.pos().len() == 0, message: "register supports only one node")

    let pins = resolve-pins(pins)
    let framed = if frame == auto { pins.len() > 0 } else { frame }

    // Drawing function
    let draw(ctx, position, style) = {
        let cells = (width: bits * style.cell-width, height: style.cell-height)

        let (width, height) = if framed {
            let margins = frame-margins(ctx, pins, indices, style)
            let extent = pins-extent(pins, spacing: style.spacing, h-spacing: style.h-spacing, padding: style.padding)
            (
                calc.max(style.min-width, cells.width + 2 * margins.horizontal, extent.width),
                calc.max(style.min-height, cells.height + 2 * margins.vertical, extent.height),
            )
        } else {
            (cells.width, cells.height)
        }

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        if framed {
            rect((-width / 2, -height / 2), (width / 2, height / 2), stroke: style.stroke, fill: style.fill)
            place-pins(
                pins,
                (width, height),
                spacing: style.spacing,
                h-spacing: style.h-spacing,
                padding: style.padding,
                bubble: style.bubble,
                stroke: style.stroke,
                fill: style.fill,
            )
        } else {
            anchor("d", (-cells.width / 2, 0))
            anchor("q", (cells.width / 2, 0))
        }

        rect(
            (-cells.width / 2, -cells.height / 2),
            (cells.width / 2, cells.height / 2),
            stroke: style.stroke,
            fill: style.fill,
        )
        draw-row((-cells.width / 2, 0), bits, cells-of(values, bits), style)

        for bit in range(bits) {
            // Bit 0 is the rightmost cell
            let x = cells.width / 2 - (bit + 0.5) * style.cell-width
            anchor("bit" + str(bit), (x, -cells.height / 2))
            if indices {
                content((x, cells.height / 2 + style.distance), text(0.7em, str(bit)), anchor: "south")
            }
        }
    }

    // Component call
    component("register", name, node, draw: draw, ..params)
}

// Bank of `rows` registers of `bits` bits each. Rows beyond `max-rows` are
// elided, the first ones and the last one being kept.
#let register-bank(
    name,
    node,
    rows: 4,
    bits: 8,
    names: auto,
    values: none,
    indices: false,
    max-rows: 5,
    frame: auto,
    pins: none,
    ..params,
) = {
    assert(std.type(rows) == int and rows >= 1, message: "rows must be a positive integer")
    assert(std.type(bits) == int and bits >= 1, message: "bits must be a positive integer")
    assert(std.type(max-rows) == int and max-rows >= 2, message: "max-rows must be an integer greater than 1")
    assert(names == auto or names == none or std.type(names) == array, message: "names must be auto, none or an array")
    assert(pins in (none, auto) or std.type(pins) == array, message: "pins must be none, auto or an array")
    assert(params.pos().len() == 0, message: "register bank supports only one node")

    let pins = resolve-pins(pins)
    let framed = if frame == auto { pins.len() > 0 } else { frame }

    // Drawing function
    let draw(ctx, position, style) = {
        // Rows actually drawn, `none` standing for the elided ones
        let visible = if rows <= max-rows {
            range(rows)
        } else {
            range(max-rows - 1) + (none, rows - 1)
        }

        let index-width = if names == none { 0 } else { style.index-width }
        let grid = (
            width: index-width + bits * style.cell-width,
            height: visible.len() * style.cell-height,
        )

        let (width, height) = if framed {
            let margins = frame-margins(ctx, pins, indices, style)
            let extent = pins-extent(pins, spacing: style.spacing, h-spacing: style.h-spacing, padding: style.padding)
            (
                calc.max(style.min-width, grid.width + 2 * margins.horizontal, extent.width),
                calc.max(style.min-height, grid.height + 2 * margins.vertical, extent.height),
            )
        } else {
            (grid.width, grid.height)
        }

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        if framed {
            rect((-width / 2, -height / 2), (width / 2, height / 2), stroke: style.stroke, fill: style.fill)
            place-pins(
                pins,
                (width, height),
                spacing: style.spacing,
                h-spacing: style.h-spacing,
                padding: style.padding,
                bubble: style.bubble,
                stroke: style.stroke,
                fill: style.fill,
            )
        }

        rect(
            (-grid.width / 2, -grid.height / 2),
            (grid.width / 2, grid.height / 2),
            stroke: style.stroke,
            fill: style.fill,
        )
        if names != none {
            line((-grid.width / 2 + index-width, -grid.height / 2), (rel: (0, grid.height)))
        }

        for (position, row) in visible.enumerate() {
            let y = grid.height / 2 - (position + 0.5) * style.cell-height
            if position > 0 {
                line((-grid.width / 2, y + style.cell-height / 2), (rel: (grid.width, 0)))
            }

            if row == none {
                // Elided rows, one ellipsis per column
                if names != none {
                    content((-grid.width / 2 + index-width / 2, y), sym.dots.v)
                }
                for bit in range(bits) {
                    content((-grid.width / 2 + index-width + (bit + 0.5) * style.cell-width, y), sym.dots.v)
                }
                continue
            }

            if names != none {
                let label = if names == auto { text(0.8em, "R" + str(row)) } else { names.at(row, default: []) }
                content((-grid.width / 2 + index-width / 2, y), label)
            }
            let row-values = if std.type(values) == array and values.len() > row { values.at(row) } else { none }
            draw-row((-grid.width / 2 + index-width, y), bits, cells-of(row-values, bits), style)

            if not framed {
                anchor("in" + str(row), (-grid.width / 2, y))
                anchor("out" + str(row), (grid.width / 2, y))
            } else {
                anchor("row" + str(row), (-grid.width / 2, y))
            }
        }

        if indices {
            for bit in range(bits) {
                content(
                    (grid.width / 2 - (bit + 0.5) * style.cell-width, grid.height / 2 + style.distance),
                    text(0.7em, str(bit)),
                    anchor: "south",
                )
            }
        }
    }

    // Component call
    component("register-bank", name, node, draw: draw, ..params)
}
