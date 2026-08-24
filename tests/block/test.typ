#import "../utils.typ": test
#import "../../src/lib.typ"

// Test pin sides
#test({
    import lib: *
    block("b1", (0, 0), text: [Reg], pins: (
        (content: "D", side: "west"),
        (content: "Q", side: "east"),
        (content: "EN", side: "north"),
        (content: "CLK", side: "south"),
    ))
})

// Test pin decorations and named anchors
#test({
    import lib: *
    block("b1", (0, 0), text: [Counter], min-width: 3.2, pins: (
        (name: "d", content: "D", side: "west"),
        (name: "rst", content: "RST", side: "west", invert: true),
        (name: "q", content: "Q", side: "east"),
        (name: "clk", content: "CLK", side: "south", clock: true),
    ))
    wire("b1.d", (rel: (-0.6, 0)), bits: 4)
    wire("b1.rst", (rel: (-0.6, 0)))
    wire("b1.q", (rel: (0.6, 0)), bits: 4)
    wire("b1.clk", (rel: (0, -0.6)))
})

// Test sizing and styling
#test({
    import lib: *
    block("b1", (0, 0), pins: ((content: "A", side: "north"), (content: "B", side: "north"), (content: "C", side: "north")))
    block("b2", (4, 0), text: [X], stroke: red, fill: blue.lighten(80%), min-width: 1.4, min-height: 1)
})
