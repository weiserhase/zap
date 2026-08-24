#import "/docs/template/zap.typ"
#import "/docs/template/utils.typ": circ, info, template, warning

#set document(title: [Zap – The circuitikz Typst alternative], description: [])

#show: template

= Introduction <introduction>

== About the project <about>

I initiated Zap in 2025 during my microengineering studies at #link("https://epfl.ch/en")[EPFL] (Federal Institute of Technology, Lausanne) in Switzerland 🇨🇭. I aim to leverage my engineering background to create a tool that is both powerful and a pleasure to use.

== Philosophy <philosophy>

Instead of simply porting the popular `circuitikz` library to Typst, this project tries to establish *a new foundation*. Zap is built around two core principles:
1. *Keep functions clean and intuitive*. This ensures the library is easy to use, requiring minimal code while remaining highly customizable. Users can take advantage of Typst's modernity, avoiding the need to input overly complex symbols or lengthy commands.
2. *Always rely on standard-inspired symbols when possible*. This is the most significant departure from `circuitikz`, which prioritized extensive customization. With Zap, you get direct access to symbols inspired by international standards used in industry.

    Purely aesthetic symbol variations are therefore excluded, as this project is focusing on making the standard symbols visually excellent. This ensures your circuits will be understandable by anyone, anywhere. Of course, I know this might be a constraint, so Zap will always give you the freedom to create your own #link("#custom-symbols")[custom symbols].

== Contributors <contributors>

Special thanks to all the #link("https://github.com/l0uisgrange/zap/graphs/contributors")[contributors] who bring amazing features and bug fixes.

#info(
    title: "How to contribute?",
)[Contributions are very welcome, and it's very easy to set up. You can find more information on how to start on the dedicated #link("https://github.com/l0uisgrange/zap?tab=contributing-ov-file#contributions")[contributing guidelines].]

= Getting started <getting-started>

After this quick introduction, let's get started! You can start using Zap simply by adding the following import at the top of your Typst file. It will automatically install the library from Typst Universe.

```typst
#import "@preview/zap:0.5.0"

#zap.circuit({
    import zap: *

    isource("i1", (0, 0), (5, 0))
})
```

= Positioning <positioning>

The most important part of this library is to know how to position your symbols within your circuit, as it can make your experience a lot more pleasant.

You can choose to either attach your symbols to a single node, or place them between two nodes. If you choose the latest option, wires will be automatically placed between the nodes, like below.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // using one node ...
        resistor("r1", (-2, 0))

        // ... or using two nodes
        resistor("r2", (1, 0), (4, 0))
    })
    ```,
)

#warning[Note that *some symbols can only be placed using one node*, like operational amplifiers, grounds and transistors.]

You can also customize the position of the symbol alongside the wire using the `position` parameter like below.


#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        resistor("r1", (0, 0), (3, 0), position: 70%)
    })
    ```,
)

The `position` parameter also accepts a distance, which is always relative to the `in` anchor.

=== Mirroring or flipping <mirroring>

If you would like to display your component upside-down (vertically and/or horizontally), it is possible to mirror it using the `scale` parameter.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        nobutton("b1", (0, 0), (3, 0))
        nobutton("b2", (3, 0), (6, 0), scale: (y: -1))
    })
    ```,
)

=== Named anchors <named-anchors>

Sometimes, you just want to connect one symbol to another without worrying about coordinates or doing mental math. That's where named anchors come in.

The name provided as the first argument acts as an identifier for the symbol. If we draw a `resistor` identified as `r1`, we can attach a voltage source to its `out` anchor like below.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        resistor("r1", (0, 0), (3, 0))
        vsource("v1", "r1.out", (3, 3))
    })
    ```,
)

A list of available named anchors is available on each #link(<resistor>)[symbols]. You can also activate #link(<debug>)[debugging] to display the available anchors directly on your circuit.

=== Nodes <nodes>

You can also use the `node` symbol instead of anchors. They work pretty much the same, but nodes are visible on the circuit.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        node("n1", (0, 0), label: "MyNode")
    })
    ```,
)

It's also possible to display nodes directly when calling your symbol, and they will represent the `in` and `out` anchors.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        resistor("r1", (1, 0), (4, 0), n: "*-*")
    })
    ```,
)

You can either have circles using `o` or a filled one using `*`. For example, `o-*` will have a circle on the `in` anchor and a filled circle on the `out` anchor.

== Coordinates <coordinates>

Coordinates are fully managed by CeTZ, and you'll find a very extensive list of features on their #link("https://cetz-package.github.io/docs/basics/coordinate-systems")[online documentation], like relative, perpendicular and polar coordinates. Let's just have a quick look at the main features you'll use in your circuits.

