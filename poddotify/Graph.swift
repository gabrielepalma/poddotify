//
//  DependencyGraph.swift
//  poddotify
//
//  Created by Gabriele Palma on 29/08/2018.
//  Copyright © 2018 Gabriele Palma. All rights reserved.
//

import Cocoa

class Graph {
    var root = Dependency(name: "root", subspec: nil, version: nil)

    // After parsing each element in the graph is an entirely separate node
    // Version information in the  inner nodes is relative to the version contraint
    // Version information in the root node is the final resolved version
    // We map each dependency in the extended parsed graph to its root

    func normalizeDependencies() {
        for item in self.root.dependencies {
            item.dependencies = item.dependencies.map({ (dep) -> Dependency in
                return self.root.dependencies.filter({ (root) -> Bool in
                    return dep == root
                }).first ?? dep
            })
        }
    }

    // We compute the transitive closure and we use it to perform a transitive reduction of the graph

    func processTransitiveEdges() {
        self.root.recursivelyProcessTransitiveDependencies()
    }
}
