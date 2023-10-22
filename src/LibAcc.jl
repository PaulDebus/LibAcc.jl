module LibAcc

# export greet

using CxxWrap
@wrapmodule(() -> joinpath(@__DIR__, "..", "extension", "build", "libacc"))

function __init__()
	@initcxx
end



end # module LibAcc
