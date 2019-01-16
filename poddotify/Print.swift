//
//  Print.swift
//  poddotify
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import Foundation

class Print {
    static func logo() {
        print("")
        print("                 _     _       _   _  __         ")
        print("                | |   | |     | | (_)/ _|        ")
        print(" _ __   ___   __| | __| | ___ | |_ _| |_ _   _   ")
        print("| '_ \\ / _ \\ / _` |/ _` |/ _ \\| __| |  _| | | |  ")
        print("| |_) | (_) | (_| | (_| | (_) | |_| | | | |_| |  ")
        print("| .__/ \\___/ \\__,_|\\__,_|\\___/ \\__|_|_|  \\__, |  ")
        print("| |                                       __/ |  ")
        print("|_|                                      |___/   ")
        print("")
        print("This app will rely on Graphviz rendering library")
        print("Visit http://www.graphviz.org for more info")
        print("")
    }

    static func manual() {
        print("USAGE:")
        print("     -i filename  : specify the .lock filename to be used as input")
        print("     -o filename  : output filename")
        print("     -noversion   : do not include dependency version numbers (-nv)")
        print("     -nosubspecs  : reduce subspecs subgraphs to a single node (-ns)")
        print("     -lefttoright : print graph left to right (-lr)")
        print("     -verbose     : verbose output (-v)")
        print("By default the input filename is Podfile.lock")
        print("The output will be a dot source which can be used with Graphviz")
        print("Visit http://www.graphviz.org to get the rendering library")
    }
}
