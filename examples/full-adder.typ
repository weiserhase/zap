#import "/src/lib.typ"

#set page(width: auto, height: auto, margin: 14pt, fill: white)
#set text(size: 9pt)

#lib.circuit({
    import lib: *

    lxor("x1", (1, 1.4))
    land("a1", (1, -0.3))

    wire((-0.8, 1.7), "x1.in1")
    wstub((-0.8, 1.7), label: [A])
    node("ta", (0.15, 1.7))
    wire("ta", (0.15, 0), "a1.in1")

    wire((-0.8, 1.1), "x1.in2")
    wstub((-0.8, 1.1), label: [B])
    node("tb", (0.3, 1.1))
    wire("tb", (0.3, -0.6), "a1.in2")

    lxor("x2", (3.2, 1.1))
    land("a2", (3.2, -1.3))

    wire("x1.out", "x2.in1")
    node("ts", (1.9, 1.4))
    wire("ts", (1.9, -1), "a2.in1")

    wire((-0.8, -1.6), "a2.in2")
    wstub((-0.8, -1.6), label: [C#sub[in]])
    node("tc", (2.15, -1.6))
    wire("tc", (2.15, 0.8), "x2.in2")

    lor("o1", (5.2, -0.8))
    zwire("a1.out", "o1.in1")
    zwire("a2.out", "o1.in2")

    wire(name: "ws", "x2.out", (6.3, 1.1))
    estub("ws.out", label: [S])
    wire(name: "wc", "o1.out", (6.3, -0.8))
    estub("wc.out", label: [C#sub[out]])
})
