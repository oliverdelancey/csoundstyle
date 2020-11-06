import colorize

proc colorEcho(msg: string, dark, light: proc, bright = false) =
    if bright:
        echo msg.light
    else:
        echo msg.dark

proc redEcho*(msg: string, bright = false) =
    colorEcho(msg, fgRed, fgLightRed, bright)

proc yelEcho*(msg: string, bright = false) =
    colorEcho(msg, fgYellow, fgLightYellow, bright)

proc grnEcho*(msg: string, bright = false) =
    colorEcho(msg, fgGreen, fgLightGreen, bright)