=== Perpendicular <perpendicular-coordinates>

You can easily define a new coordinate with the perpendicular position between 2 other coordinates.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        node("n0", (0, 0), label: "O")
        node("n1", (3, -1), label: "A")

        // using either (A, "-|", B) or (A, "|-", B) is possible
        node("n2", ((0, 0), "-|", "n1"), label: "P")
    })
    ```,
)

=== Relative coordinates <relative-coordinates>

You can also define the new coordinate using a previously defined anchor.

In the example below, we want to point `r2` to the `out` anchor of `r1`, but a little bit on the right.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // relative to the previous coordinate, here (1, 0)
        resistor("r1", (1, 0), (rel: (3, 0)))

        // relative to a specific coordinate
        resistor("r2", (5, -3), (rel: (1, 0), to: "r1.out"))
    })
    ```,
)

= Labels <labels>

You can name your symbols by giving them a label using the `label` parameter.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        heater("h1", (1, 0), (4, 0), label: $R$)
    })
    ```,
)

Sometimes, the label is not displayed where you want (like in the middle of another symbol). In that case, you can just give a dictionary to customize this behavior.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        heater("h1", (1, 0), (4, 0), label: $R$)
        heater("h2", (5, 0), (8, 0), label: (content: $R$, anchor: "south", distance: 0pt))
    })
    ```,
)

= Decorations <decorations>

You can add labels for current, voltage, or generic flow to your symbols using the `i` (current), `u` (voltage), or `f` (flow) parameters, which accept either a string for a simple label or a dictionary for more detailed customization.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        vsource("v1", (1, 0), (5, 0), u: $u_1$, i: $i_1$)
    })
    ```,
)

== Current <current>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // simple current
        isource("v1", (1, 0), (4, 0), i: $i_1$)

        // custom current (only "content" key is required)
        isource("v1", (5, 0), (8, 0), i: (content: $i_1$, anchor: "west", invert: true, distance: 17pt, label-distance: 15pt))
    })
    ```,
)

== Voltage <voltage>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // simple voltage
        vsource("v1", (1, 0), (4, 0), u: $u_1$)

        // custom voltage (only "content" key is required)
        vsource("v1", (5, 0), (8, 0), u: (content: $u_1$, anchor: "south-west", label-distance: 8pt, distance: 17pt))
    })
    ```,
)

== Flow <flow>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // simple flow
        vsource("v1", (1, 0), (4, 0), f: $f_1$)

        // custom flow (only "content" key is required)
        vsource("v1", (5, 0), (8, 0), f: (content: $f_1$, anchor: "south-west", label-distance: -20pt, distance: 17pt))
    })
    ```,
)

= Annotations <annotations>

As the `circuit` is just a boosted version of CeTZ' `canvas`, you can also directly draw shapes on it.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // classic circuit
        vsource("v1", (1, 0), (1, 3), u: $u_1$)
        resistor("r1", "v1.out", (rel: (3, 0)), i: $i_1$)

        // annotations
        draw.rect((0.7, 2.5), (4, 4), stroke: (dash: "dashed", thickness: .8pt, paint: red), name: "rect")
        draw.content("rect.north", text(fill: red)[This is a rectangle], anchor: "south")
        draw.line((2, 2), (4, 0), mark: (end: ">", fill: purple), stroke: purple + .8pt)
    })
    ```,
)

== Stubs <stubs>

Sometimes, you'll just want to add a small wire with a label to show an entry point. Stubs do just that, in any *vertical or horizontal* direction you want.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        mcu("m1", (0, 0), pins: 10, label: "ESP32", fill: green.lighten(80%), stroke: none)
        wstub("m1.pin2", label: "PORTB2") // or stub(..., dir: "west")
        estub("m1.pin6", label: "PORTC2")
        estub("m1.pin9", label: "PORTD5", length: 0.5)
    })
    ```,
)

To simplify your code, you can use `nstub`, `sstub`, `estub`, and `wstub` for quick directions.

= Styling <styling>

If you want to customize the appearance of a *single symbol* instance, rather than all, simply use the various `params` optional arguments.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        resistor("r1", (0, 0), (3, 0))
        resistor("r2", (3, 0), (6, 0), variant: "ieee", stroke: 1pt + red)
    })
    ```,
)

#info[As the list of available styles for each component is too long, it is only available in the #link("https://github.com/l0uisgrange/zap/blob/main/src/styles.typ")[source code].]

== Global <styling-global>

If you wish to change the default appearance of *all symbols of a specific type* throughout the same circuit, Zap supports the `set-style` method from CeTZ.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        set-style(resistor: (stroke: red, scale: (x: 0.5, y: 1.5)))

        resistor("r1", (0, 0), (3, 0))
        heater("r2", (3, 0), (6, 0))
    })
    ```,
)

