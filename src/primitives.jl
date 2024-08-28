 # Copyright (C) 2015-2018, Nils Moehrle
 # All rights reserved.
 # 
 # This software may be modified and distributed under the terms
 # of the BSD 3-Clause license. See the LICENSE.txt file for details.
 
using StaticArrays
using LinearAlgebra

Point{F} = SVector{3,F}
Vec3{F} = SVector{3,F}

mutable struct AABB{F<:Real}
	min::Point{F}
	max::Point{F}
end

struct Tri{F<:Real}
	a::Point{F}
	b::Point{F}
	c::Point{F}
end

struct Ray{F<:Real} 
	origin::Point{F} 
	dir::Point{F} 
	tmin::F
	tmax::F
end

import Base: +
+(a::AABB{F}, b::AABB{F}) where {F<:Real} = AABB{F}(min.(a.min, b.min), max.(a.max, b.max))
# function +=(a::AABB{F}, b::AABB{F}) where {F<:Real}
# 	a.min = min.(a.min, b.min)
# 	a.max = max.(a.max, b.max)
# 	return a
# end

function calculate_aabb(verts::Vector{Point{F}}) where {F<:Real}
	min_corner = Point{F}(Inf, Inf, Inf)
	max_corner = Point{F}(-Inf, -Inf, -Inf)
	for v in verts
		min_corner = min.(min_corner, v)
		max_corner = max.(max_corner, v)
	end
	return AABB{F}(min_corner, max_corner)
end

calculate_aabb(tri::Tri{F}) where {F<:Real} = calculate_aabb([tri.a, tri.b, tri.c])

function calculate_aabb!(aabb::AABB{F}, tri::Tri{F}) where {F<:Real}
	other_bb = calculate_aabb(tri)
	aabb += other_bb
end

function surface_area(aabb::AABB{F}) where {F<:Real}
	dx, dy, dz = aabb.max - aabb.min
	return 2*(dx*dy + dy*dz + dz*dx)
end

function volume(aabb::AABB{F}) where {F<:Real}
	dx, dy, dz = aabb.max - aabb.min
	return dx*dy*dz
end

Base.isvalid(aabb::AABB{F}) where {F<:Real} = all(aabb.min .< aabb.max)

center(aabb::AABB{F}) where {F<:Real} = 0.5*(aabb.min + aabb.max)
# TODO: do we want this? could also just access the required dimension
center(aabb::AABB{F}, d::Integer) where {F<:Real} = center(aabb)[d]

struct BoxIntersetction{F<:Real}
	hit::Bool
	t::F
end

function intersect(aabb::AABB{F}, ray::Ray{F}) -> BoxIntersetction{F} where {F<:Real}
	tmin = ray.tmin
	tmax = ray.tmax
	for i in eachindex(aabb.min)
		t1 = (aabb.min[i] - ray.origin[i]) / ray.dir[i]
		t2 = (aabb.max[i] - ray.origin[i]) / ray.dir[i]
		tmin = max(tmin, min(t1, t2))
		tmax = min(tmax, max(t1, t2))
	end
	hits = tmin <= tmax
	return BoxIntersetction{F}(hits, tmin)
end

function barycentric_coordinates(a::Point{F}, b::Point{F}, c::Point{F}) -> Point{F} where {F<:Real}
	# Derived from the book "Real-Time Collision Detection" (Christer Ericson)
	# published by Morgan Kaufmann, 2005
	# I suppose this is for barycentric coordinates on a line
	d00 = dot(a, a)
	d01 = dot(a, b)
	d11 = dot(b, b)
	d20 = dot(c, a)
	d21 = dot(c, b)
	denom = d00 * d11 - d01 * d01

	bc2 = (d11 * d20 - d01 * d21) / denom
	bc3 = (d00 * d21 - d01 * d20) / denom
	bc1 = 1 - bc2 - bc3

	return Point{F}(bc1, bc2, bc3)
end


function closest_point(aabb::AABB{F}, v::Point{F}) -> Point{F} where {F<:Real}
	ret = zero(Point{F})
	for i in eachindex(aabb.min)
		ret[i] = max(aabb.min[i], min(aabb.max[i], v[i]))
	end
	return ret
end

function closest_point(tri::Tri{F}, v::Point{F}) -> Point{F} where {F<:Real}
	ab = tri.b - tri.a
	ac = tri.c - tri.a
	normal = cross(ab, ac)
	n = norm(normal)
	normal /= n

	p = v - dot(normal, v - tri.a) * normal
	ap = p - tri.a

	bcoords = barycentric_coordinates(ab, ac, ap)
	
	if bcoords[1] < 0 
		bc = tri.c - tri.b
		n = norm(bc)
		t = max(0., min(dot(bc, v - tri.b) / n, n))
		# TODO: continue here
		return tri.b + t * bc
end

function normal(tri::Tri{F}) -> Vec3{F} where {F<:Real}
	return cross(tri.b - tri.a, tri.c - tri.a)
end


