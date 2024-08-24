function plot_element!(bus_data::BusData; kwargs...)
    # plot bus
    plot_line!(
        bus_data.ends[1], bus_data.ends[2];
        color=bus_colour, lw=bus_thickness,
        kwargs...
    )
end

function plot_element!(line_data::LineData, buses; kwargs...)
    # get coordinates of bus connections
    f_bus = buses[line_data.f_connection.bus]
    t_bus = buses[line_data.t_connection.bus]
    f_point = f_bus.cubicles[line_data.f_connection.cubicle_number]
    t_point = t_bus.cubicles[line_data.t_connection.cubicle_number]

    # get coordinates of extra line points
    line_points = OrderedDict{Int64,Point}()
    if length(line_data.extra_line_points) == 0
        line_points[1] = f_point
        line_points[2] = t_point
    else
        line_points[1] = f_point
        for (i, point) in enumerate(line_data.extra_line_points)
            line_points[i+1] = point
        end
        line_points[length(line_data.extra_line_points)+2] = t_point
    end

    # plot line
    line_point_idxs = keys(line_points)
    for idx in 1:length(line_point_idxs)-1
        plot_line!(
            line_points[idx], line_points[idx+1];
            c=tline_colour,
            lw=tline_thickness,
            kwargs...
        )
    end
end

function plot_element!(trf_data::TrfData, buses; kwargs...)
    # get coordinates of bus connections
    f_bus = buses[trf_data.f_connection.bus]
    t_bus = buses[trf_data.t_connection.bus]
    f_point = f_bus.cubicles[trf_data.f_connection.cubicle_number]
    t_point = t_bus.cubicles[trf_data.t_connection.cubicle_number]

    trf_point_idxs = keys(trf_data.extra_line_points)
    if length(trf_point_idxs) > 0
        throw(ArgumentError("$(trf_data.id): Multiple line points are not supported for transformers."))
    end

    # get centre of transformer
    trf_centre = get_centre(f_point, t_point)

    # get angle between the two points
    trf_angle = get_angle(f_point, t_point)

    # get x and y shift for the transformer circles
    # corresponds to the distance that the centre should be from the midpoint of the line
    x_shift = round((r_circle_trf / 2) * cos(trf_angle), digits=15)
    y_shift = round((r_circle_trf / 2) * sin(trf_angle), digits=15)

    # plot transformer circles
    plot_circle!(
        Point(trf_centre.x + x_shift, trf_centre.y + y_shift),
        r_circle_trf;
        color=trf_colour, lw=trf_thickness,
        kwargs...
    )
    plot_circle!(
        Point(trf_centre.x - x_shift, trf_centre.y - y_shift),
        r_circle_trf;
        color=trf_colour, lw=trf_thickness,
        kwargs...
    )

    # plot transformer lines
    # the distance from the centre of the transformer to the edge of the circles should be 3* x_shift or y_shift
    plot_line!(
        f_point,
        Point(trf_centre.x - 3 * x_shift, trf_centre.y - 3 * y_shift);
        color=trf_colour, lw=trf_thickness,
        kwargs...
    )
    plot_line!(
        t_point,
        Point(trf_centre.x + 3 * x_shift, trf_centre.y + 3 * y_shift);
        color=trf_colour, lw=trf_thickness,
        kwargs...)
end

function plot_element!(gen_data::SynchronousGenData, buses; kwargs...)
    # get coordinates of bus connections
    bus = buses[gen_data.connection.bus]
    connection_point = bus.cubicles[gen_data.connection.cubicle_number]

    # calculate angle from orientation
    gen_angle = shunt_angles[gen_data.orientation]

    # get centre of gen icon circle
    gen_centre = Point(
        connection_point.x + gen_offset * cos(gen_angle),
        connection_point.y + gen_offset * sin(gen_angle)
    )

    # plot gen circle
    plot_circle!(
        Point(gen_centre.x, gen_centre.y),
        r_circle_gen;
        color=gen_colour, lw=gen_thickness,
        kwargs...
    )

    # get end of gen line
    gen_line_end = Point(
        connection_point.x + (gen_offset - r_circle_gen) * cos(gen_angle),
        connection_point.y + (gen_offset - r_circle_gen) * sin(gen_angle)
    )
    # plot gen line
    plot_line!(
        connection_point,
        gen_line_end;
        color=gen_colour, lw=gen_thickness,
        kwargs...
    )

    # add 'G' to gen icon
    annotate!(
        gen_centre.x, gen_centre.y, text("G", gen_annotation_size, gen_annotation_colour)
    )
end

function plot_element!(load_data::LoadData, buses; kwargs...)
    # get coordinates of bus connections
    bus = buses[load_data.connection.bus]
    connection_point = bus.cubicles[load_data.connection.cubicle_number]

    # calculate angle from orientation
    load_angle = shunt_angles[load_data.orientation]

    # get centre of the base of the load icon triangle
    load_offset_end = Point(
        connection_point.x + load_offset * cos(load_angle),
        connection_point.y + load_offset * sin(load_angle)
    )

    # plot offset line
    plot_line!(
        connection_point,
        load_offset_end;
        color=load_colour, lw=load_thickness,
        kwargs...
    )

    # plot load triangle
    plot_triangle!(
        load_offset_end,
        load_triangle_base,
        load_triangle_height,
        load_angle,
        color=load_colour, lw=load_thickness,
        fillcolor=load_triangle_fill
    )
end