== Standards <standards>

As industries have become more interconnected through globalization, numerous standards have emerged. Many of these have since been replaced by a smaller set of conventions that have gained wider global acceptance.

- *IEC 60617* (default) — The leading international standard, widely adopted.
- *IEEE/ANSI 315-1975* — The North-American standard for electrical and electronics symbols.
- *JIS C 0617* — The official Japanese standard, largely harmonized with the international IEC series.
- *GB/T 4728* — The official Chinese national standard, also closely aligned with IEC guidelines.

Zap currently supports either `iec` (default) or `ieee` in the `variant` styling parameter.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        // remember you can use global styling
        // set-style(variant: "ieee")

        resistor("r1", (0, 0), (3, 0))
        resistor("r2", (3, 0), (6, 0), variant: "ieee")
    })
    ```,
)

= Wiring <wiring>

You can choose between squared, zigzag or straight wires using `swire`, `zwire` or `wire`.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        wire((0, 0), (1, 0))
        zwire((2, 0), (4, 2), stroke: blue)
        swire((5, 2), (6, -1), stroke: red)
    })
    ```,
)

== Customization

The position and axis of the wire can also be altered using the `axis` and `ratio` parameters.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        wire((0, 0), (1, 0)) // N/A
        zwire((2, 0), (4, 2), stroke: blue, axis: "y", ratio: 80%)
        swire((5, 2), (6, -1), stroke: red, axis: "y")
    })
    ```,
)

== Buses <buses>

A wire carrying several bits is marked with a slash and the number of bits, using the `bits` parameter.
It works on every wire shape and orientation, the marker following the direction of the wire.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        wire((0, 0), (3, 0), bits: 3)
        wire((4, 1), (4, -1), bits: 8)
        zwire((5, 1), (8, -1), bits: 16)
    })
    ```,
)

The marker is styled through the `bits` key of the `wire` style, whose `length`, `angle`, `distance`,
`position`, `size` and `content` can all be changed. Setting `content` replaces the number, which is
handy for symbolic widths.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        set-style(wire: (bits: (angle: 90deg, content: $n$)))
        wire((0, 0), (3, 0), bits: 4)
    })
    ```,
)

== Anchors

- `in`: the first point
- `out`: the last point
- `p<i>`: an anchor for each given point of the wire (by index i)
- `p<i>-p<i+1>.a`: the first zigzag corner between the points i and i+1 (only for zigzag)
- `p<i>-p<i+1>.b`: the second zigzag corner between the points i and i+1 (only for zigzag)

= Debug <debug>

If you want to know all the anchors available in a symbol, you can either activate the `debug` mode on a single symbol...

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        resistor("r1", (0, 0), (3, 0), debug: true)
    })
    ```,
)

