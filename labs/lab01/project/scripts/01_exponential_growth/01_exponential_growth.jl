using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using DataFrames
using JLD2

script_name = "01_exponential_growth"
mkpath(plotsdir(script_name))   # создать папку plots/01_exponential_growth/
mkpath(datadir(script_name))    # создать папку data/01_exponential_growth/

function exponential_growth!(du, u, p, t)
    alpha = p
    du[1] = alpha * u[1]
end

u0 = [1.0]
alpha = 0.3
tspan = (0.0, 10.0)

prob = ODEProblem(exponential_growth!, u0, tspan, alpha)
sol = solve(prob, Tsit5(), saveat=0.1)

plot(sol, label="u(t)", xlabel="Время t", ylabel="Популяция u",
    title="Экспоненциальный рост (alpha = $alpha)", lw=2, legend=:topleft)
savefig(plotsdir(script_name, "exponential_growth_alpha=$alpha.png"))

df = DataFrame(t=sol.t, u=first.(sol.u))
println("Первые 5 строк результатов:")
println(first(df, 5))

u_final = last(sol.u)[1]
doubling_time = log(2) / alpha
println("\nАналитическое время удвоения: ", round(doubling_time; digits=2))

@save datadir(script_name, "all_results.jld2") df
