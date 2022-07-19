"""
This is a module for studying neutrino interactions and oscillations in a two flavor model according to the work of Guidry and Billings, 2020.

https://arxiv.org/abs/1812.00035

This module provides plotting utilities and data structures.

"""
module plots

# Use the default Julia plotting library
using Plots

"""
A simple struct for storing plotting data.
"""
mutable struct PlotData
    x::Vector{Float64}
    fx::Vector{Float64}
    title::String
    xLabel::String
    fxLabel::String
    lineWidth::Int
end

"""
This function creates a 1D plot with x and f(x) vectors of the specified size.
"""
function make1DPlotData(size)

    plotData = PlotData(zeros(size),zeros(size),"Title","x Label",
    "f(x) Label",1)

    return plotData
end

"""
This is a utility function for plotting 1D plot data.
"""
function plot(data::PlotData)
    xlabel!(data.xLabel)
    title!(data.title)
    ylabel!(data.fxLabel)
    dataPlot = Plots.plot(data.x,data.fx,linewidth=data.lineWidth)
    display(dataPlot)
    return dataPlot
end

end # module