...or on the whole circuit.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit(debug: true, {
        import zap: *

        resistor("r1", (0, 0), (3, 0))
    })
    ```,
)

= Available symbols <symbols>

As there is a lot of symbols available in Zap, they have been grouped by their original version. If you're not finding yours here, and think it should be included in the library, please #link("https://github.com/l0uisgrange/zap/issues/new?template=feature_request.yml")[open an issue].

== Resistor <resistor>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        resistor("r1", (0, 0), (3, 0))
        resistor("r2", (4, 0), (7, 0), variant: "ieee")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // heatable
    `heatable`,
    `false`,
    `heater`,
    html.frame(
        zap.circuit({
            import zap: *

            resistor("r1", (0, 0), (3, 0), heatable: true)
        }),
    ),
    // adjustable
    `adjustable`,
    `false`,
    `potentiometer`,
    html.frame(
        zap.circuit({
            import zap: *

            resistor("r1", (0, 0), (3, 0), adjustable: true)
        }),
    ),
    // variable
    `variable`,
    `false`,
    `rheostat`,
    html.frame(
        zap.circuit({
            import zap: *

            resistor("r1", (0, 0), (3, 0), variable: true)
        }),
    ),
    // sensor
    `sensor`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            resistor("r1", (0, 0), (3, 0), sensor: true)
        }),
    ),
    // preset
    `preset`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            resistor("r1", (0, 0), (3, 0), preset: true)
        }),
    ),
)

== Inductor <inductor>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        inductor("i1", (0, 0), (3, 0))
        inductor("i2", (4, 0), (7, 0), variant: "ieee")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // variable
    `variable`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            inductor("i1", (0, 0), (3, 0), variable: true)
        }),
    ),
    // preset
    `preset`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            inductor("i1", (0, 0), (3, 0), preset: true)
        }),
    ),
    // sensor
    `sensor`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            inductor("i1", (0, 0), (3, 0), sensor: true)
        }),
    ),
)

== Capacitor <capacitor>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        capacitor("c1", (0, 0), (3, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // variable
    `variable`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            capacitor("c1", (0, 0), (3, 0), variable: true)
        }),
    ),
    // preset
    `preset`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            capacitor("c1", (0, 0), (3, 0), preset: true)
        }),
    ),
    // sensor
    `sensor`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            capacitor("c1", (0, 0), (3, 0), sensor: true)
        }),
    ),
    // polarized
    `polarized`,
    `false`,
    `pcapacitor`,
    html.frame(
        zap.circuit({
            import zap: *

            capacitor("c1", (0, 0), (3, 0), polarized: true)
        }),
    ),
)

== Button <button>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        button("b1", (0, 0), (3, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // nc
    `nc`,
    `false`,
    `ncbutton`,
    html.frame(
        zap.circuit({
            import zap: *

            button("b1", (0, 0), (3, 0), nc: true)
        }),
    ),
    // illuminated
    `illuminated`,
    `false`,
    `noibutton`,
    html.frame(
        zap.circuit({
            import zap: *

            button("b1", (0, 0), (3, 0), illuminated: true)
        }),
    ),
    // head
    `head`,
    `"standard"`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            button("b1", (0, 0), (3, 0), head: "mushroom")
        }),
    ),
    // latching
    `latching`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            button("b1", (0, 0), (3, 0), latching: true)
        }),
    ),
)

== Voltage source <vsource>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        vsource("b1", (0, 0), (3, 0))
        vsource("b2", (4, 0), (7, 0), variant: "ieee")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // dependent
    `dependent`,
    `false`,
    `dvsource`,
    html.frame(
        zap.circuit({
            import zap: *

            vsource("b1", (0, 0), (3, 0), dependent: true)
        }),
    ),
    // current
    `current`,
    `"dc"`,
    `acvsource`,
    html.frame(
        zap.circuit({
            import zap: *

            vsource("b1", (0, 0), (3, 0), current: "ac")
        }),
    ),
)

== Current source <isource>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        isource("b1", (0, 0), (3, 0))
        isource("b2", (4, 0), (7, 0), variant: "ieee")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // dependent
    `dependent`,
    `false`,
    `disource`,
    html.frame(
        zap.circuit({
            import zap: *

            isource("b1", (0, 0), (3, 0), dependent: true)
        }),
    ),
)

== Diode <diode>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        diode("b1", (0, 0), (3, 0))
        diode("b2", (4, 0), (7, 0), variant: "ieee")
    })
    ```,
)

==== Types

The `diode` symbol accepts only one parameter, called `type`, and its appearance changes a lot depending on the value.

#table(
    columns: (auto, auto, auto),
    align: left + top,
    table.header([*Value*], [*Alias*], [*Image*]),
    // zener
    `zener`,
    `zener`,
    html.frame(
        zap.circuit({
            import zap: *

            zener("b1", (0, 0), (3, 0))
        }),
    ),
    // tunnel
    `tunnel`,
    `tunnel`,
    html.frame(
        zap.circuit({
            import zap: *

            tunnel("b1", (0, 0), (3, 0))
        }),
    ),
    // schottky
    `schottky`,
    `schottky`,
    html.frame(
        zap.circuit({
            import zap: *

            schottky("b1", (0, 0), (3, 0))
        }),
    ),
    // led
    `emitting`,
    `led`,
    html.frame(
        zap.circuit({
            import zap: *

            led("b1", (0, 0), (3, 0))
        }),
    ),
    // recieving
    `recieving`,
    `photodiode`,
    html.frame(
        zap.circuit({
            import zap: *

            photodiode("b1", (0, 0), (3, 0))
        }),
    ),
)

== Supply <supply>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        wire((0, 0), (10, 0))
        vcc("s1", (0, 0))
        vee("s2", (2, 0))
        earth("s3", (4, 0))
        frame("s4", (6, 0))
        ground("s5", (8, 0))
        rground("s6", (10, 0))
    })
    ```,
)

== Fuse <fuse>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        fuse("f1", (0, 0), (3, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // dependent
    `asymmetric`,
    `false`,
    `afuse`,
    html.frame(
        zap.circuit({
            import zap: *

            fuse("b1", (0, 0), (3, 0), asymmetric: true)
        }),
    ),
)

== Operational amplifier <opamp>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        opamp("o1", (0, 0))
        opamp("o2", (3, 0), variant: "ieee")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // dependent
    `invert`,
    `false`,
    `iopamp`,
    html.frame(
        zap.circuit({
            import zap: *

            opamp("o1", (0, 0), invert: true)
        }),
    ),
)

== Converter <converter>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        adc("c1", (0, 0), (3, 0))
        dac("c2", (4, 0), (7, 0))
    })
    ```,
)

