#import "../utils.typ": test
#import "../../src/lib.typ"

// Test symbol
#test({
    import lib: *
    alu("u1", (0, 0))
    alu("u2", (3, 0), text: $+$)
    alu("u3", (6, 0), text: none)
})

// Test anchors
#test({
    import lib: *
    alu("u1", (0, 0))
    wire("u1.a", (rel: (-0.8, 0)), bits: 3)
    wire("u1.b", (rel: (-0.8, 0)), bits: 3)
    wire("u1.y", (rel: (0.8, 0)), bits: 3)
    wire("u1.op", (rel: (0, -0.8)))
    wire("u1.f", (rel: (0, 0.8)))
})

// Test styling
#test({
    import lib: *
    alu("u1", (0, 0), stroke: red)
    alu("u2", (3, 0), fill: blue.lighten(80%), label: "U2")
})
