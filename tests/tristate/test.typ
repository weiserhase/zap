#import "../utils.typ": test
#import "../../src/lib.typ"

// Test symbols
#test({
    import lib: *
    tristate("t1", (0, 0))
    tristate("t2", (2, 0), invert: true)
    tristate("t3", (4, 0), invert-enable: true)
    tristate("t4", (6, 0), invert: true, invert-enable: true)
})

// Test anchors
#test({
    import lib: *
    tristate("t1", (0, 0), invert: true, invert-enable: true)
    wire("t1.in", (rel: (-0.8, 0)))
    wire("t1.out", (rel: (0.8, 0)))
    wire("t1.en", (rel: (0, 0.8)))
})

// Test styling
#test({
    import lib: *
    tristate("t1", (0, 0), stroke: red, fill: blue.lighten(80%), label: "T1")
})