== BJT transistors <bjt>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        bjt("t1", (0, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Alias*], [*Image*]),
    // polarisation
    `polarisation`,
    `"npn"`,
    [`"npn"` / `"pnp"`],
    [`npn` / `pnp`],
    html.frame(
        zap.circuit({
            import zap: *

            bjt("t1", (0, 0), polarisation: "pnp")
        }),
    ),
    // envelope
    `envelope`,
    `false`,
    `bool`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            bjt("t1", (0, 0), envelope: true)
        }),
    ),
)

== MOSFET transistors <mosfet>

The symbol is drawn vertically, with the gate on the left and the drain and source exiting vertically.
For an n-type transistor the drain is on top and the bulk arrow points towards the channel, for a p-type
one the source is on top and the arrow points away from the channel. The bulk is tied to the source by
default, as shown by the junction dot.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        mosfet("t1", (0, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Alias*], [*Image*]),
    // type
    `type`,
    `"n"`,
    [`"n"` / `"p"`],
    [`pmos` / `nmos`],
    html.frame(
        zap.circuit({
            import zap: *

            mosfet("t1", (0, 0), type: "p")
        }),
    ),
    // envelope
    `envelope`,
    `false`,
    [`bool`],
    none,
    html.frame(
        zap.circuit({
            import zap: *

            mosfet("t1", (0, 0), envelope: true)
        }),
    ),
    // mode
    `mode`,
    `"enhancement"`,
    [`"enhancement"` / `"depletion"`],
    [`nmosd` / `pmosd`],
    html.frame(
        zap.circuit({
            import zap: *

            mosfet("t1", (0, 0), mode: "depletion")
        }),
    ),
    // bulk
    `bulk`,
    `"internal"`,
    [`"internal"` / `"external"` / `none`],
    none,
    html.frame(
        zap.circuit({
            import zap: *

            mosfet("t1", (0, 0), bulk: "external")
        }),
    ),
)

With `bulk: "external"`, the body is no longer tied to the source: the lead ends free and you wire it
yourself from the `b` anchor. With `bulk: none`, the body is not drawn at all and the arrow sits on the
source lead instead.

#info(title: "Naming")[The `channel` option is still accepted as an alias of `type`, so `mosfet("t1", (0, 0), channel: "p")` keeps working.]

== Transformer <transformer>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        transformer("t1", (0, 0), (3, 0))
    })
    ```,
)

== Instruments <instruments>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        voltmeter("i1", (0, 0), (3, 0))
        ammeter("i2", (4, 0), (7, 0))
        ohmmeter("i3", (8, 0), (11, 0))
        wattmeter("i4", (12, 0), (15, 0))
    })
    ```,
)

== Switch <switch>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        switch("s1", (0, 0), (3, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // closed
    `closed`,
    `false`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            switch("s1", (0, 0), (3, 0), closed: true)
        }),
    ),
)

== Antenna <antenna>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        wire((0, 0), (2, 0))
        antenna("a1", (1, 0))
    })
    ```,
)

== Circulator <circulator>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        circulator("c1", (0, 0), (3, 0))
    })
    ```,
)

== Logic <logic>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        lnot("l1", (0, 0))
        land("l2", (2, 0))
        lor("l3", (4, 0))
        lxor("l4", (6, 0))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Alias*], [*Image*]),
    // dependent
    `invert`,
    `false`,
    [`lnand` / `lnor` / `lxnor`],
    html.frame(
        zap.circuit({
            import zap: *

            land("b1", (0, 0), invert: true)
        }),
    ),
    // inputs
    `inputs`,
    `2`,
    none,
    html.frame(
        zap.circuit({
            import zap: *

            land("b1", (0, 0), inputs: 5)
        }),
    ),
)

The `invert` option also accepts `"wedge"` as a value for specific use cases. This will display a wedge instead of the classic bubble at the symbol output.

#info(
    title: [Inputs],
)[When setting a number of inputs, each input will be available at `inX` anchor. For example, for three inputs you will have access to `l1.in1`, `l1.in2` and `l1.in3`.]

== Microcontrolling unit <mcu>

#circ(
    ```typst
    #import "./zap.typ"

    #let pins = (
        (content: "VCC", side: "west"),
        (content: "UVCC", side: "west"),
        (content: "AVCC", side: "west"),
        (side: "west"),
        (content: "PD0", side: "west"),
        (content: "PD1", side: "west"),
        // ...
    )

    #zap.circuit({
        import zap: *

        mcu("mcu", (3, 0), pins: pins)
    })
    ```,
)

