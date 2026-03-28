#import "./dependencies.typ": cetz
#import "./styles.typ": default

#let circuit(fallback, ..params) = {
    cetz.canvas(..params, {
        // Init style directory
        cetz.draw.set-ctx(ctx => {
            ctx.insert("zap", ("style": default))
            return ctx
        })
        fallback
    })
}

