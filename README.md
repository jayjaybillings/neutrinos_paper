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

The code can now be run by directly calling functions. For example, to show the energy of the neutrinos, type:
```julia
neutrinos.energy
```
