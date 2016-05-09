# Linear interpolation routines

# ValsVector type

type ValsVector{T<:Real}
    data::Vector{T}
end

Base.length(vals::ValsVector) = length(vals.data)

function Base.call{TV<:Real,TW<:Real}(vals::ValsVector{TV}, i::Integer, w::TW)
    T = promote_type(TV, TW)
    n = length(vals)
    1 <= i <= n || throw(DomainError())
    i == n && return convert(T, vals.data[n])
    return vals.data[i] * (1 - w) + vals.data[i+1] * w
end
