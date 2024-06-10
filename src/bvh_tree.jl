# Copyright (C) 2015-2018, Nils Moehrle
# All rights reserved.
#
# This software may be modified and distributed under the terms
# of the BSD 3-Clause license. See the LICENSE.txt file for details.

using StaticArrays

const BVHTREE_NUM_BINS = 64

struct Hit{F<:Real, I<:Integer}
	t::F # distance to hit
	id::I # index of hit primitive
	bcoords::SVector{3,F} # barycentric coordinates
end

struct Node{F<:AbstractFloat, I<:Integer}
	first::I
	last::I
	left::I
	right::I
	aabb::AABB{F}
end

struct BVHTree 

end

