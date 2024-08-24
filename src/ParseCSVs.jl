function parse_bus_csv(file_path)
    df_bus = CSV.File(file_path) |> DataFrame
    buses = OrderedDict()
    for row in eachrow(df_bus)
        bus = BusData(
            row.id,
            Point(row.x_centre, row.y_centre),
            row.n_cubicles,
            row.orientation,
        )
        buses[row.id] = bus
    end
    return buses
end

function parse_branch_csv(file_path)
    branch_df = CSV.File(file_path) |> DataFrame
    branches = OrderedDict()
    for row in eachrow(branch_df)
        # make connections from 
        f_connection = Connection(row.f_bus, row.f_cubicle)
        t_connection = Connection(row.t_bus, row.t_cubicle)

        # parse different branch types
        if row.line_type == "transmission_line"
            line = LineData(
                row.id,
                f_connection,
                t_connection,
                isequal(row.extra_line_points, missing) ? Point[] : parse_extra_line_points(row)
            )
            branches[row.id] = line
        elseif row.line_type == "transformer"
            trf = TrfData(
                row.id,
                f_connection,
                t_connection,
                isequal(row.extra_line_points, missing) ? Point[] : parse_extra_line_points(row)
            )
            branches[row.id] = trf
        else
            throw(ArgumentError("Unknown branch type: $(row.line_type)"))
        end
    end
    return branches
end

function parse_extra_line_points(row)
    extra_line_points = Point[]
    raw_extra_line_points = split(row.extra_line_points, "\n")
    for line_point in raw_extra_line_points
        x, y = split(line_point, ",")
        try
            push!(extra_line_points, Point(parse(Float64, x), parse(Float64, y)))
        catch
            println(line_point)
            throw(ArgumentError("$(row.id): Error parsing extra line points"))
        end
    end
    return extra_line_points
end

function parse_shunt_csv(file_path)
    shunt_df = CSV.File(file_path) |> DataFrame
    shunts = OrderedDict()
    for row in eachrow(shunt_df)
        if row.type == "synchronous_generator"
            shunt = SynchronousGenData(
                row.id,
                Connection(row.bus, row.cubicle_number),
                row.orientation
            )
            shunts[row.id] = shunt
        elseif row.type == "load"
            shunt = LoadData(
                row.id,
                Connection(row.bus, row.cubicle_number),
                row.orientation
            )
            shunts[row.id] = shunt
        end
    end
    return shunts
end

