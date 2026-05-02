# # Параметрическое исследование: влияние плотности рёбер
#
# Изучает влияние плотности рёбер на число путей атаки и среднюю длину пути.

using DrWatson
@quickactivate "project"

# ## Загрузка зависимостей

using Graphs, Random, CSV, DataFrames, Plots, StatsBase
include(srcdir("attack_graph.jl"))

# ## Параметры
#
# Диапазон плотностей 0.1–0.9, фиксированная сеть: 13 узлов,
# источник = 1, цель = 13.

edge_probs = 0.1:0.1:0.9
n_nodes = 13
source = 1
target = n_nodes

results = []
Random.seed!(123)

# ## Сбор данных

for p in edge_probs
    println("Плотность рёбер: $p")
    g = build_attack_graph(n_nodes, p, Dict(), [])
    paths = find_all_paths(g, source, target)
    metrics = compute_centrality_metrics(g)
    max_indeg = maximum(metrics[:in_degree])
    avg_path_len = isempty(paths) ? 0.0 : mean(length.(paths))
    push!(
        results,
        (p = p, paths = length(paths), max_indeg = max_indeg, avg_len = avg_path_len),
    )
end

# ## Сохранение в CSV

df = DataFrame(results)
mkpath(datadir("parameter_sweep"))
CSV.write(datadir("parameter_sweep", "results.csv"), df)

# ## Графики

p1 = plot(
    edge_probs,
    [r.paths for r in results],
    marker = :circle,
    xlabel = "Плотность рёбер",
    ylabel = "Количество путей",
    label = "Пути",
)

p2 = plot(
    edge_probs,
    [r.avg_len for r in results],
    marker = :circle,
    xlabel = "Плотность рёбер",
    ylabel = "Средняя длина пути",
    label = "Средняя длина",
)

combined = plot(p1, p2, layout = (2, 1), size = (800, 600))
savefig(combined, plotsdir("parameter_sweep.png"))