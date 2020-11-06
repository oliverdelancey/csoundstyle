import strutils
import tables

import clapfn

import cstags


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

# make sure that all the sections exist
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
