# neutrinos_paper
Neutrinos paper

# Quickstart

1. Install Julia, Atom, and the Uber-Juno extension in Atom.
2. Start Julia in Atom by clicking in the window that says "Press Enter to start Julia"
3. Clone the repository either through Atom or externally.
```bash
git clone https://github.com/jayjaybillings/neutrinos_paper
```
4. Activate the project directory in Atom. Right click the project and select Juno->Activate Environment in Folder.
5. In the Julia window, install PlotlyJS:
```julia
Pkg.add("PlotlyJS")
```
6. Install the neutrinos code in the Julia terminal:
```julia
include("src/neutrinos.jl")
```
7. Run the tests to make sure the neutrinos package compiled and was detected correctly:
```julia
Pkg.test("neutrinos")
```

# Example usage
The neutrinos package can be used in the Julia Read-Eval-Print Loop (REPL) like any other package. For example, to show the energy of the neutrinos, type:
```julia
neutrinos.energy
```

If you plan to modify the package, you should consider executing "Pkg.add("Revise")" and "using Revise" after step 4 in the Quickstart section.

# Atom and Uber-Juno notes

The defaults in Atom appear to set for dev heathens whose mothers fed them little more than hard tack and water. Here are some tips.

Hit Ctrl+, on Linux to open up settings. Go to the Editor section. Set "Preferred Line Length" to your preferred value. 80 is the default. Then check the box next to "Soft wrap at preferred line length."

# Tricky bits

Calling Pkg.add(...) before calling Pkg.activate(".") installs the package in REPL. Calling Pkg.add(...) after calling Pkg.activate(".") adds it as a dependency in Project.toml.
