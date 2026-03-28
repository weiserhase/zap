#import "/tests/utils.typ": test
#import "/src/lib.typ"

#test({
    import lib: *

    // Check even vertical distribution and centered output with multiple inputs.
    land("g1", (0, 0), inputs: 5)
    wstub("g1.in1", label: "A")
    wstub("g1.in2", label: "B")
    wstub("g1.in3", label: "C")
    wstub("g1.in4", label: "D")
    wstub("g1.in5", label: "E")
    estub("g1.out", label: "AND")
})

#test({
    import lib: *

    // Check multi-input behavior also works for inverted outputs.
    lnor("g2", (0, 0), inputs: 5)
    wstub("g2.in1", label: "A")
    wstub("g2.in2", label: "B")
    wstub("g2.in3", label: "C")
    wstub("g2.in4", label: "D")
    wstub("g2.in5", label: "E")
    estub("g2.out", label: "NOR")
})

#test({
    import lib: *

    // Check lower input count layout for a standard gate.
    land("g3", (0, 0), inputs: 2)
    wstub("g3.in1", label: "A")
    wstub("g3.in2", label: "B")
    estub("g3.out", label: "AND")
})

#test({
    import lib: *

    // Check minimum supported input count (single-input NOT gate).
    lnot("g4", (0, 0))
    wstub("g4.in1", label: "A")
    estub("g4.out", label: "NOT")
})
