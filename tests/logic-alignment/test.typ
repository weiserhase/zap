#import "/tests/utils.typ": test
#import "/src/lib.typ"
#import "/src/lib.typ": cetz, set-style
#import "test-logic.typ": test-logic-gate

#test({
    let combinations = (
        (north: false, west: false, east: false, south: false),
        (north: true, west: false, east: false, south: false),
        (north: false, west: true, east: false, south: false),
        (north: true, west: true, east: false, south: false),
        (north: false, west: false, east: true, south: false),
        (north: true, west: false, east: true, south: false),
        (north: false, west: true, east: true, south: false),
        (north: true, west: true, east: true, south: false),
        (north: false, west: false, east: false, south: true),
        (north: true, west: false, east: false, south: true),
        (north: false, west: true, east: false, south: true),
        (north: true, west: true, east: false, south: true),
        (north: false, west: false, east: true, south: true),
        (north: true, west: false, east: true, south: true),
        (north: false, west: true, east: true, south: true),
        (north: true, west: true, east: true, south: true),
    )

    let draw-grid(name, origin, top-left) = {
        test-logic-gate(name + "-a1", origin, ..top-left)
        test-logic-gate(name + "-a2", (rel: (0, -2), to: name + "-a1"))
        test-logic-gate(name + "-b1", (rel: (3, 0), to: name + "-a1"))
        test-logic-gate(name + "-b2", (rel: (0, -2), to: name + "-b1"))

        let eps = 0.001
        cetz.draw.get-ctx(ctx => {
            let (ctx, a1) = cetz.coordinate.resolve(ctx, name + "-a1")
            let (ctx, a2) = cetz.coordinate.resolve(ctx, name + "-a2")
            let (ctx, b1) = cetz.coordinate.resolve(ctx, name + "-b1")
            let (ctx, b2) = cetz.coordinate.resolve(ctx, name + "-b2")

            assert(calc.abs(a1.at(0) - a2.at(0)) < eps, message: name + ": left column x-shift")
            assert(calc.abs(b1.at(0) - b2.at(0)) < eps, message: name + ": right column x-shift")
            assert(calc.abs(a1.at(1) - b1.at(1)) < eps, message: name + ": top row y-shift")
            assert(calc.abs(a2.at(1) - b2.at(1)) < eps, message: name + ": bottom row y-shift")
        })

        cetz.draw.line(name + "-a1.north-west", name + "-b1.north-east", stroke: gray)
        cetz.draw.line(name + "-b1.north-east", name + "-b2.south-east", stroke: gray)
        cetz.draw.line(name + "-b2.south-east", name + "-a2.south-west", stroke: gray)
        cetz.draw.line(name + "-a2.south-west", name + "-a1.north-west", stroke: gray)

        cetz.draw.line((rel: (0, 1.2), to: name + "-a1"), (rel: (0, -1.2), to: name + "-a2"), stroke: gray)
        cetz.draw.line((rel: (0, 1.2), to: name + "-b1"), (rel: (0, -1.2), to: name + "-b2"), stroke: gray)
        cetz.draw.line((rel: (-1.6, 0), to: name + "-a1"), (rel: (1.6, 0), to: name + "-b1"), stroke: gray)
        cetz.draw.line((rel: (-1.6, 0), to: name + "-a2"), (rel: (1.6, 0), to: name + "-b2"), stroke: gray)
    }

    for idx in range(0, combinations.len()) {
        let col = calc.rem(idx, 4)
        let row = calc.floor(idx / 4)
        let origin = (col * 8, -row * 6)
        draw-grid("combo-" + str(idx), origin, combinations.at(idx))
    }
})

