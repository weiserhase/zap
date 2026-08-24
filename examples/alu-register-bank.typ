#import "/src/lib.typ"

#set page(width: auto, height: auto, margin: 14pt, fill: white)
#set text(size: 9pt)

#let x = (regs: 0.6, ports: 2.9, mux-a: 5.6, mux-b: 7, alu: 9.6, tap: 12.2, out: 13, ctrl: -6.5, back: -5)
#let y = (a: 2, b: 0, reg-a: 2.4, reg-b: 0.4, alu: 1, ctrl: -2.7, back: 3.9)

#lib.circuit({
    import lib: *

    register-bank(
        "rf",
        (x.regs, (y.reg-a + y.reg-b) / 2),
        rows: 4,
        bits: 4,
        min-width: 4.6,
        spacing: 2,
        label: (content: [Register bank], anchor: (0, 1.75)),
        pins: (
            (name: "din", content: [D#sub[in]], side: "west"),
            (name: "clk", content: "CLK", side: "west", clock: true),
            (name: "a", content: "A", side: "east"),
            (name: "b", content: "B", side: "east"),
            (name: "ra", content: [R#sub[a]], side: "south"),
            (name: "rb", content: [R#sub[b]], side: "south"),
            (name: "wsel", content: [W#sub[sel]], side: "south"),
            (name: "we", content: "WE", side: "south"),
        ),
    )
    wstub("rf.clk", label: [clk], length: 0.5)

    mux("ma", (x.mux-a, y.a))
    wire("rf.a", "ma.in0", bits: 4)
    wstub("ma.in1", label: [const 0])

    mux("mb", (x.mux-b, y.b))
    wire("rf.b", "mb.in0", bits: 4)

    alu("u1", (x.alu, y.alu), width: 1.9, height: 4)
    wire("ma.out", "u1.a", bits: 4)
    wire("mb.out", "u1.b", bits: 4)

    splitter(
        "s1",
        (x.ctrl, y.ctrl),
        ways: 8,
        width: 3.2,
        spacing: 0.55,
        labels: (
            [[12:11] R#sub[a]],
            [[10:9] R#sub[b]],
            [[8] W#sub[sel]],
            [[7] WE],
            [[6] sel#sub[a]],
            [[5:2] data in],
            [[1] sel#sub[b]],
            [[0] op],
        ),
    )
    wire(name: "wi", "s1.in", (rel: (-0.8, 0)), bits: 13)
    wstub("wi.out", label: [instr#sub[12:0]])
    wire("s1.out0", ("rf.ra", "|-", "s1.out0"), "rf.ra", bits: 2)
    wire("s1.out1", ("rf.rb", "|-", "s1.out1"), "rf.rb", bits: 2)
    wire("s1.out2", ("rf.wsel", "|-", "s1.out2"), "rf.wsel")
    wire("s1.out3", ("rf.we", "|-", "s1.out3"), "rf.we")
    wire("s1.out4", ("ma.sel", "|-", "s1.out4"), "ma.sel")
    wire(
        "s1.out5",
        ((rel: (-0.5, 0), to: "mb.in1"), "|-", "s1.out5"),
        (rel: (-0.5, 0), to: "mb.in1"),
        "mb.in1",
        bits: 4,
    )
    wire("s1.out6", ("mb.sel", "|-", "s1.out6"), "mb.sel")
    wire("s1.out7", ("u1.op", "|-", "s1.out7"), "u1.op")

    wire(name: "wo", "u1.y", (x.out, y.alu), bits: 4)
    estub("wo.out", label: [out])
    node("tap", (x.tap, y.alu))
    wire("tap", (x.tap, y.back), (x.back, y.back), ((x.back, 0), "|-", "rf.din"), "rf.din", bits: 4)
})
