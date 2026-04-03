#import "/tests/utils.typ": test
#import "/src/lib.typ"

// Test symbols
#test({
    import lib: *
    dvsource("v3", (0, 0), (2, 0))
    vsource("v1", (0, -1.5), (2, -1.5))
    vsource("v1", (0, -3), (2, -3), variant: "ieee")
    acvsource("v2", (0, -4.5), (2, -4.5), waveform: "sine")
    acvsource("v2", (0, -6), (2, -6), waveform: "rectangular")
    acvsource("v2", (0, -7.5), (2, -7.5), waveform: "sawtooth")
    acvsource("v2", (0, -9), (2, -9), waveform: "triangle")
})

// Test rotation (horizontal ac symbol)
#test({
    import lib: *
    acvsource("v2", (0, 0), (2, 2))
})

// Test decorations
#test({
    import lib: *
    vsource("v1", (0, 0), (2, 0), label: $V_1$, u: $u_1$, i: $i_1$, f: $f_1$)
})

// Test styling
#test({
    import lib: *
    vsource("v1", (0, 0), (2, 0), fill: red.lighten(90%), stroke: 1pt + red)
})
