import strutils
import tables

import clapfn

type
  CsTag = ref object of RootObj
    startTag: string
    endTag: string
    startLoc: int
    endLoc: int

proc checkTag(tag: var CsTag, s: string, l: int): bool =
  if s == tag.startTag:
    tag.startLoc = l
    return true
  elif s == tag.endTag:
    tag.endLoc = l
    return true
  else:
    return false

proc checkTags(tags: var seq[CsTag], s: string,  l: int) =
  for tag in tags:
    if s == tag.startTag:
      tag.startLoc = l
    elif s == tag.endTag:
      tag.endLoc = l

proc initCsTag(tagName: string): CsTag = 
  let startTag = "<" & tagName & ">"
  let endTag = "</" & tagName & ">"
  return CsTag(startTag: startTag, endTag: endTag, startLoc: 0, endLoc: 0)


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

let contents = readFile(infileName)   #-+
                                      # +-> join these lines
var formatted = splitLines(contents)  #-+

# declare Csound XML tags
var synthesizer = initCsTag("CsoundSynthesizer")
var options = initCsTag("CsOptions")
var instruments = initCsTag("CsOptions")
var score = initCsTag("CsScore")

var tags: set[CsTag] = {synthesizer, options, instruments, score}

var lineCount = 0
for line in formatted:
  tags.checkTags(line, lineCount)
  lineCount += 1

writeFile(outfileName, formatted)

