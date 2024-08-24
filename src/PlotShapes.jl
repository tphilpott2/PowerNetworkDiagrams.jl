function plot_line!(f_point::Point, t_point::Point; kwargs...)
    plot_line!(f_point.x, f_point.y, t_point.x, t_point.y; kwargs...)
end

function plot_line!(x_fr, y_fr, x_to, y_to; kwargs...)
    plot!([x_fr, x_to], [y_fr, y_to], label=false; kwargs...)
end

function plot_circle!(centre_point::Point, r_circle; kwargs...)
    plot_circle!(centre_point.x, centre_point.y, r_circle; kwargs...)
end

function plot_circle!(xc, yc, r_circle; kwargs...)
    θ = LinRange(0, 2π, 100)
    plot!(xc .+ r_circle * cos.(θ), yc .+ r_circle * sin.(θ), label=false; kwargs...)
end

function plot_triangle!(triangle_centre::Point, base, height, angle; fillcolor=false, kwargs...)
    # get triangle points
    p1 = Point(
        triangle_centre.x + base / 2 * cos(angle + π / 2),
        triangle_centre.y + base / 2 * sin(angle + π / 2)
    )
    p2 = Point(
        triangle_centre.x + base / 2 * cos(angle - π / 2),
        triangle_centre.y + base / 2 * sin(angle - π / 2)
    )
    p3 = Point(
        triangle_centre.x + height * cos(angle),
        triangle_centre.y + height * sin(angle)
    )

    # plot triangle
    plot_line!(p1, p2; kwargs...)
    plot_line!(p2, p3; kwargs...)
    plot_line!(p3, p1; kwargs...)

    # fill triangle if fillcolor is defined
    if fillcolor != false
        fill_polygon!([p1, p2, p3], fillcolor)
    end
end

function fill_polygon!(points::Vector{Point}, fillcolor)
    x_coords = [point.x for point in points]
    y_coords = [point.y for point in points]
    plot!(
        x_coords, y_coords,
        seriestype=:shape,
        fill=true, label=false,
        fillcolor=fillcolor,
    )
end