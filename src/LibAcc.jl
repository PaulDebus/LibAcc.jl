module LibAcc

using GeometryBasics

export Scene, intersect

using CxxWrap
@wrapmodule(() -> joinpath(@__DIR__, "..", "extension", "build", "libaccwrap"))

function __init__()
	@initcxx
end

Vec3f(x, y, z) = Vec3f(Float32(x), Float32(y), Float32(z))


function BVHTree(mesh::Mesh)
	faces = GeometryBasics.raw.(Iterators.flatten(GeometryBasics.faces(mesh)))
	vertices = CxxRef.([Vec3f(coords...) for coords in GeometryBasics.coordinates(mesh)])
	return BVHTree(faces, vertices)
end

function intersect(tree::BVHTree, origin, direction)
	if length(direction) != 3 || length(origin) != 3
		error("Invalid input dimensions, need 3D.")
	end
	o = Vec3f(origin...)
	d = Vec3f(direction...)
	return intersect(tree, o, d)
end

function closest_point(tree::BVHTree, point::Vector)
	if length(point) != 3
		error("Invalid input dimensions, need 3D.")
	end
	return data(closest_point(tree, Vec3f(point...)))
end

end # module LibAcc