You have to provide either a number of pins or a complete list of dictionaries. Each pin can have these keys:

- `content` is the label of the pin displayed on the controller. If not provided, the pin is considered as a gap instead of an actual pin.
- `side` represents the position of the pin on the microcontroller, one of `west`, `east`, `north` or `south`. Pins are numbered in the order they are given, whatever their side, and each one gets a `pin<i>` anchor.

== Flipflop <flipflop>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        flipflop("f1", (0, 0))
        dflipflop("f2", (3, 0))
        jkflipflop("f3", (6, 0))
    })
    ```,
)

== Multiplexer <mux>

A multiplexer selects one of its data inputs, a demultiplexer routes its input to one of its outputs.
Data ports are numbered from `0`, so the port number is the value the select input has to take.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        mux("m1", (0, 0))
        demux("m2", (3, 0), ports: 4)
    })
    ```,
)

Splitting a bus into more than two ranges is common when decoding the fields of an instruction word.
Every output carries its own width, so the bus marker on each wire tells how wide the field is.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        let fields = (("[7:6]", "op"), ("[5:4]", "rs"), ("[3:2]", "rd"), ("[1:0]", "imm"))

        splitter("s1", (0, 0), ways: fields.len(), labels: fields.map(field => field.first()))
        wire(name: "instr", "s1.in", (rel: (-1.2, 0)), bits: 8)
        wstub("instr.out", label: [instr])

        for (index, field) in fields.enumerate() {
            wire(name: "f" + str(index), "s1.out" + str(index), (rel: (1.2, 0)), bits: 2)
            estub("f" + str(index) + ".out", label: field.last())
        }
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Alias*], [*Image*]),
    // reverse
    `reverse`,
    `false`,
    [`bool`],
    [`mux` / `demux`],
    html.frame(
        zap.circuit({
            import zap: *

            multiplexer("m1", (0, 0), reverse: true)
        }),
    ),
    // ports
    `ports`,
    `2`,
    [`int`],
    none,
    html.frame(
        zap.circuit({
            import zap: *

            mux("m1", (0, 0), ports: 4)
        }),
    ),
    // labels
    `labels`,
    `auto`,
    [`auto` / `none` / `array`],
    none,
    html.frame(
        zap.circuit({
            import zap: *

            mux("m1", (0, 0), labels: none)
        }),
    ),
)

==== Anchors

- `in<i>` (`out<i>` for a demultiplexer): the data ports, numbered from `0`
- `out` (`in` for a demultiplexer): the single port on the short side
- `sel`: the select input, on the bottom edge

== Arithmetic logic unit <alu>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        alu("u1", (0, 0))
        wire("u1.a", (rel: (-1, 0)), bits: 8)
        wire("u1.b", (rel: (-1, 0)), bits: 8)
        wire("u1.y", (rel: (1, 0)), bits: 8)
        wire("u1.op", (rel: (0, -1)), bits: 2)
        wire("u1.f", (rel: (0, 1)))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Image*]),
    // text
    `text`,
    `[ALU]`,
    [`content` / `none`],
    html.frame(
        zap.circuit({
            import zap: *

            alu("u1", (0, 0), text: $+$)
        }),
    ),
)

==== Anchors

- `a` and `b`: the two operands, on the left side
- `y`: the result, on the right side
- `op`: the function select, on the bottom edge
- `f`: the status flags, on the top edge

== Block <block>

