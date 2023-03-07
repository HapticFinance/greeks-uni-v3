#!/usr/bin/env Rscript
path = getwd()
source(paste(path, "/install.r", sep=""))

# Calculating delta, gamma of a concentrated liquidity position
# From https://lambert-guillaume.medium.com/how-to-create-a-perpetual-options-in-uniswap-v3-3c40007ccf1

get_greeks <- function(σ, r, K, P) {

    # Time to expiration
    T_t <- (2 * pi / σ^2 ) * ((sqrt(r) - 1) / (r -1))^2
    δ <- (sqrt( r * (K / P)) - 1) / (r - 1)
    γ <- (-sqrt(K * r)) / 2 * (r - 1) * P^(-3/2)

    return(list(δ = δ, γ = γ))
}

calc_chunk <- function(σ, P) {

    # Liquidity ranges
    ranges <- list(
        c(999, 1001),
        c(990, 1010),
        c(909, 1100),
        c(833.33, 1200),
        c(500, 2000),
        c(200, 5000)
    )

    data <- matrix(0, nrow = length(ranges), ncol = 6)

    for (i in 1:length(ranges)) {

        Pa = ranges[[i]][1]
        Pb = ranges[[i]][2]

        K = sqrt(Pb * Pa)
        r = sqrt(Pb / Pa)
        
        greeks <- get_greeks(σ, r, K, P)

        δ <- greeks$δ
        γ <- greeks$γ

        data[i, 1] <- σ
        data[i, 2] <- Pa
        data[i, 3] <- Pb
        data[i, 4] <- formatC(r, digits = 3, format = "f")
        data[i, 5] <- formatC(δ, digits = 6, format = "f")
        data[i, 6] <- formatC(γ, digits = 6, format = "f")

    }
    return(data)
}

get_chunks <- function(σ) {

    tryCatch({
    
        # Current asset price
        P = 1000
        chunk_one <- calc_chunk(σ, P)
        chunk_two <- calc_chunk(σ * 2, P)
        
        combined <- rbind(
            chunk_one, 
            chunk_two
        )

        return(combined)
    }, error = function(e) {

        if (length(e) > 1) {
            print(e)
            return(NA)
        }

    }) 
} 

# From https://lambert-guillaume.medium.com/pricing-uniswap-v3-lp-positions-towards-a-new-options-paradigm-dce3e3b50125
calc_chunk_liq <- function(σ, δ, T) {

    prices <- c(
        3300,
        2200,
        1800,
        1500,
        1000
    )

    data <- matrix(0, nrow = length(prices), ncol = 6)

    for (i in 1:length(prices)) {
        P <- prices[i]
        r_t = (1 + σ * sqrt(T / (365 * 2 * pi)))^2 / (1 - σ * sqrt(T / (365 * 2 * pi)))^2

        K = P * (δ * r_t - δ + 1)^2 / r_t
        Pa = K / r_t
        Pb = K * r_t

        greeks <- get_greeks(σ, r_t, K, P)
        
        δ <- greeks$δ
        γ <- greeks$γ


        data[i, 1] <- δ
        data[i, 2] <- σ
        data[i, 3] <- prices[i]
        data[i, 4] <- T
        data[i, 5] <- Pa
        data[i, 6] <- Pb
    }

    return(data)
}

get_chunks_liq <- function(σ) {

    # Target delta
    δ = 0.5
    # Time to expiration
    T = 14 
    
    first_chunk <- calc_chunk_liq(σ, δ, T)
    second_chunk <- calc_chunk_liq(σ * 2, δ, T * 2)
    third_chunk <- calc_chunk_liq(σ * 2.5, δ, T * 3)
    
    combined <- rbind(
        first_chunk, 
        second_chunk,
        third_chunk
    )

    return(combined)
}