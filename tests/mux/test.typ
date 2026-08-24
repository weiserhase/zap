#import "../utils.typ": test
#import "../../src/lib.typ"

// Test symbols
#test({
    import lib: *
    mux("m1", (0, 0))
    mux("m2", (2, 0), ports: 4)
    demux("m3", (4, 0))
    demux("m4", (6, 0), ports: 4)
})

// Test labels
#test({
    import lib: *
    mux("m1", (0, 0), labels: none)
    mux("m2", (2, 0), ports: 3, labels: ([A], [B], [C]))
})

// Test anchors
#test({
    import lib: *
    mux("m1", (0, 0), ports: 4)
    for port in range(4) {
        wire("m1.in" + str(port), (rel: (-0.6, 0)))
    }
    wire("m1.out", (rel: (0.6, 0)), bits: 3)
    wire("m1.sel", (rel: (0, -0.6)))

    demux("m2", (4, 0), ports: 4)
    wire("m2.in", (rel: (-0.6, 0)))
    for port in range(4) {
        wire("m2.out" + str(port), (rel: (0.6, 0)))
    }
    wire("m2.sel", (rel: (0, -0.6)))
})

// Test styling
#test({
    import lib: *
    mux("m1", (0, 0), stroke: red)
    demux("m2", (2, 0), fill: blue.lighten(80%), label: "M2")
})
