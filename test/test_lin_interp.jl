using MyInterpolations: ValsVector

@testset "Testing lin_interp.jl" begin

    @testset "MyLinInterp" begin
        grid = 0:2
        vals = [1, 3, 2.5]
        itp = MyLinInterp(grid, vals)

        x, y = 1.2, 2.9
        @test isapprox(@inferred(itp(x)), y)

        # Grid points
        for (i, x) in enumerate(grid)
            @test itp(x) == vals[i]
        end

        # Vector
        x, y = [0.5, 1.2], [2, 2.9]
        @test isapprox(@inferred(itp.(x)), y)

        # UnitRange
        x, y = grid, vals
        @test isapprox(@inferred(itp.(x)), y)

        # StepRange
        x, y = 0:2:2, vals[[1, 3]]
        @test isapprox(@inferred(itp.(x)), y)

        # FloatRange
        x, y = 0:0.5:1.5, [1, 2, 3, 2.75]
        @test isapprox(@inferred(itp.(x)), y)

        # LinSpace
        x, y = linspace(0, 1.5, 4), [1, 2, 3, 2.75]
        @test isapprox(@inferred(itp.(x)), y)
    end

    @testset "MyLinInterp extrapolation" begin
        # Current implementation returns vals[1] if x < lower bound, and
        # vals[end] if x > upper bound
        grid = 0:2
        vals = [1, 3, 2.5]
        itp = MyLinInterp(grid, vals)

        @test itp(-1) == vals[1]
        @test itp(10) == vals[end]
    end

    @testset "ValsVector" begin
        vals = [1, 3, 2.5]
        n = length(vals)
        vv = ValsVector(vals)

        @test length(vv) == n
        @test @inferred(vv(1, 0)) == vals[1]
        @test vv(n, 0) == vals[end]
        @test vv(n, 0.5) == vals[end]
        @test vv(1, 0.5) == 2

        @test_throws DomainError vv(-1, 0.5)
        @test_throws DomainError vv(n+1, 0.5)
    end

end
