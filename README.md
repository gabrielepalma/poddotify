# poddotify
From Podfile.lock to images.

A simple command line tool written in Swift to read a Podfile.lock and generate a Dot source. The Dot source can then be processed by Graphviz rendering library to generate a visualization of the dependency graph as a jpg, png, pdf or more.

For more information about graphviz you can visit their official website https://www.graphviz.org

The command line tool will resolve the transitive closure to simplify the dependency graph and reduce the number of edges. It will also mark as a subgraph the dependencies that represents subspecs of a certain podspec or, optionally, reduce them to a single node in order to simplify the graph complexity.

USAGE:
    -i filename  : specify the .lock filename to be used as input
    -o filename  : output filename
    -noversion   : do not include dependency version numbers (-nv)
    -nosubspecs  : reduce subspecs subgraphs to a single node (-ns)
    -lefttoright : print graph left to right (-lr)
    -verbose     : verbose output (-v)
By default the input filename is Podfile.lock

Examples: vbnv
downloading the Podfile.lock from https://github.com/wordpress-mobile/WordPress-iOS 
running
poddotify -i WP-Podfile.lock.txt -lr -ns
followed by
dot WP-Podfile.lock.dot -Tjpg -O
will generate


downloading the Podfile.lock from https://github.com/artsy/eidolon
running
poddotify -i Artsy-Podfile.lock.txt 
followed by
dot Artsy-Podfile.lock.dot -Tjpg -O
will generate





