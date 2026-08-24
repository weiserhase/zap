#import "../utils.typ": test
#import "../../src/lib.typ"

// Test digits
#test({
    import lib: *
    for (index, digit) in ("0", "1", "2", "3", "4", "5", "6", "7").enumerate() {
        seven-segment("d" + str(index), (index * 1.5, 0), digit: digit)
    }
    for (index, digit) in ("8", "9", "A", "B", "C", "D", "E", "F").enumerate() {
        seven-segment("e" + str(index), (index * 1.5, -2.5), digit: digit)
    }
})

// Test segments and decimal point
#test({
    import lib: *
    seven-segment("d1", (0, 0), segments: ("a", "d", "g"))
    seven-segment("d2", (1.6, 0), digit: 8, dot: true)
    seven-segment("d3", (3.2, 0), digit: 8, dot: false)
})

// Test connections
#test({
    import lib: *
    seven-segment("d1", (0, 0), digit: 4, dot: false, pins: "bus")
    wire("d1.in", (rel: (-0.6, 0)))
    seven-segment("d2", (4, 0), digit: 4, pins: "single")
    for port in ("a", "b", "c", "d", "e", "f", "g") {
        wire("d2." + port, (rel: (-0.6, 0)))
    }
})

// Test styling
#test({
    import lib: *
    seven-segment("d1", (0, 0), digit: 6, stroke: red, on: red.lighten(30%))
    seven-segment("d2", (2, 0), digit: 6, off: gray.lighten(60%), frame: true)
})
