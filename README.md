# viravate2

## Goal
Develop a tool to connect common risk variants of a generic disease to the differential expression that drives its pathology.


# Connecting Risk Variants to Differential Expression

## RNASeq and Differential Expression
As bioinformatics begins to hone in on personalized medicine, one needs to look to the causes of differential expression. Out of the numerous ways to look at the differential genetics, RNASeq data in particular can be used in a wide array of computational analyses. One standard approach is to look at the differential expression of different genes by looking the mRNA produced from that gene.

## Whole Genome Approaches - Back to the Genetic Code
GWAS and other observational traits have helped uncover specific links between the human genome and human illness. Furthermore, teasing out differential expression across case and control groups has helped to start unraveling the genetics chronic diseases at a large scale.

## A Stymeing Point
While both of the approaches above are widely reported for a number of genes, connecting the two approaches remains elusive. Understanding differential gene expression does not reveal with great specficity the changes in the DNA responsible for a disease. In a symmetric manner, risk variants do not elucidate the precise effects on gene expression and symptoms that a patieny endures. A causal relationship between the two is hypothesized, but given the sheer number of genes implicated by either technique, finding a relationship could prove finding a needle in a haystack.

## Why should anyone care?
Well, if one can find the needles, it's not so mcuh of a stretch eventually unlock this hackathon's ultimate vision of providing a clinician an easy way to allow their patients' genetics guide their treatment suggestion. To lay the foundation for such a massive undertaking we begin by delivering a simple method to start teasing correlations between differential expression and what we may believe to be their underlying causes.

## What does ViraVate do?
At its simplest level, it uses multiple correspondance analysis to help facilitate dimension reduction and highlight genes and variants to explore next. These variants can also provide a clinican and patient with more information. Additional features: ortholog mapping for researchers using model organisms, drug targeting, and gene ontology/pathway enrichment to provide further nuance to the factors considered in correspondance analysis.

## ViraVate - A Visualization
<img src="./Revised_Flowchart.svg">

## Implementation (let me know if I should remove this - probably need help!)
Considering the flowchart above, most of the functions were able to be implemented with pre-existing tools. Multiple correspondance analysis was implemented using [prince](https://github.com/MaxHalford/Prince).  
## Operation
### Inputs
* Differential Expression from desired RNASeq data.
* vcf.gz file (we reccomend getting this with the following [method](https://github.com/collaborativebioinformatics/expressed-variant-impact)).

### Outputs
* A list of differentially expressed genes associated with provided variants.
* For non-human data, orthologs applicable to model organism research.

### How to use this tool!
#### Getting Started
Gather the above inputs. To be able to use the multiple correspondance analysis, the differential expression data needs to be in a categorical form.   
Setting that up is easy enough! To get your data into the appropriate input, use (hopefully a script here for user).
#### Optional Analysis
If one wants to include drug target information or pathways analysis, use the enrichr pipeline provided to add these factors into your MCA input.   
Now we're ready to start the set up and push your data through!
#### First Time Using? -- Create the conda environment

```
./import_conda.sh
conda activate viravate2
```

#### See options

```
(viravate2) z@z-Lenovo-Z51-70:~/development/viravate2$ python src/python/corresponder.py --help
usage: corresponder.py [-h] [-v | -q] [--input_path INPUT_PATH]
                       [--output_path OUTPUT_PATH]

Calculated Correspondance Analysis

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose
  -q, --quiet
  --input_path INPUT_PATH
                        Path to the data frame
  --output_path OUTPUT_PATH
                        Path to the data frame
```


#### Default run

See the arguments; there should be files to do just a dry run like so:

`python src/python/corresponder.py`

#### Update conda

If you install additional conda packages, the `export_conda.sh` script will update the environement.

## Testing
### Dataset
Test data belongs to the following dataset: Suzuki et al. 2019, ENA accession: PRJDB6952  
A minimal experimental design for differential expression testing was performed in order to develop the pipeline code and methods  
CONTROL ACC:  
DRR131561  
DRR131570  
DRR131593  
TREATMENT ACC:  
DRR131576  
DRR131588  
DRR131599  
The concentrations for treatment samples (0.01, 0.1, and 1.0) were used as replicates for this exmaple since no direct replicates were available. The only time point considered was 24 hours.
### Differential Expression
### MCA Input Creation
### Inputs
### Outputs

## Team Members:
Lead: Sierra D. Miller
Manuel Belmadani
Nicholas Cooley
Annie Nadkarni
Stephen Price
Barry Zorman
Writer: Shamika Dhuri 

