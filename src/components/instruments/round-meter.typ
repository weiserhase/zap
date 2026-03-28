#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import "../../mini.typ": ac-sign
#import "../../utils.typ": get-style
#import cetz.draw: anchor, circle, content, line, mark, polygon, rect

#let round-meter(name, node, measurand: str, ..params) = {
    // Drawing function
    let draw(ctx, position, style) = {
        interface((-style.radius, -style.radius), (style.radius, style.radius), io: position.len() < 2)
        circle((0, 0), radius: style.radius, fill: white, ..style)
        content((0, 0), measurand)
    }

    // Component call
    component("round-meter", name, node, draw: draw, ..params)
}

#let voltmeter(name, node, ..params) = round-meter(name, node, measurand: "V", ..params)
#let ammeter(name, node, ..params) = round-meter(name, node, measurand: "A", ..params)
#let ohmmeter(name, node, ..params) = round-meter(name, node, measurand: $Omega$, ..params)
#let wattmeter(name, node, ..params) = round-meter(name, node, measurand: "W", ..params)
