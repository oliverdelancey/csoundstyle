import strutils
import tables

import clapfn

import cstags


proc collapseSpaces(s: string): string =
  var sstack = 0
  for i in s:
    if i == ' ':
      sstack += 1
    else:
      if sstack > 0:
        result = result & " "
        sstack = 0
      result = result & i


var parser = ArgumentParser(programName: "csoundstyle", fullName: "csoundstyle",
                            description: "A Csound source code formatter.", version: "0.1.0")
parser.addRequiredArgument("input.csd", "Input file.")
parser.addStoreArgument("-o", "--out", "output.csd", "", "Specify the output file.")
parser.addStoreArgument("-m", "--margin", "width", "2", "Specify the margin between columns (default=2)")

let args = parser.parse()

let infileName = args["input.csd"]
let outfileName = case args["out"] == ""
  of true: infileName
  else: args["out"]
let margin = parseInt(args["margin"])

var formatted = splitLines(readFile(infileName))

# declare Csound XML tags
var tags = @[
             initCsTag("CsoundSynthesizer"),
             initCsTag("CsOptions"),
             initCsTag("CsInstruments"),
             initCsTag("CsScore")
            ]

# make sure that all the sections exist
var lineCount = 1
for line in formatted:
  for tag in tags.mitems:
    if checkTag(tag, line, lineCount):
      break
  lineCount += 1

# verify the tags
for tag in tags:
  verifyTag(tag)


let 
  istart = tags[2].startLoc - 1
  iend = tags[2].endLoc - 1

var
  parsed: seq[string]
  col1Width = 0
  col2Width = 0

# analyze the lines
for line in formatted[istart..iend]:
  parsed = collapseSpaces(line).split(" ")
  if len(parsed) >= 2:
    # analyze cols 1 and 2
    if col1Width < len(parsed[0]):
      col1Width = len(parsed[0])
    if col2Width < len(parsed[1]):
      col2Width = len(parsed[1])
  else:
    # do nothing (yet)
    continue

col1Width += margin - 1
col2Width += margin - 1

# format the lines
for i in istart..iend:
  parsed = collapseSpaces(formatted[i]).split(" ")
  if len(parsed[0]) >= 1 and parsed[0][0] == ';':
    # skip commented lines
    continue
  elif len(parsed) >= 2:
    # perform formatting for cols 1 and 2
    parsed[0] = alignLeft(parsed[0], col1Width, ' ')
    parsed[1] = alignLeft(parsed[1], col2Width, ' ')
  else:
    # do nothing (yet)
    continue
  formatted[i] = parsed.join(" ").strip(leading = false)

writeFile(outfileName, formatted.join("\n"))
