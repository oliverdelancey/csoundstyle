import echocolors

type
  CsTag = ref object of RootObj
    name: string
    startTag: string
    endTag: string
    startLoc: int
    endLoc: int

proc initCsTag*(tagName: string): CsTag = 
  let startTag = "<" & tagName & ">"
  let endTag = "</" & tagName & ">"
  return CsTag(name: tagName, startTag: startTag, endTag: endTag, startLoc: 0, endLoc: 0)

proc checkTag*(tag: var CsTag, s: string, l: int): bool =
  if s == tag.startTag:
    tag.startLoc = l
    return true
  elif s == tag.endTag:
    tag.endLoc = l
    return true
  else:
    return false

proc verifyTag*(tag: CsTag) =
  if tag.startLoc == 0:
    # echo "Error: could not find start of tag ", tag.name
    redEcho("Error: could not find start of tag " & tag.name)
    quit(1)
  elif tag.endLoc == 0:
    # echo "Error: could not find end of tag ", tag.name
    redEcho("Error: could not find end of tag " & tag.name)
    quit(1)
  else:
    grnEcho("Tag " & tag.name & " OK")