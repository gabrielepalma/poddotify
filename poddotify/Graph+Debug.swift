//
//  Graph+Debug.swift
//  poddotify
//
//  Created by Gabriele Palma on 29/08/2018.
//  Copyright © 2018 Gabriele Palma. All rights reserved.
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
