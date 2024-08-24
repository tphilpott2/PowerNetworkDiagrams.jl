using Plots, PowerNetworkDiagrams, OrderedCollections
const _PND = PowerNetworkDiagrams

dir = joinpath(dirname(@__DIR__), "data", "ieee39")


net = OrderedDict(
    "bus" => _PND.parse_bus_csv(joinpath(dir, "bus.csv")),
    "branch" => _PND.parse_branch_csv(joinpath(dir, "branch.csv")),
    "shunt" => _PND.parse_shunt_csv(joinpath(dir, "shunt.csv")),
)

(x_size, y_size) = (80, 76)
scale = 12

pl = _PND.initialise_plot(x_size, y_size, scale=scale)
_PND.plot_network!(net)

# guide lines
# hline!([i for i in 0:x_size], label=false, color=:gray, lw=0.5)
# vline!([i for i in 0:y_size], label=false, color=:gray, lw=0.5)
# plot!(axis=true)

annotate!(
    23, 1, text("G 02", 12, :bold, :black)
)
annotate!(
    76, 53, text("G 09", 12, :bold, :black)
)
annotate!(
    18, 7, text("Bus 31", 12, :bold, :black)
)
annotate!(
    71, 59, text("Bus 38", 12, :bold, :black)
)

display(pl)

savefig(pl, joinpath(dirname(@__DIR__), "data", "ieee39", "ieee39_network_diagram.png"))

