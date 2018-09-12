//
//  Dotify.swift
//  poddotify
//
//  Created by Gabriele Palma on 29/08/2018.
//  Copyright © 2018 Gabriele Palma. All rights reserved.
//

import Cocoa

extension Graph {
    // A cluster is a set of dependencies sharing the same podspec
    // Either we return the dot source to visualize clusters or we reduce the clusters to a single node
    
    func dotifyClusters() -> String {
        return clusters?.map({ (str) -> String in
            let clusterMembers = self.root.allDependencies.filter({ (dep) -> Bool in
                return dep.clusterId ?? "" == str
            }).map({ (dep) -> String in
                return "\(dep.stringId);"
            }).joined(separator: "\n")

            let clusterDefinition : [String] = [
                "",
                "subgraph \(str) {",
                "color=blue;",
                clusterMembers,
                "}"
            ]
            return clusterDefinition.joined(separator: "\n")
        }).joined(separator: "\n\n") ?? ""
    }

    func dotify(includeSubspecs : Bool, includePodspecVersion : Bool, renderingDirection : Direction) -> String {
        var output = "strict digraph {\n"
        output.append("rankdir=\(renderingDirection.rawValue);\n")

        if includeSubspecs {
            output.append(dotifyClusters())
        }

        for dep in root.dependencies {
            output.append(dep.recursivelyToDot(includeVersion: includePodspecVersion, includeSubSpecs: includeSubspecs, renderingDirection: renderingDirection))
        }
        output.append("}\n")
        return output
    }
}

extension Dependency {

    func escape(_ label : String) -> String {
        var escaped = label
        escaped = escaped.replacingOccurrences(of: "~", with: "")
        escaped = escaped.replacingOccurrences(of: ">", with: "")
        escaped = escaped.replacingOccurrences(of: "=", with: "")
        escaped = escaped.replacingOccurrences(of: " ", with: "")
        escaped = escaped.replacingOccurrences(of: "\"", with: "")
        return escaped
    }

    func layout(_ label : String, orientation : Direction) -> String {
        if orientation == .topToBottom {
            return "{\(label)}"
        }
        else {
            return label
        }
    }

    func recursivelyToDot(includeVersion : Bool, includeSubSpecs : Bool, renderingDirection : Direction) -> String {
        let outputVersion = includeVersion ? (self.version != nil ? "|\(self.version ?? "")" : "|") : ""
        let outputSubspec = includeSubSpecs ? "|\(self.subspec ?? " ")" : ""

        let label = "\(self.title)\(outputSubspec)\(outputVersion)"
        var output = "\(dotId(includeSubSpecs)) [shape=record, label=\"\(layout(escape(label), orientation: renderingDirection))\"];\n"
        for dep in self.dependencies {
            if dotId(includeSubSpecs) != dep.dotId(includeSubSpecs) {
                output.append("\(dotId(includeSubSpecs)) -> \(dep.dotId(includeSubSpecs));\n")
            }
            output.append(dep.recursivelyToDot(includeVersion: includeVersion, includeSubSpecs: includeSubSpecs, renderingDirection: renderingDirection))
        }
        return output
    }
}

extension Dependency {
    func dotId(_ includeSubspecs : Bool) -> String {
        if let clusterId = clusterId, !includeSubspecs {
            return clusterId
        }
        return stringId
    }
}
