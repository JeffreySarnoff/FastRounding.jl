using FastRounding

using Test

const SysFloat = Union{Float64, Float32}

a = 4/3
b = 1/7
c = -b


function testrounding(op::Function, a::T, b::T, mode::RoundingMode) where T<: SysFloat
    S = typeof(op(a,b))

    c = setrounding(BigFloat, mode) do
            S(op(big(a), big(b)))
    end
    return c
end

@testset "Test Rounding" begin
    @testset "a + b" begin
        @test testrounding(+, a, b, RoundUp) == add_round(a, b, RoundUp)
        @test testrounding(+, a, b, RoundDown) == add_round(a, b, RoundDown)
        @test testrounding(+, a, b, RoundToZero) == add_round(a, b, RoundToZero)
        @test testrounding(+, a, b, RoundNearest) == add_round(a, b, RoundNearest)
    end
    @testset "a - b" begin
        @test testrounding(-, a, b, RoundUp) == sub_round(a, b, RoundUp)
        @test testrounding(-, a, b, RoundDown) == sub_round(a, b, RoundDown)
        @test testrounding(-, a, b, RoundToZero) == sub_round(a, b, RoundToZero)
        @test testrounding(-, a, b, RoundNearest) == sub_round(a, b, RoundNearest)
    end
    @testset "a * b" begin
        @test testrounding(*, a, b, RoundUp) == mul_round(a, b, RoundUp)
        @test testrounding(*, a, b, RoundDown) == mul_round(a, b, RoundDown)
        @test testrounding(*, a, b, RoundToZero) == mul_round(a, b, RoundToZero)
        @test testrounding(*, a, b, RoundNearest) == mul_round(a, b, RoundNearest)
    end
    @testset "a / b" begin
        @test testrounding(/, a, b, RoundUp) == div_round(a, b, RoundUp)
        @test testrounding(/, a, b, RoundDown) == div_round(a, b, RoundDown)
        @test testrounding(/, a, b, RoundToZero) == div_round(a, b, RoundToZero)
        @test testrounding(/, a, b, RoundNearest) == div_round(a, b, RoundNearest)
    end
    @testset "a + c" begin
        @test testrounding(+, a, c, RoundUp) == add_round(a, c, RoundUp)
        @test testrounding(+, a, c, RoundDown) == add_round(a, c, RoundDown)
        @test testrounding(+, a, c, RoundToZero) == add_round(a, c, RoundToZero)
        @test testrounding(+, a, c, RoundNearest) == add_round(a, c, RoundNearest)
    end
    @testset "a - c" begin
        @test testrounding(-, a, c, RoundUp) == sub_round(a, c, RoundUp)
        @test testrounding(-, a, c, RoundDown) == sub_round(a, c, RoundDown)
        @test testrounding(-, a, c, RoundToZero) == sub_round(a, c, RoundToZero)
        @test testrounding(-, a, c, RoundNearest) == sub_round(a, c, RoundNearest)
    end
    @testset "a * c" begin
        @test testrounding(*, a, c, RoundUp) == mul_round(a, c, RoundUp)
        @test testrounding(*, a, c, RoundDown) == mul_round(a, c, RoundDown)
        @test testrounding(*, a, c, RoundToZero) == mul_round(a, c, RoundToZero)
        @test testrounding(*, a, c, RoundNearest) == mul_round(a, c, RoundNearest)
    end
    @testset "a / c" begin
        @test testrounding(/, a, c, RoundUp) == div_round(a, c, RoundUp)
        @test testrounding(/, a, c, RoundDown) == div_round(a, c, RoundDown)
        @test testrounding(/, a, c, RoundToZero) == div_round(a, c, RoundToZero)
        @test testrounding(/, a, c, RoundNearest) == div_round(a, c, RoundNearest)
    end
    @testset "1.0 + 0.0" begin
        @test testrounding(+, 1.0, 0.0, RoundUp) == 1.0
        @test testrounding(+, 1.0, 0.0, RoundDown) == 1.0
        @test testrounding(+, 1.0, 0.0, RoundToZero) == 1.0
        @test testrounding(+, 1.0, 0.0, RoundNearest) == 1.0
    end
    @testset "1.0 - 0.0" begin
        @test testrounding(-, 1.0, 0.0, RoundUp) == 1.0
        @test testrounding(-, 1.0, 0.0, RoundDown) == 1.0
        @test testrounding(-, 1.0, 0.0, RoundToZero) == 1.0
        @test testrounding(-, 1.0, 0.0, RoundNearest) == 1.0
    end
    @testset "1.0 * 1.0" begin
        @test testrounding(*, 1.0, 1.0, RoundUp) == 1.0
        @test testrounding(*, 1.0, 1.0, RoundDown) == 1.0
        @test testrounding(*, 1.0, 1.0, RoundToZero) == 1.0
        @test testrounding(*, 1.0, 1.0, RoundNearest) == 1.0
    end
    @testset "1.0 / 1.0" begin
        @test testrounding(/, 1.0, 1.0, RoundUp) == 1.0
        @test testrounding(/, 1.0, 1.0, RoundDown) == 1.0
        @test testrounding(/, 1.0, 1.0, RoundToZero) == 1.0
        @test testrounding(/, 1.0, 1.0, RoundNearest) == 1.0
    end
end

