function initialise_plot(x_size, y_size; scale=1.0, kwargs...)
    return plot(
        label=false,
        axis=false,
        grid=false,
        xlims=(0, x_size), ylims=(0, y_size),
        size=(x_size * scale, y_size * scale),
        kwargs...
    )
end

function get_centre(p1::Point, p2::Point)
    return Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)
end

function get_angle(p1::Point, p2::Point)
    return atan((p2.y - p1.y), (p2.x - p1.x))
end

function plot_network!(net; kwargs...)
    for (id, bus) in net["bus"]
        plot_element!(bus; kwargs...)
    end
    for (id, branch) in net["branch"]
        plot_element!(branch, net["bus"]; kwargs...)
    end
    for (id, shunt) in net["shunt"]
        plot_element!(shunt, net["bus"]; kwargs...)
    end
end

function calc_bus_ends(centre::Point, length, orientation)
    if orientation == "horizontal"
        return (Point(centre.x - length / 2, centre.y), Point(centre.x + length / 2, centre.y))
    elseif orientation == "vertical"
        return (Point(centre.x, centre.y - length / 2), Point(centre.x, centre.y + length / 2))
    else
        error("Invalid orientation")
    end
end

function make_bus_cubicles_dict(ends::Tuple{Point,Point}, n_cubicles, orientation)
    if orientation == "horizontal"
        x_left = ends[1].x
        y = ends[1].y
        return OrderedDict(
            i => Point(x_left + (i - 0.5) * cubicle_size, y) for i in 1:n_cubicles
        )
    elseif orientation == "vertical"
        x = ends[1].x
        y_down = ends[1].y
        return OrderedDict(
            i => Point(x, y_down + (i - 0.5) * cubicle_size) for i in 1:n_cubicles
        )
    else
        error("Invalid orientation")
    end
end