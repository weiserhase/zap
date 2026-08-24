#import "/src/lib.typ"

#set page(width: auto, height: auto, margin: 14pt, fill: white)
#set text(size: 9pt)

#let x = (regs: 0.6, ports: 2.9, mux-a: 5.6, mux-b: 7, alu: 9.6, tap: 12.2, out: 13, ctrl: -6.5, back: -5)
#let y = (a: 2, b: 0, reg-a: 2.4, reg-b: 0.4, alu: 1, ctrl: -2.7, back: 3.9)

#lib.circuit({
    import lib: *

    register(
        "acc",
        (x.regs, y.reg-a),
        bits: 4,
        min-width: 4.6,
        label: [Accumulator],
        pins: (
            (name: "d", content: "D", side: "west"),
            (name: "clk", content: "CLK", side: "west", clock: true),
            (name: "q", content: "Q", side: "east"),
        ),
    )
    wstub("acc.clk", label: [clk], length: 0.5)

    mux("ma", (x.mux-a, y.a))
    wire("acc.q", "ma.in0", bits: 4)
    wstub("ma.in1", label: [const 0])

    alu("u1", (x.alu, y.alu), width: 1.9, height: 4)
    wire("ma.out", "u1.a", bits: 4)

    splitter(
        "s1",
        (x.ctrl, y.ctrl),
        ways: 3,
        width: 3.2,
        spacing: 0.8,
        labels: ([[5:2] data in], [[1] sel#sub[a]], [[0] op]),
    )
    wire(name: "wi", "s1.in", (rel: (-0.8, 0)), bits: 6)
    wstub("wi.out", label: [instr#sub[5:0]])
    wire("s1.out0", ((x.ports, 0), "|-", "s1.out0"), (x.ports, y.b), "u1.b", bits: 4)
    wire("s1.out1", ("ma.sel", "|-", "s1.out1"), "ma.sel")
    wire("s1.out2", ("u1.op", "|-", "s1.out2"), "u1.op")

    wire(name: "wo", "u1.y", (x.out, y.alu), bits: 4)
    estub("wo.out", label: [out])
    node("tap", (x.tap, y.alu))
    wire("tap", (x.tap, y.back), (x.back, y.back), ((x.back, 0), "|-", "acc.d"), "acc.d", bits: 4)
})
