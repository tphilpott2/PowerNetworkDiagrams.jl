# generic
shunt_angles = Dict(
    "right" => 0.0,
    "up" => π / 2,
    "left" => π,
    "down" => -π / 2,
)
struct Point
    x::Real
    y::Real
end


mutable struct BusData
    id
    centre::Point
    n_cubicles::Int
    orientation::String
    ends::Tuple{Point,Point}
    length::Float64
    cubicles::OrderedDict

    BusData(
        id,
        centre,
        n_cubicles,
        orientation;
        length=n_cubicles * cubicle_size,
        ends=calc_bus_ends(centre, length, orientation),
        cubicles=make_bus_cubicles_dict(ends, n_cubicles, orientation),
    ) = new(id, centre, n_cubicles, orientation, ends, length, cubicles)
end
struct Connection
    bus
    cubicle_number
end
cubicle_size = 2
bus_thickness = 4
bus_colour = :black


mutable struct LineData
    id
    f_connection::Connection
    t_connection::Connection
    extra_line_points::Vector{Point}
end
tline_thickness = 2
tline_colour = :gray


mutable struct TrfData
    id
    f_connection::Connection
    t_connection::Connection
    extra_line_points::Vector{Point}
end
trf_thickness = 2
trf_colour = :gray
r_circle_trf = 1


mutable struct SynchronousGenData
    id
    connection::Connection
    orientation::String
end
gen_thickness = 2
gen_colour = :black
r_circle_gen = 1
gen_offset = 4
gen_annotation_size = 12
gen_annotation_colour = :black


mutable struct LoadData
    id
    connection::Connection
    orientation::String
end
load_thickness = 2
load_colour = :black
load_offset = 3
load_triangle_base = 1 # base is used as whatever is perpendicular to the offset line
load_triangle_height = 1 # height is used as whatever is parallel to the offset line
load_triangle_fill = :black