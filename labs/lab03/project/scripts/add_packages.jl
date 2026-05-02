using DrWatson
@quickactivate "project"

using Pkg
Pkg.add([
    "Graphs",
    "GraphRecipes",
    "Plots",
    "JLD2",
    "CSV",
    "DataFrames",
    "StatsBase",
    "Literate",
])