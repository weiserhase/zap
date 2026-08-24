#import "/src/lib.typ"

#set page(width: auto, height: auto, margin: 14pt, fill: white)
#set text(size: 9pt)

#lib.circuit({
    import lib: *

    let cell(name, position, index) = block(
        name,
        position,
        text: [FA#sub[#index]],
        pins: (
            (name: "a", content: [A], side: "north"),
            (name: "b", content: [B], side: "north"),
            (name: "cin", content: [C#sub[in]], side: "west"),
            (name: "cout", content: [C#sub[out]], side: "east"),
            (name: "s", content: [S], side: "south"),
        ),
    )

    cell("fa0", (0, 0), 0)
    cell("fa1", (4, 0), 1)

    wire(name: "wa0", "fa0.a", (rel: (0, 0.6)))
    nstub("wa0.out", label: [A#sub[0]])
    wire(name: "wb0", "fa0.b", (rel: (0, 0.6)))
    nstub("wb0.out", label: [B#sub[0]])
    wire(name: "wa1", "fa1.a", (rel: (0, 0.6)))
    nstub("wa1.out", label: [A#sub[1]])
    wire(name: "wb1", "fa1.b", (rel: (0, 0.6)))
    nstub("wb1.out", label: [B#sub[1]])

    wstub("fa0.cin", label: [C#sub[in]])
    wire("fa0.cout", "fa1.cin")
    draw.content((2, 0.16), text(0.8em)[C#sub[1]], anchor: "south")
    estub("fa1.cout", label: [C#sub[out]])

    merger("sm", (2, -2.4), ways: 2, labels: none)
    wire("fa1.s", (4, -2.025), "sm.in0")
    wire("fa0.s", (0, -2.775), "sm.in1")
    wire(name: "wsum", "sm.out", (rel: (0.9, 0)), bits: 2)
    estub("wsum.out", label: [S#sub[1:0]])
})
