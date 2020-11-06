import colorize

proc colorEcho(msg: string, darkK, lightK: proc, light = false) =
  if light:
    echo msg.lightK
  else:
    echo msg.darkK

proc redEcho*(msg: string, light = false) =
  colorEcho(msg, fgRed, fgLightRed, light)

proc yelEcho*(msg: string, light = false) =
  colorEcho(msg, fgYellow, fgLightYellow, light)

proc grnEcho*(msg: string, light = false) =
  colorEcho(msg, fgGreen, fgLightGreen, light)