#test({
    let combinations = (
        (north: false, west: false, east: false, south: false),
        (north: true, west: false, east: false, south: false),
        (north: false, west: true, east: false, south: false),
        (north: true, west: true, east: false, south: false),
        (north: false, west: false, east: true, south: false),
        (north: true, west: false, east: true, south: false),
        (north: false, west: true, east: true, south: false),
        (north: true, west: true, east: true, south: false),
        (north: false, west: false, east: false, south: true),
        (north: true, west: false, east: false, south: true),
        (north: false, west: true, east: false, south: true),
        (north: true, west: true, east: false, south: true),
        (north: false, west: false, east: true, south: true),
        (north: true, west: false, east: true, south: true),
        (north: false, west: true, east: true, south: true),
        (north: true, west: true, east: true, south: true),
    )

    let draw-small-grid(name, origin, top-left) = {
        let opts = (inset: 0.24)

        test-logic-gate(name + "-a1", origin, ..opts, ..top-left)
        test-logic-gate(name + "-a2", (rel: (0, -2), to: name + "-a1"), ..opts)
        test-logic-gate(name + "-b1", (rel: (3, 0), to: name + "-a1"), ..opts)
        test-logic-gate(name + "-b2", (rel: (0, -2), to: name + "-b1"), ..opts)

        let eps = 0.001
        cetz.draw.get-ctx(ctx => {
            let (ctx, a1) = cetz.coordinate.resolve(ctx, name + "-a1")
            let (ctx, a2) = cetz.coordinate.resolve(ctx, name + "-a2")
            let (ctx, b1) = cetz.coordinate.resolve(ctx, name + "-b1")
            let (ctx, b2) = cetz.coordinate.resolve(ctx, name + "-b2")

            assert(calc.abs(a1.at(0) - a2.at(0)) < eps, message: name + ": left column x-shift")
            assert(calc.abs(b1.at(0) - b2.at(0)) < eps, message: name + ": right column x-shift")
            assert(calc.abs(a1.at(1) - b1.at(1)) < eps, message: name + ": top row y-shift")
            assert(calc.abs(a2.at(1) - b2.at(1)) < eps, message: name + ": bottom row y-shift")
        })

        cetz.draw.line(name + "-a1.north-west", name + "-b1.north-east", stroke: gray)
        cetz.draw.line(name + "-b1.north-east", name + "-b2.south-east", stroke: gray)
        cetz.draw.line(name + "-b2.south-east", name + "-a2.south-west", stroke: gray)
        cetz.draw.line(name + "-a2.south-west", name + "-a1.north-west", stroke: gray)

        cetz.draw.line((rel: (0, 1.2), to: name + "-a1"), (rel: (0, -1.2), to: name + "-a2"), stroke: gray)
        cetz.draw.line((rel: (0, 1.2), to: name + "-b1"), (rel: (0, -1.2), to: name + "-b2"), stroke: gray)
        cetz.draw.line((rel: (-1.6, 0), to: name + "-a1"), (rel: (1.6, 0), to: name + "-b1"), stroke: gray)
        cetz.draw.line((rel: (-1.6, 0), to: name + "-a2"), (rel: (1.6, 0), to: name + "-b2"), stroke: gray)
    }

    for idx in range(0, combinations.len()) {
        let col = calc.rem(idx, 4)
        let row = calc.floor(idx / 4)
        let origin = (col * 8, -row * 6)
        draw-small-grid("small-combo-" + str(idx), origin, combinations.at(idx))
    }
})

#test({
    import lib: *

    land("and-a", (0, 0))
    land("and-b", (rel: (0, -2), to: "and-a"))

    land("nand-a", (3, 0), invert: true)
    land("nand-b", (rel: (0, -2), to: "nand-a"), invert: true)

    land("inv-a", (6, 0), invert: true)
    land("inv-b", (rel: (0, -2), to: "inv-a"), invert: true)

    lor("or-a", (0, -5))
    lor("or-b", (rel: (0, -2), to: "or-a"))

    lnor("nor-a", (3, -5))
    lnor("nor-b", (rel: (0, -2), to: "nor-a"))

    lxor("xor-a", (6, -5))
    lxor("xor-b", (rel: (0, -2), to: "xor-a"))

    lxnor("xnor-a", (9, -5))
    lxnor("xnor-b", (rel: (0, -2), to: "xnor-a"))

    let eps = 0.001
    let assert-aligned(prefix) = {
        cetz.draw.get-ctx(ctx => {
            let (ctx, top) = cetz.coordinate.resolve(ctx, prefix + "-a")
            let (ctx, bottom) = cetz.coordinate.resolve(ctx, prefix + "-b")
            assert(calc.abs(top.at(0) - bottom.at(0)) < eps, message: prefix + ": relative placement x-shift")
        })
    }

    assert-aligned("and")
    assert-aligned("nand")
    assert-aligned("inv")
    assert-aligned("or")
    assert-aligned("nor")
    assert-aligned("xor")
    assert-aligned("xnor")

    draw.line((0, 1), (0, -9), stroke: gray)
    draw.line((3, 1), (3, -9), stroke: gray)
    draw.line((6, 1), (6, -9), stroke: gray)
    draw.line((9, 1), (9, -9), stroke: gray)
})

