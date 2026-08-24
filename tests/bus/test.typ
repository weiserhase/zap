#import "../utils.typ": test
#import "../../src/lib.typ"

// Test symbols
#test({
    import lib: *
    splitter("s1", (0, 0))
    splitter("s2", (2, 0), ways: 4)
    merger("m1", (4, 0))
    merger("m2", (6, 0), ways: 4)
})

// Test labels
#test({
    import lib: *
    splitter("s1", (0, 0), labels: ("[3:2]", "[1:0]"))
    merger("m1", (3.5, 0), ways: 3, labels: auto)
})

// Test several ranges
#test({
    import lib: *
    let fields = (("[7:6]", "op"), ("[5:4]", "rs"), ("[3:2]", "rd"), ("[1:0]", "imm"))

    splitter("s1", (0, 0), ways: fields.len(), labels: fields.map(field => field.first()))
    wire(name: "instr", "s1.in", (rel: (-1.2, 0)), bits: 8)
    wstub("instr.out", label: [instr])

    for (index, field) in fields.enumerate() {
        wire(name: "f" + str(index), "s1.out" + str(index), (rel: (1.2, 0)), bits: 2)
        estub("f" + str(index) + ".out", label: field.last())
    }
})

// Test anchors
#test({
    import lib: *
    splitter("s1", (0, 0), ways: 3)
    wire("s1.in", (rel: (-0.8, 0)), bits: 6)
    for way in range(3) {
        wire("s1.out" + str(way), (rel: (0.8, 0)), bits: 2)
    }
    merger("m1", (4, 0), ways: 3)
    for way in range(3) {
        wire("m1.in" + str(way), (rel: (-0.8, 0)), bits: 2)
    }
    wire("m1.out", (rel: (0.8, 0)), bits: 6)
})

// Test styling
#test({
    import lib: *
    splitter("s1", (0, 0), stroke: red)
})
