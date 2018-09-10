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
    func manageClusters(remove : Bool) -> String {
        self.root.recursivelyProcessTransitiveDependencies()
        var output = ""
        var count = 0
        var all = self.root.allDependencies

        while let dep = all.first {
            let members = all.filter { (candidate) -> Bool in
                return dep.title == candidate.title
            }
            if remove {
                // We let Graphviz do the dirty work by renaming the member nodes to the same dot id
                for member in members {
                    member.subspec = nil
                    member.stringId = dep.stringId
                }
            }
            else if members.count > 1 {
                // Dot source to mark subgraphs
                count = count + 1
                output.append("subgraph cluster\(count) {\n")
                output.append("color=blue;\n")
                for item in members {
                    output.append("\(item.stringId);\n")
                }
                output.append("}\n")
            }
            all = all.filter({ (dep) -> Bool in
                return !members.contains(dep)
            })
        }
        return remove ? "" : output
    }

    func dotify(includeSubspecs : Bool, includePodspecVersion : Bool, renderingDirection : Direction) -> String {
        var output = "strict digraph {\n"
        output.append("rankdir=\(renderingDirection.rawValue);\n")

        let clusters = manageClusters(remove: !includeSubspecs)
        if includeSubspecs {
            output.append(clusters)
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
        var output = "\(self.stringId) [shape=record, label=\"\(layout(escape(label), orientation: renderingDirection))\"];\n"
        for dep in self.dependencies {
            if self.stringId != dep.stringId {
                output.append("\(self.stringId) -> \(dep.stringId);\n")
            }
            output.append(dep.recursivelyToDot(includeVersion: includeVersion, includeSubSpecs: includeSubSpecs, renderingDirection: renderingDirection))
        }
        return output
    }
}