#test({
    import lib: *

    set-style(logic: (stroke: blue, fill: white))

    let eps = 0.001
    let draw-grid(name, origin, a1-inv, b1-inv, a2-inv, b2-inv) = {
        land(name + "-a1", origin, invert: a1-inv)
        land(name + "-a2", (rel: (0, -2), to: name + "-a1"), invert: a2-inv)
        land(name + "-b1", (rel: (3, 0), to: name + "-a1"), invert: b1-inv)
        land(name + "-b2", (rel: (0, -2), to: name + "-b1"), invert: b2-inv)

        cetz.draw.get-ctx(ctx => {
            let (ctx, a1) = cetz.coordinate.resolve(ctx, name + "-a1")
            let (ctx, a2) = cetz.coordinate.resolve(ctx, name + "-a2")
            let (ctx, b1) = cetz.coordinate.resolve(ctx, name + "-b1")
            let (ctx, b2) = cetz.coordinate.resolve(ctx, name + "-b2")

            assert(calc.abs(a1.at(0) - a2.at(0)) < eps, message: name + ": left column x-shift")
            assert(calc.abs(b1.at(0) - b2.at(0)) < eps, message: name + ": right column x-shift")
            assert(calc.abs(a1.at(1) - b1.at(1)) < eps, message: name + ": top row y-shift")
            assert(calc.abs(a2.at(1) - b2.at(1)) < eps, message: name + ": bottom row y-shift")
        })

        draw.line(name + "-a1.north-west", name + "-b1.north-east", stroke: gray)
        draw.line(name + "-b1.north-east", name + "-b2.south-east", stroke: gray)
        draw.line(name + "-b2.south-east", name + "-a2.south-west", stroke: gray)
        draw.line(name + "-a2.south-west", name + "-a1.north-west", stroke: gray)

        draw.line((rel: (0, 1.2), to: name + "-a1"), (rel: (0, -1.2), to: name + "-a2"), stroke: gray)
        draw.line((rel: (0, 1.2), to: name + "-b1"), (rel: (0, -1.2), to: name + "-b2"), stroke: gray)
        draw.line((rel: (-1.6, 0), to: name + "-a1"), (rel: (1.6, 0), to: name + "-b1"), stroke: gray)
        draw.line((rel: (-1.6, 0), to: name + "-a2"), (rel: (1.6, 0), to: name + "-b2"), stroke: gray)
    }

    for idx in range(0, 16) {
        let col = calc.rem(idx, 4)
        let row = calc.floor(idx / 4)
        let origin = (col * 8, -row * 6)

        let a1-inv = calc.rem(idx, 2) == 1
        let b1-inv = calc.rem(calc.floor(idx / 2), 2) == 1
        let a2-inv = calc.rem(calc.floor(idx / 4), 2) == 1
        let b2-inv = calc.rem(calc.floor(idx / 8), 2) == 1

        draw-grid("combo-" + str(idx), origin, a1-inv, b1-inv, a2-inv, b2-inv)
    }
})

#test({
    import lib: *

    set-style(logic: (stroke: black, fill: white))

    let gates = (
        (name: "and", fn: land),
        (name: "nand", fn: lnand),
        (name: "or", fn: lor),
        (name: "nor", fn: lnor),
        (name: "xor", fn: lxor),
        (name: "xnor", fn: lxnor),
        (name: "not", fn: lnot),
    )

    let eps = 0.001
    let draw-gate-grid(gate-name, gate-fn, origin) = {
        gate-fn(gate-name + "-a1", origin)
        gate-fn(gate-name + "-a2", (rel: (0, -2), to: gate-name + "-a1"))
        gate-fn(gate-name + "-b1", (rel: (3, 0), to: gate-name + "-a1"))
        gate-fn(gate-name + "-b2", (rel: (0, -2), to: gate-name + "-b1"))

        cetz.draw.get-ctx(ctx => {
            let (ctx, a1) = cetz.coordinate.resolve(ctx, gate-name + "-a1")
            let (ctx, a2) = cetz.coordinate.resolve(ctx, gate-name + "-a2")
            let (ctx, b1) = cetz.coordinate.resolve(ctx, gate-name + "-b1")
            let (ctx, b2) = cetz.coordinate.resolve(ctx, gate-name + "-b2")

            assert(calc.abs(a1.at(0) - a2.at(0)) < eps, message: gate-name + ": left column x-shift")
            assert(calc.abs(b1.at(0) - b2.at(0)) < eps, message: gate-name + ": right column x-shift")
            assert(calc.abs(a1.at(1) - b1.at(1)) < eps, message: gate-name + ": top row y-shift")
            assert(calc.abs(a2.at(1) - b2.at(1)) < eps, message: gate-name + ": bottom row y-shift")
        })

        draw.line(gate-name + "-a1.north-west", gate-name + "-b1.north-east", stroke: gray)
        draw.line(gate-name + "-b1.north-east", gate-name + "-b2.south-east", stroke: gray)
        draw.line(gate-name + "-b2.south-east", gate-name + "-a2.south-west", stroke: gray)
        draw.line(gate-name + "-a2.south-west", gate-name + "-a1.north-west", stroke: gray)

        draw.line((rel: (0, 1.2), to: gate-name + "-a1"), (rel: (0, -1.2), to: gate-name + "-a2"), stroke: gray)
        draw.line((rel: (0, 1.2), to: gate-name + "-b1"), (rel: (0, -1.2), to: gate-name + "-b2"), stroke: gray)
        draw.line((rel: (-1.6, 0), to: gate-name + "-a1"), (rel: (1.6, 0), to: gate-name + "-b1"), stroke: gray)
        draw.line((rel: (-1.6, 0), to: gate-name + "-a2"), (rel: (1.6, 0), to: gate-name + "-b2"), stroke: gray)
    }

    for idx in range(0, gates.len()) {
        let gate = gates.at(idx)
        let col = calc.rem(idx, 4)
        let row = calc.floor(idx / 4)
        let origin = (col * 8, -row * 6)
        draw-gate-grid("gate-" + gate.name, gate.fn, origin)
    }
})
