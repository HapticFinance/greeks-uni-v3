# Greeks for Uniswap V3

The greeks are a toolbox used to measure risk in option trading. The most important greeks are delta, gamma, vega and thetha. This repository provides code to compute delta, gamma and vega for concentrated liquidity positions in Uniswap V3 [1]. Additionally, it shows how to calculate the optimal position size, given a target value of delta [2].


This work is part of the research conducted while designing the Haptic protocol and is made available for educational purposes.


## Requirements

- R

## Installation

- Install R from [here](https://cran.r-project.org/bin/linux/ubuntu/) (Ubuntu)
- Clone this repository

## Usage

- Open a terminal and navigate to the repository
- Check that the file has executable permissions or grant them with `chmod +x gen.r`
- Run `./gen.r`


# References

[1] https://lambert-guillaume.medium.com/pricing-uniswap-v3-lp-positions-towards-a-new-options-paradigm-dce3e3b50125

[2] https://lambert-guillaume.medium.com/how-to-create-a-perpetual-options-in-uniswap-v3-3c40007ccf1