A generic block, with pins placed freely on its four sides. Handy for registers, memories,
decoders or any subsystem drawn as a box.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        block("b1", (0, 0), text: [Register], pins: (
            (name: "d", content: "D", side: "west"),
            (name: "q", content: "Q", side: "east"),
            (name: "clk", content: "CLK", side: "south", clock: true),
            (name: "rst", content: "RST", side: "north", invert: true),
        ))
        wire("b1.d", (rel: (-1, 0)), bits: 8)
        wire("b1.q", (rel: (1, 0)), bits: 8)
        wire("b1.clk", (rel: (0, -1)))
        wire("b1.rst", (rel: (0, 1)))
    })
    ```,
)

Each pin is a dictionary accepting these keys:

- `content` is the label drawn inside the block. A pin without content is a gap.
- `side` is `west`, `east`, `north` or `south`, and defaults to `west`.
- `name` gives the pin an anchor of its own, on top of the positional `pin<i>` one.
- `clock` draws the dynamic input wedge next to the pin.
- `invert` draws an inversion bubble outside of the block, the anchor moving behind it.

The block grows to fit its pins, its title and its labels, never below `min-width` and `min-height`.
Pins are spread by `spacing` on the left and right sides, and by the wider `h-spacing` on the top and
bottom ones, where labels sit side by side.

#info(
    title: [Naming],
)[`block` shadows the built-in Typst function of the same name inside the circuit body. Use `std.block` there if you need the layout function.]

== Register <register>

A register drawn as one cell per storable bit, the most significant bit on the left.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        register("r1", (0, 0), bits: 7, indices: true)
        register("r2", (0, -1.2), bits: 7, values: "1011010")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Image*]),
    // bits
    `bits`,
    `8`,
    [`int`],
    html.frame(
        zap.circuit({
            import zap: *

            register("r1", (0, 0), bits: 4)
        }),
    ),
    // values
    `values`,
    `none`,
    [`none` / `int` / `str` / `array`],
    html.frame(
        zap.circuit({
            import zap: *

            register("r1", (0, 0), bits: 4, values: 5)
        }),
    ),
    // indices
    `indices`,
    `false`,
    [`bool`],
    html.frame(
        zap.circuit({
            import zap: *

            register("r1", (0, 0), bits: 4, indices: true)
        }),
    ),
)

`values` fills the cells: an integer is written in binary, a string gives one cell per character, and
an array one cell per element. Shorter values are padded on the left.

Setting `pins` draws a frame around the cells and puts the connections on it. `auto` gives a data
input, a data output and a clock, and an explicit list configures them, using the same dictionaries
as a #link(<block>)[block]: `content`, `side`, `name`, `clock` and `invert`. `frame` draws the frame
on its own, without any pin. The frame is measured to fit the cells and the labels, and `min-width`
and `min-height` raise that floor, which is handy to give several figures the same footprint.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        register("r1", (0, 0), bits: 7, pins: auto)

        register("r2", (0, -2.5), bits: 4, values: "1011", pins: (
            (name: "d", content: "D", side: "west"),
            (name: "q", content: "Q", side: "east"),
            (name: "clk", content: "CLK", side: "south", clock: true),
            (name: "we", content: "WE", side: "south"),
            (name: "rst", content: "RST", side: "north", invert: true),
        ))
    })
    ```,
)

==== Anchors

- `d` and `q`, on the left and right sides of the cells, when the register has no pins
- `bit<i>` below each cell, counted from `0` for the rightmost one
- one anchor per pin otherwise, named after its `name` key, plus the positional `pin<i>` ones

== Register bank <register-bank>

A bank of `rows` registers of `bits` bits each, numbered in their own column. Banks taller than
`max-rows` keep their first rows and their last one, the others being replaced by an ellipsis.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        register-bank("b1", (0, 0), rows: 4, bits: 4, indices: true)
        register-bank("b2", (4, 0), rows: 16, bits: 8, values: ("10110011", "00001111"))
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Image*]),
    // rows
    `rows`,
    `4`,
    [`int`],
    html.frame(
        zap.circuit({
            import zap: *

            register-bank("b1", (0, 0), rows: 2, bits: 4)
        }),
    ),
    // names
    `names`,
    `auto`,
    [`auto` / `none` / `array`],
    html.frame(
        zap.circuit({
            import zap: *

            register-bank("b1", (0, 0), rows: 3, bits: 4, names: ([sp], [pc], [sr]))
        }),
    ),
    // max-rows
    `max-rows`,
    `5`,
    [`int`],
    html.frame(
        zap.circuit({
            import zap: *

            register-bank("b1", (0, 0), rows: 32, bits: 4, max-rows: 3)
        }),
    ),
)

`bits`, `values` and `indices` behave as on a single register, `values` taking one entry per row.
Setting `names` to `none` drops the numbering column altogether.

