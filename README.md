# poddotify

Poddotify is a command line tool written in Swift to read a Podfile.lock and generate a Dot source. The Dot source can then be processed by Graphviz rendering library to generate a visualization of the dependency graph as a jpg, png, pdf or more.

For more information about graphviz you can visit their official website https://www.graphviz.org

The command line tool will resolve the transitive closure to simplify the dependency graph and reduce the number of edges. It will also mark as a subgraph the dependencies that represents subspecs of a certain podspec or, optionally, reduce them to a single node in order to simplify the graph complexity.

USAGE:
  - -i filename : specify the .lock filename to be used as input
  - -o filename : output filename
  - -noversion : do not include dependency version numbers (-nv)
  - -nosubspecs : reduce subspecs subgraphs to a single node (-ns)
  - -lefttoright : print graph left to right (-lr)
  - -verbose : verbose output (-v)
  - -help : usage information (-h)
 
By default the input filename is Podfile.lock

# Installation

You can use Homebrew to install the binary directly: 

```sh
brew install gabrielepalma/tools/poddotify
```

Alternatively, you can clone this repository, edit the sources and build and run however you see fit.

# Examples
  
Using Wordpress Podfile.lock:
https://github.com/wordpress-mobile/WordPress-iOS 
```sh
poddotify -i WP-Podfile.lock.txt -lr -ns 
dot WP-Podfile.lock.dot -Tjpg -O 
```
<img src="https://raw.githubusercontent.com/gabrielepalma/poddotify/master/WP-Podfile.lock.dot.jpg" height="400" />

Using Artsy Podfile.lock:
https://github.com/artsy/eidolon 
```sh
poddotify -i Artsy-Podfile.lock.txt
dot Artsy-Podfile.lock.dot -Tjpg -O 
```
<img src="https://raw.githubusercontent.com/gabrielepalma/poddotify/master/Artsy-Podfile.lock.dot.jpg" />
