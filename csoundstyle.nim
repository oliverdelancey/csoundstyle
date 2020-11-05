import strutils
import tables

import clapfn

type
  CsTag = ref object of RootObj
    name: string
    startTag: string
    endTag: string
    startLoc: int
    endLoc: int

proc initCsTag(tagName: string): CsTag = 
  let startTag = "<" & tagName & ">"
  let endTag = "</" & tagName & ">"
  return CsTag(name: tagName, startTag: startTag, endTag: endTag, startLoc: 0, endLoc: 0)

proc checkTag(tag: var CsTag, s: string, l: int): bool =
  if s == tag.startTag:
    tag.startLoc = l
    return true
  elif s == tag.endTag:
    tag.endLoc = l
    return true
  else:
    return false

proc verifyTag(tag: CsTag) =
  if tag.startLoc == 0:
    echo "Error: could not find start of tag ", tag.name
    quit(1)
  elif tag.endLoc == 0:
    echo "Error: could not find end of tag ", tag.name
    quit(1)
  else:
    echo "Tag ", tag.name, " OK"

# MAIN PROGRAM
var parser = ArgumentParser(programName: "csoundstyle", fullName: "csoundstyle",
                            description: "A Csound source code formatter.", version: "0.1.0")
parser.addRequiredArgument("input.csd", "Input file.")
parser.addStoreArgument("-o", "--out", "output.csd", "", "Specify the output file.")

let args = parser.parse()

let infileName = args["input.csd"]
let outfileName = case args["out"] == ""
  of true: infileName
  else: args["out"]

var formatted = splitLines(readFile(infileName))

# declare Csound XML tags
var synthesizer = initCsTag("CsoundSynthesizer")
var options = initCsTag("CsOptions")
var instruments = initCsTag("CsInstruments")
var score = initCsTag("CsScore")

var lineCount = 1
for line in formatted:
  if checkTag(synthesizer, line, lineCount): continue
  elif checkTag(options, line, lineCount): continue
  elif checkTag(instruments, line, lineCount): continue
  elif checkTag(score, line, lineCount): continue
  lineCount += 1

verifyTag(synthesizer)
verifyTag(options)
verifyTag(instruments)
verifyTag(score)

# writeFile(outfileName, formatted)

