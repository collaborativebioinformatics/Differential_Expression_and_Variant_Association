#!/usr/env/bin python
import os
import argparse
import utils
import pandas as pd

def parse_arguments():

    parser = argparse.ArgumentParser(description="Calculated Correspondance Analysis")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("-v", "--verbose", action="store_true")
    group.add_argument("-q", "--quiet", action="store_true")
    parser.add_argument("--input_path", default="test/data/toy-example-3.tsv", type=str, help="Path to the data frame")
    parser.add_argument("--output_path", default=None, type=str, help="Path to the data frame")
    
    args = parser.parse_args()

    return args

def main(args):
    
    ## Load data
    dframe_input = pd.read_table(args.input_path)
    
    ## Apply MCA, convert to coordinates
    dframe_coords = utils.mca_to_coordinates(dframe_input,
                                             utils.calculate_mca(dframe_input)
    )

    output_path =  "output/default.tsv" if args.output_path is None else args.output_path
    
    if args.verbose:
        print("Writing file to ", output_path, "in", os.getcwd())
    dframe_coords.to_csv(output_path, sep="\t", index=False)

if __name__ == '__main__':
    args = parse_arguments()
    main(args)
