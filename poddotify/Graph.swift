//
//  Graph.swift
//  poddotify
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
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

    public var clusters : [String]?
    func processClusters() {
        clusters = []
        var count = 0
        var all = self.root.allDependencies

        while let dep = all.first {
            let members = all.filter { (candidate) -> Bool in
                return dep.title == candidate.title
            }

            var clusterName : String? = nil
            if members.count > 1 {
                count = count + 1
                clusterName = "cluster\(count)"
                clusters?.append("cluster\(count)")
            }

            for member in members {
                member.clusterId = clusterName
            }

            all = all.filter({ (dep) -> Bool in
                return !members.contains(dep)
            })
        }
    }
}
