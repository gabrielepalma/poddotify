//
//  main.swift
//  poddotify
//
//  Created by Gabriele Palma on 29/08/2018.
//  Copyright © 2018 Gabriele Palma. All rights reserved.
//

import Foundation

enum State {
    case void
    case input
    case output
}

enum Direction : String {
    case leftToRight = "LR"
    case topToBottom = "TB"
}

var inputState = State.void

var showSubspecSubgraphs = true
var showDependencyVersions = true
var graphDirection = Direction.topToBottom

var showUsage = false
var verboseOutput = false

var inputFilename = "Podfile.lock"
var outputFilename = ""

for argument in CommandLine.arguments {
    if inputState == .input {
        inputFilename = argument
    }
    if inputState == .output {
        outputFilename = argument
    }
    inputState = .void
    switch argument {
    case "-i":
        inputState = .input
    case "-o":
        inputState = .output
    case "-help", "-h":
        showUsage = true
    case "lefttoright", "-lr":
        graphDirection = .leftToRight
    case "-noversion", "-nv":
        showDependencyVersions = false
    case "-nosubspec", "-ns":
        showSubspecSubgraphs = false
    case "-verbose", "-v":
        verboseOutput = true
    default:
        break
    }
}

// DEBUG RUNS

//    inputFilename = "bPodfile.lock"
//    showSubspecSubgraphs = true
//    graphDirection = .topToBottom
//    verboseOutput = false

//

var justFilename = NSURL(fileURLWithPath: inputFilename).deletingPathExtension?.lastPathComponent ?? ""
if outputFilename.isEmpty {
    outputFilename = "\(justFilename).dot"
}

Print.logo()

guard showUsage == false else {
    Print.manual()
    print("")
    exit(EXIT_SUCCESS)
}

print("Generating graph: ")
print("From input: \(inputFilename)")
print("To output: \(outputFilename) ")
print("Including dependency version: \(showDependencyVersions)")
print("Including subspec subgraphs: \(showSubspecSubgraphs)")
print("Rendering direction: \(graphDirection), \(graphDirection.rawValue)")
print("Verbose output for debugging: \(verboseOutput)")
print("")

guard let inputText = try? String(contentsOfFile: inputFilename) else {
    print("***** Error reading from input file: terminating *****")
    print("")
    exit(EXIT_FAILURE)
}

let dependencies = Graph.parse(content: inputText)

if verboseOutput {
    print("")
    print("***** Debug print after parsing *****")
    dependencies.debugPrint()
}

dependencies.normalizeDependencies()
dependencies.processTransitiveEdges()

if verboseOutput {
    print("")
    print("***** Debug print after processing graph *****")
    dependencies.debugPrint()
}

let outputText = dependencies.dotify(includeSubspecs: showSubspecSubgraphs, includePodspecVersion: showDependencyVersions, renderingDirection: graphDirection)

do {
    try outputText.write(toFile: outputFilename, atomically: false, encoding: String.Encoding.utf8)
    print("Dot source generation completed")
    print("You can now run 'dot \(outputFilename) -Tjpg -O'")
    print("")
    exit(EXIT_SUCCESS)
}
catch {
    print("***** Error writing to output file: terminating *****")
    print("")
    exit(EXIT_FAILURE)
}

