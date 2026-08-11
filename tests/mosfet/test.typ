#import "../utils.typ": test
#import "../../src/lib.typ"

// Test symbols
#test({
    import lib: *
    nmos("T1", (0, 0))
    pmos("T2", (2, 0))
    nmosd("T3", (0, -2))
    pmosd("T4", (2, -2))
})

// Test envelope
#test({
    import lib: *
    nmos("T1", (0, 0), envelope: true)
    pmos("T2", (3, 0), envelope: true)
})

// Test terminals
#test({
    import lib: *
    nmos("T1", (0, 0))
    wire("T1.d", (rel: (0, 0.5)))
    wire("T1.s", (rel: (0, -0.5)))
    wire("T1.g", (rel: (-0.5, 0)))
})

// Test external bulk
#test({
    import lib: *
    nmos("T1", (0, 0), bulk: "external")
    pmos("T2", (2.5, 0), bulk: "external")
    wire("T2.b", (rel: (0.5, 0)))
})

// Test without bulk
#test({
    import lib: *
    nmos("T1", (0, 0), bulk: none)
    pmos("T2", (2, 0), bulk: none)
})

// Test channel alias
#test({
    import lib: *
    mosfet("T1", (0, 0), channel: "p")
    mosfet("T2", (2, 0), type: "p")
})

// Test label and styling
#test({
    import lib: *
    nmos("T1", (0, 0), label: "T1")
    pmos("T2", (2, 0), stroke: red)
})
