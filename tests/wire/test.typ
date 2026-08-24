#import "../utils.typ": test
#import "../../src/lib.typ"

// Test symbols
#test({
    import lib: *
    swire((0, 0), (3, 2), axis: "y")
    zwire((3, 2), (5, 0), axis: "x", ratio: 2)
    wire((5, 0), (0, 0))
})

// Test decorations
#test({
    import lib: *
    wire((0, 0), (3, 2), i: (content: $i_1$, anchor: "south-east"))
})

// Test global styling
#test({
    import lib: *
    set-style(wire: (stroke: 1pt + red))
    wire((0, 0), (3, 2), i: (content: $i_1$))
    resistor("r1", (0, 0), (4, 0))
})

// Test bus width
#test({
    import lib: *
    wire((0, 0), (3, 0), bits: 3)
    wire((0, -1), (3, -1), bits: 16)
    wire((4, 0.5), (4, -1.5), bits: 8)
    zwire((5, 0.5), (8, -1.5), bits: 4)
})

// Test bus width styling
#test({
    import lib: *
    set-style(wire: (bits: (angle: 90deg, distance: 0.3, content: [n])))
    wire((0, 0), (3, 0), bits: 4)
})
