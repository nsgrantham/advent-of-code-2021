using AdventOfCode
using Test

@testset "Year2021 Day25" begin
    example = IOBuffer(
        "v...>>.vv>\n" *
        ".vv>>.vv..\n" *
        ">>.>v>...v\n" *
        ">>v>>.>.v.\n" *
        "v>v.vv.v..\n" *
        ">.>>..v...\n" *
        ".vv..>.>v.\n" *
        "v.v..>>v.v\n" *
        "....v..v.>"
    )
    @test AdventOfCode.Year2021.Day25.solve(example) == 58
end
