//
//  Graph+Parsing.swift
//  poddotify
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import Cocoa

extension Graph {
    // Insted of parsing it all with a proper parser, we use regexp to only get the "PODS:" subsection. Syntax and structure allows it.
    static func parse(content : String) -> Graph {
        let versionRegex = "\\([^\\)]+\\)"
        let subspecRegex = "\\/.*+.*+"

        var rootDependencies = [Dependency]()
        var scope : Dependency?

        var version : String? = nil
        var subspec : String? = nil

        let lines = content.components(separatedBy: CharacterSet.newlines)
        var pre = true

        for current in lines {
            var line = current

            if pre {
                if lines.contains("PODS:") {
                    pre = false
                }
                continue
            }

            line = line.replacingOccurrences(of: ":", with: "")

            if line.starts(with: "  - ") {
                scope = nil
                line = line.replacingOccurrences(of: "  - ", with: "")
            }
            else if line.starts(with: "    - ") {
                line = line.replacingOccurrences(of: "    - ", with: "")
            }
            else {
                break
            }

            version = line.range(of: versionRegex, options: .regularExpression).map({ (range) -> String in
                String(line[range])
            })
            if let version = version {
                line = line.replacingOccurrences(of: version, with: "")
            }
            version = version?.replacingOccurrences(of: "(", with: "")
            version = version?.replacingOccurrences(of: ")", with: "")


            subspec = line.range(of: subspecRegex, options: .regularExpression).map({ (range) -> String in
                String(line[range])
            })
            if let subspec = subspec {
                line = line.replacingOccurrences(of: subspec, with: "")
            }
            if let newSubspec = subspec?.dropFirst() {
                subspec = String(newSubspec)
            }
            subspec = subspec?.replacingOccurrences(of: " ", with: "")
            line = line.replacingOccurrences(of: " ", with: "")

            let dependency = Dependency(name: line, subspec: subspec, version: version)
            if let scope = scope {
                scope.dependencies.append(dependency)
            }
            else {
                rootDependencies.append(dependency)
                scope = dependency
            }
        }

        let graph = Graph()
        graph.root.dependencies = rootDependencies
        return graph
    }
}
