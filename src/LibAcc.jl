module LibAcc

using GeometryBasics

export BVHTree, intersect, closest_point

using CxxWrap
@wrapmodule(() -> joinpath(@__DIR__, "..", "extension", "build", "libaccwrap"))

function __init__()
	@initcxx
end

Vec3f(x, y, z) = Vec3f(Float32(x), Float32(y), Float32(z))
Base.length(v::Vec3f) = length(data(v))
Base.getindex(v::Vec3f, i) = getindex(data(v), i)
Base.convert(::Type{Vec3f}, v::Vector) = Vec3f(v...)
Base.convert(::Type{Vector}, v::Vec3f) = data(v)


function BVHTree(mesh::Mesh)
	faces = GeometryBasics.raw.(Iterators.flatten(GeometryBasics.faces(mesh)))
	vertices = CxxRef.([Vec3f(coords...) for coords in GeometryBasics.coordinates(mesh)])
	return BVHTree(faces, vertices)
end

function intersect(tree::BVHTree, origin::Vector, direction::Vector, t_max::Float32=1000000f0)
	if length(direction) != 3 || length(origin) != 3
		error("Invalid input dimensions, need 3D.")
	end
	o = Vec3f(origin...)
	d = Vec3f(direction...)
	return intersect(tree, o, d, t_max)
end

function closest_point(tree::BVHTree, point::Vector)
	if length(point) != 3
		error("Invalid input dimensions, need 3D.")
	end
	return data(closest_point(tree, Vec3f(point...)))
end

end # module LibAcc
