# Viravate2
aka Environmental effects on risk variants

## Introduction
Viravate2 is a tool designed to take in paired count and variant datasets and return variants of interest that are likely to be related to differential expression. This is accomplished using differential expression analysis and finding a correlation between significant changes in expression and changes in the populations (wether that be due to drugs, genetic changes, or something else). Using this DE analysis to identify genes of interest would allow us to identify variants of interest that we could then output to the user. 

## Methods

- Take inputs of paired count and variant data for case and control populations
- Differential gene expression analysis (we suspect that we will have to do this, but if Kym's group gets to it this will be given to us)
- Correspondence analysis -> find statistically significant correlations between variants and differential expression in genes
	- rank correlations by statistical significance
- Integrate variants -> split into present and not present
- add weights based on user input (what the client is interested in looking for)
- Output variants of interest

## Results 
Based on what we're planning to get, out results on the test data set were SOMETHING

## Future Directions 
- Ask Annie (I think she has a list written down about some additional features that we might want to add)
- How we could improve on potential errors in our code/stuff that we didn't get to refine