The bank takes the same `frame` and `pins` parameters as a single register, which is the usual way of
drawing a register file with its read and write ports.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        register-bank("b1", (0, 0), rows: 8, bits: 4, pins: (
            (name: "din", content: [D#sub[in]], side: "west"),
            (name: "a", content: "A", side: "east"),
            (name: "b", content: "B", side: "east"),
            (name: "clk", content: "CLK", side: "south", clock: true),
            (name: "we", content: "WE", side: "south"),
            (name: "sel", content: [R#sub[w]], side: "north"),
        ))
    })
    ```,
)

==== Anchors

- `in<i>` and `out<i>`, on the left and right sides of the row holding the register `i`, when the
    bank has no frame. Elided rows have no anchors.
- `row<i>` on the left of that same row when the bank is framed, and one anchor per pin, named after
    its `name` key, plus the positional `pin<i>` ones.

== Bus splitter <bus>

Splits a bus into narrower ones, or merges several into a single bus.

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        splitter("s1", (0, 0), labels: ("[7:4]", "[3:0]"))
        wire("s1.in", (rel: (-1, 0)), bits: 8)
        wire("s1.out0", (rel: (1, 0)), bits: 4)
        wire("s1.out1", (rel: (1, 0)), bits: 4)

        merger("m1", (4, 0), ways: 3)
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Alias*], [*Image*]),
    // reverse
    `reverse`,
    `false`,
    [`bool`],
    [`splitter` / `merger`],
    html.frame(
        zap.circuit({
            import zap: *

            bus-splice("s1", (0, 0), reverse: true)
        }),
    ),
    // ways
    `ways`,
    `2`,
    [`int`],
    none,
    html.frame(
        zap.circuit({
            import zap: *

            splitter("s1", (0, 0), ways: 4)
        }),
    ),
    // labels
    `labels`,
    `none`,
    [`none` / `auto` / `array`],
    none,
    html.frame(
        zap.circuit({
            import zap: *

            splitter("s1", (0, 0), labels: auto)
        }),
    ),
)

==== Anchors

- `in` and `out<i>` for a splitter, `in<i>` and `out` for a merger, the numbered ones counted from `0`

== Three-state buffer <tristate>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        tristate("t1", (0, 0))
        tristate("t2", (2, 0), invert: true, invert-enable: true)
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Image*]),
    // invert
    `invert`,
    `false`,
    [`bool`],
    html.frame(
        zap.circuit({
            import zap: *

            tristate("t1", (0, 0), invert: true)
        }),
    ),
    // invert-enable
    `invert-enable`,
    `false`,
    [`bool`],
    html.frame(
        zap.circuit({
            import zap: *

            tristate("t1", (0, 0), invert-enable: true)
        }),
    ),
)

==== Anchors

- `in`, `out` and `en`, the enable sitting on the top edge

== Seven segment display <seven-segment>

#circ(
    ```typst
    #import "./zap.typ"

    #zap.circuit({
        import zap: *

        seven-segment("d1", (0, 0), digit: 4)
        seven-segment("d2", (2, 0), digit: "A", dot: true)
        seven-segment("d3", (4.5, 0), digit: 8, dot: false, pins: "bus")
    })
    ```,
)

==== Options

#table(
    columns: (auto, auto, auto, auto),
    align: left + top,
    table.header([*Name*], [*Default value*], [*Type*], [*Image*]),
    // digit
    `digit`,
    `none`,
    [`int` / `str`],
    html.frame(
        zap.circuit({
            import zap: *

            seven-segment("d1", (0, 0), digit: 2)
        }),
    ),
    // segments
    `segments`,
    `none`,
    [`array`],
    html.frame(
        zap.circuit({
            import zap: *

            seven-segment("d1", (0, 0), segments: ("a", "d", "g"))
        }),
    ),
    // dot
    `dot`,
    `none`,
    [`none` / `bool`],
    html.frame(
        zap.circuit({
            import zap: *

            seven-segment("d1", (0, 0), digit: 3, dot: true)
        }),
    ),
    // pins
    `pins`,
    `none`,
    [`none` / `"bus"` / `"single"`],
    html.frame(
        zap.circuit({
            import zap: *

            seven-segment("d1", (0, 0), digit: 3, pins: "single")
        }),
    ),
)

`digit` lights the segments of `0` to `9` and `A` to `F`, and `segments` lights an explicit list
instead. The decimal point is left out with `dot: none`, drawn unlit with `false` and lit with `true`.

`pins` chooses how the display is wired: `"bus"` draws a single input carrying one bit per segment,
`"single"` one input per segment, and `none` the bare digit. The `a` to `g` and `dp` anchors sit at
the end of the leads when there are pins, and on the segments themselves otherwise.

= Custom Symbols <custom-symbols>
Zap will take care of styles, positioning and anchors for you. All you need to do is draw the symbol. The symbol in the example below is just a rectangle, you can use it as a starting point to draw your own symbols.

#circ(
    ```typst
    #import "./zap.typ" as zap: component, interface, cetz, set-style

    #let custom(name, ..params) = {
        let const = (w:2, h:1)

        let draw(ctx, position, style) = {
            interface(
                (-const.w / 2, -const.h / 2),
                (const.w / 2, const.h / 2),
                io: position.len() < 2
            )

            // draw your symbol here with cetz and zap...

            // pass style to entire scope: `cetz.draw.set-style(..style)`
            // or just a single item:
            cetz.draw.rect("bounds.north-east", "bounds.south-west", ..style)
        }
        component("my-custom-component", name, draw: draw, ..params)
    }

    #zap.circuit({
        custom("c1", (0, 0), (5, 0))
    })
    ```,
)
