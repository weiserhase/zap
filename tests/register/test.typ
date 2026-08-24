#import "../utils.typ": test
#import "../../src/lib.typ"

// Test register
#test({
    import lib: *
    register("r1", (0, 0), bits: 7)
    register("r2", (0, -1), bits: 7, values: "1011010")
    register("r3", (0, -2), bits: 4, values: 5)
    register("r4", (0, -3), bits: 4, values: ([a], [b], [c], [d]))
    register("r5", (0, -4), bits: 8, indices: true)
})

// Test register anchors
#test({
    import lib: *
    register("r1", (0, 0), bits: 4, indices: true)
    wire("r1.d", (rel: (-0.6, 0)), bits: 4)
    wire("r1.q", (rel: (0.6, 0)), bits: 4)
    for bit in range(4) {
        wire("r1.bit" + str(bit), (rel: (0, -0.5)))
    }
})

// Test register bank
#test({
    import lib: *
    register-bank("b1", (0, 0), rows: 4, bits: 4)
    register-bank("b2", (3.5, 0), rows: 3, bits: 4, names: none)
    register-bank("b3", (7, 0), rows: 3, bits: 4, names: ([sp], [pc], [sr]), indices: true)
})

// Test elided rows and values
#test({
    import lib: *
    register-bank("b1", (0, 0), rows: 16, bits: 8, values: ("10110011", "00001111"))
    register-bank("b2", (6, 0), rows: 32, bits: 4, max-rows: 3)
})

// Test anchors and styling
#test({
    import lib: *
    register-bank("b1", (0, 0), rows: 8, bits: 4)
    wire("b1.in0", (rel: (-0.6, 0)), bits: 4)
    wire("b1.out7", (rel: (0.6, 0)), bits: 4)
    register("r1", (0, -3), bits: 4, stroke: red, fill: blue.lighten(85%))
})

// Test framed register
#test({
    import lib: *
    register("r1", (0, 0), bits: 7, pins: auto, indices: true)
    wire("r1.d", (rel: (-0.6, 0)), bits: 7)
    wire("r1.q", (rel: (0.6, 0)), bits: 7)
    wire("r1.clk", (rel: (0, -0.6)))

    register("r2", (0, -3), bits: 4, values: "1011", pins: (
        (name: "d", content: "D", side: "west"),
        (name: "q", content: "Q", side: "east"),
        (name: "clk", content: "CLK", side: "south", clock: true),
        (name: "we", content: "WE", side: "south"),
        (name: "rst", content: "RST", side: "north", invert: true),
    ))
    wire("r2.we", (rel: (0, -0.6)))
    wire("r2.rst", (rel: (0, 0.6)))
})

// Test framed register bank
#test({
    import lib: *
    register-bank("b1", (0, 0), rows: 8, bits: 4, indices: true, pins: (
        (name: "din", content: [D#sub[in]], side: "west"),
        (name: "a", content: "A", side: "east"),
        (name: "b", content: "B", side: "east"),
        (name: "clk", content: "CLK", side: "south", clock: true),
        (name: "we", content: "WE", side: "south"),
        (name: "sel", content: [R#sub[w]], side: "north"),
    ))
    wire("b1.din", (rel: (-0.6, 0)), bits: 4)
    wire("b1.a", (rel: (0.6, 0)), bits: 4)
    wire("b1.sel", (rel: (0, 0.6)), bits: 3)

    register-bank("b2", (6, 0), rows: 3, bits: 4, frame: true)
})
