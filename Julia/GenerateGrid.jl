module GenerateGrid

#=
Collect functions that generate "grid".
=#

export grid_uni, grid_exp, grid_dbl, grid_tri, grid_mmv

"""
grid_uni(grid_min::Float64, grid_max::Float64, num_grid::Int64)

Purpose:
Generate uniform grid from "grid_min" to "grid_max".
"linspace" in Matlab.

Input:
grid_min → minimum of grid
grid_max → maximum of grid
num_grid → # grid

Output:
grid → Vector of num_grid × 1
"""
function grid_uni(grid_min::Float64, grid_max::Float64, num_grid::Int64)
    grid = zeros(num_grid)
    increment = (grid_max - grid_min) / (num_grid-1)
    for i in 1:num_grid
        grid[i] = (i-1)*increment + grid_min
    end
    # avoid rounding error
    if grid[num_grid] != grid_max
        grid[num_grid] = grid_max
    end
    return grid
end

"""
function grid_exp(grid_min::Float64, grid_max::Float64, num_grid::Int64)

Purpose:
Generate an exponentially-spaced grid.

Input:
grid_min → minimum of grid
grid_max → maximum of grid
num_grid → # grid

Output:
grid → Vector of num_grid × 1
"""
function grid_exp(grid_min::Float64, grid_max::Float64, num_grid::Int64)
    grid = zeros(num_grid)
    lmax = log(grid_max + 1)
    lmin = log(grid_min + 1)
    mesh = grid_uni(lmin, lmax, num_grid)
    for i in 1:num_grid
        grid[i] = exp(mesh[i]) - 1
    end
    return grid
end

"""
function grid_dbl(grid_min::Float64, grid_max::Float64, num_grid::Int64)

Purpose:
Generate a double exponentially-spaced grid.

Input:
grid_min → minimum of grid
grid_max → maximum of grid
num_grid → # grid

Output:
grid → Vector of num_grid × 1
"""
function grid_dbl(grid_min::Float64, grid_max::Float64, num_grid::Int64)
    grid = zeros(num_grid)
    lmax = log(log(grid_max + 1) + 1)
    lmin = log(log(grid_min + 1) + 1)
    mesh = grid_uni(lmin, lmax, num_grid)
    for i in 1:num_grid
        grid[i] = exp(exp(mesh[i]) - 1) - 1
    end
    return grid
end

"""
function grid_tri(grid_min::Float64, grid_max::Float64, num_grid::Int64)

Purpose:
Generate a triple exponentially-spaced grid.

Input:
grid_min → minimum of grid
grid_max → maximum of grid
num_grid → # grid

Output:
grid → Vector of num_grid × 1
"""
function grid_tri(grid_min::Float64, grid_max::Float64, num_grid::Int64)
    grid = zeros(num_grid)
    lmax = log(log(log(grid_max + 1) + 1) + 1)
    lmin = log(log(log(grid_min + 1) + 1) + 1)
    mesh = grid_uni(lmin, lmax, num_grid)
    for i in 1:num_grid
        grid[i] = exp(exp(exp(mesh[i]) - 1) - 1) - 1
    end
    return grid
end

"""
grid_mmv(grid_min::Float64, grid_max::Float64, θ::Float64, num_grid::Int64)

Purpose:
Generate grids based on the idea by
Maliar, Maliar and Valli (2010):
"Solving the Incomplete Markets Model with Aggregate Uncertainty using the Krusell-Smith Algorithm," Journal of Economic Dynamics and Control

Input:
grid_min → minimum of grid
grid_max → maximum of grid
num_grid → # grid

Output:
grid → Vector of num_grid × 1
"""
function grid_mmv(grid_min::Float64, grid_max::Float64, θ::Float64, num_grid::Int64)

    # Equation (7) in Maliar et al. (2010,JEDC)
    tmp = zeros(num_grid, 1)
    for i in 1:num_grid
        tmp[i] = ((i-1)/(num_grid-1))^θ * grid_max
    end

    # adjust to [grid_min, grid_max]
    grid = zeros(num_grid)
    grid[1] = grid_min
    for i in 2:num_grid
        grid[i] = grid[i-1] + (tmp[i]-tmp[i-1]) / grid_max*(grid_max-grid_min)
    end

    return grid
end

end # module
