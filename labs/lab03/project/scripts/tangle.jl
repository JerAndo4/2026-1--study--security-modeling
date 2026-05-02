using DrWatson
@quickactivate "project"
using Literate

scripts = [
    "ag_run_experiment.jl",
    "ag_analyze.jl",
    "ag_convergence.jl",
    "parameter_sweep.jl",
    "extra_tasks.jl",
]

mkpath(joinpath(@__DIR__, "../markdown"))
mkpath(joinpath(@__DIR__, "../notebooks"))

for s in scripts
    input = joinpath(@__DIR__, s)
    Literate.markdown(input, joinpath(@__DIR__, "../markdown"); flavor = Literate.QuartoFlavor())
    Literate.notebook(input, joinpath(@__DIR__, "../notebooks"); execute = false)
end