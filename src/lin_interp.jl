# Linear interpolation routines

# ValsVector type

type ValsVector{T<:Real}
    data::Vector{T}
end

Base.length(vals::ValsVector) = length(vals.data)

@inline function Base.call{TV<:Real,TW<:Real}(vals::ValsVector{TV},
                                              i::Integer, w::TW)
    T = promote_type(TV, TW)
    n = length(vals)
    1 <= i <= n || throw(DomainError())
    i == n && return convert(T, vals.data[n])
    return vals.data[i] * (1 - w) + vals.data[i+1] * w
end


# search_index_weight method

@inline function search_index_weight(a::AbstractVector, x::Real)
    T = Float64
    n = length(a)
    i = searchsortedlast(a, x)
    i <= 0 && return 1, zero(T)
    i >= n && return n, zero(T)

    w::T = (x - a[i]) / (a[i+1] - a[i])
    return i, w
end


# MyLinInterp type

immutable MyLinInterp{TG<:AbstractVector,TV<:Real}
    grid::TG
    vals::ValsVector{TV}
end

MyLinInterp{T1<:Real,T2<:Real}(grid::AbstractVector{T1}, vals::Vector{T2}) =
    MyLinInterp(grid, ValsVector(vals))

function Base.call(f::MyLinInterp, x::Real)
    t = search_index_weight(f.grid, x)
    return f.vals(t[1], t[2])
end

function Base.call{T<:Real}(f::MyLinInterp, x::AbstractVector{T})
    n = length(x)
    out = Array(Float64, n)
    for i in 1:n
        out[i] = f(x[i])
    end
    return out
end
