import tables

import clapfn

var parser = ArgumentParser(programName: "csoundstyle", fullName: "csoundstyle",
                            description: "A Csound source code formatter.", version: "0.1.0")
parser.addRequiredArgument("input.csd", "Input file.")
parser.addStoreArgument("-o", "--out", "output.csd", "", "Specify the output file.")

let args = parser.parse()

let infileName = args["input.csd"]
let outfileName = case args["out"] == ""
  of true: infileName
  else: args["out"]

let contents = readFile(infileName)

writeFile(outfileName, contents)

