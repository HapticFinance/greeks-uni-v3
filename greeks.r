#!/usr/bin/env Rscript
path = getwd()
source(paste(path, "/install.r", sep=""))

# Calculating Delta, gamma and vega of a concentrated liquidity position
# From https://lambert-guillaume.medium.com/how-to-create-a-perpetual-options-in-uniswap-v3-3c40007ccf1
# Example, a UNI/ETH position that resembles a 50 delta call option with 7 days to expiration and 50% annualized volatility:

P = 115
Pa = 81
Pb = 175
σ = 0.5
K = sqrt(Pb * Pa)
r = sqrt(Pb / Pa)

δ_P <- sqrt( (K * r) / P) - 1 / r - 1
γ_P <- (-sqrt(K * r)) / 2 * (r - 1) * P^(-3/2)
ν <- P * sqrt( (2 * pi / σ^2 ) * ((sqrt(r) - 1) / (r -1))^2 ) * abs(δ_P) * γ_P

print(glue::glue("K {K} r {r} δ_P = {δ_P} γ_P = {γ_P} ν = {ν}"))