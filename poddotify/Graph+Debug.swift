//
//  Graph+Debug.swift
//  poddotify
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import Cocoa

extension Graph {
    func debugPrint() {
        print("")
        print("PODS:\n")
        let list = self.root.dependencies
        for item in list {
            self .debubPrintElement(item: item, indent: 0)
        }
    }
    func debubPrintElement(item : Dependency, indent : Int) {
        print("\(String(repeating: " ", count: indent*2))\(item.debugString())")

        for subitem in item.dependencies {
            self .debubPrintElement(item: subitem, indent: indent+1)
        }
    }
}
