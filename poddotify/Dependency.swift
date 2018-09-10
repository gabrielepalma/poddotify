//
//  Dependency.swift
//  poddotify
//
//  Created by Gabriele Palma on 29/08/2018.
//  Copyright © 2018 Gabriele Palma. All rights reserved.
//

import Cocoa

class Dependency : Equatable {

    public var stringId : String
    public var generationId : Int
    public var title : String
    public var subspec : String?
    public var version : String?
    public var dependencies : [Dependency]

    // The transitive closure of this node dependencies
    private var _allDependencies  : [Dependency]?
    public var allDependencies : [Dependency] {
        get {
            if let _allDependencies = _allDependencies {
                return _allDependencies
            }
            else {
                var all = [Dependency](dependencies)
                for dep in dependencies {
                    all.append(contentsOf: dep.allDependencies.filter({ (dep) -> Bool in
                        return !all.contains(dep)
                    }))
                }
                _allDependencies = all
                return all
            }
        }
        set {
            _allDependencies = newValue
        }
    }

    private func isTransitiveDependency(_ candidate : Dependency) -> Bool {
        for dep in dependencies {
            if dep.allDependencies.contains(candidate) {
                return true
            }
        }
        return false
    }

    static var lastId = 0
    init(name : String, subspec : String?, version : String?) {
        Dependency.lastId = Dependency.lastId + 1
        self.stringId = "node\(Dependency.lastId)"
        self.generationId = Dependency.lastId
        self.title = name
        self.subspec = subspec
        self.version = version
        self.dependencies = [Dependency]()
    }

    static func == (lhs: Dependency, rhs: Dependency) -> Bool {
        return lhs.title == rhs.title && lhs.subspec == rhs.subspec
    }

    func debugString() -> String {
        let printedSubspec = self.subspec != nil ? "/\(self.subspec ?? "")" : ""
        let printedVersion = self.version != nil ? " [\(self.version ?? "")]" : ""
        return "\(self.title)\(printedSubspec)\(printedVersion)"
    }
}

// Recursive methods
extension Dependency {
    private func recursivelyResetTransitiveEdges() {
        _allDependencies = nil
        for dep in dependencies {
            dep.recursivelyResetTransitiveEdges()
        }
    }

    private func recursivelyRemoveTransitiveDependencies(){
        self.dependencies = self.dependencies.filter({ (dep) -> Bool in
            return !isTransitiveDependency(dep)
        })
        for dep in self.dependencies {
            dep.recursivelyRemoveTransitiveDependencies()
        }
    }
    public func recursivelyProcessTransitiveDependencies() {
        self.recursivelyResetTransitiveEdges()
        let _ = self.allDependencies
        self.recursivelyRemoveTransitiveDependencies()
    }
}

