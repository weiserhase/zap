#import "../component.typ": component, interface
#import "../dependencies.typ": cetz
#import cetz.draw: anchor, content, line

// Bus splitter or merger: a single wide bus on one side, `ways` narrower ones on
// the other, joined by a thick spine.
//
// splitter: the bus comes in on the west and is split into `ways` outputs
// merger:   `ways` inputs on the west are merged into a single bus on the east
#let bus-splice(name, node, ways: 2, labels: none, reverse: false, ..params) = {
    assert(std.type(ways) == int and ways >= 2, message: "ways must be an integer greater than 1")
    assert(labels == none or labels == auto or std.type(labels) == array, message: "labels must be none, auto or an array")
    assert(params.pos().len() == 0, message: "bus splice supports only one node")

    // Drawing function
    let draw(ctx, position, style) = {
        let (width, spacing, padding, distance, min-height, spine) = style

        let height = calc.max(min-height, (ways - 1) * spacing + 2 * padding)
        let labels = if labels == auto { range(ways).map(str) } else { labels }
        // The many ports sit on the side opposite to the single bus
        let sgn = if reverse { -1 } else { 1 }
        let (single, many) = (-sgn * width / 2, sgn * width / 2)

        interface((-width / 2, -height / 2), (width / 2, height / 2))

        anchor(if reverse { "out" } else { "in" }, (single, 0))
        for way in range(ways) {
            anchor(
                (if reverse { "in" } else { "out" }) + str(way),
                (many, (ways - 1) * spacing / 2 - way * spacing),
            )
        }

        let thickness = style.stroke
        if std.type(thickness) == dictionary {
            thickness.insert("thickness", thickness.at("thickness", default: 0.8pt) * spine)
        }
        line((0, -height / 2), (0, height / 2), stroke: thickness)
        line((single, 0), (0, 0), stroke: style.stroke)

        for way in range(ways) {
            let y = (ways - 1) * spacing / 2 - way * spacing
            line((0, y), (many, y), stroke: style.stroke)
            if labels != none {
                // Centered above its own branch, clear of the line
                content(
                    (many / 2, y + distance),
                    text(0.8em, labels.at(way, default: [])),
                    anchor: "south",
                )
            }
        }
    }

    // Component call
    component("bus", name, node, draw: draw, ..params)
}

#let splitter(name, node, ..params) = bus-splice(name, node, ..params, reverse: false)
#let merger(name, node, ..params) = bus-splice(name, node, ..params, reverse: true)
