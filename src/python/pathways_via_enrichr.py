#! /usr/bin/python
# code takes a gene list (glist) and interfaces with enrichr (in gseapy) and produces output files in Excel format

import sys
import re
import os
from math import *

import fnmatch
import numpy  
import scipy
from scipy import stats
import xlwt
import itertools
#import openpyexcel

import pandas as pd
import gseapy as gp


def multiple_dfs(df_list, sheets, file_name, spaces):
    writer = pd.ExcelWriter(file_name,engine='xlsxwriter')   
    row = 0
    for dataframe in df_list:
        dataframe.to_excel(writer,sheet_name=sheets,startrow=row , startcol=0)   
        row = row + len(dataframe.index) + spaces + 1
    writer.save()

def dfs_tabs(df_list, sheet_list, file_name):
    writer = pd.ExcelWriter(file_name,engine='xlsxwriter')   
    for dataframe, sheet in zip(df_list, sheet_list):
        dataframe.to_excel(writer, sheet_name=sheet, startrow=0 , startcol=0)   
    writer.save()    

def CallEnrichr(GeneList : list,
                analysis = 'DE_genes',
                
               ):
     # pathways   
    SetList = ['ENCODE_and_ChEA_Consensus_TFs_from_ChIP-X','ChEA_2016','ENCODE_TF_ChIP-seq_2015', 'TRANSFAC_and_JASPAR_PWMs', 'Genome_Browser_PWMs', 'TF-LOF_Expression_from_GEO','GO_Biological_Process_2018','GO_Cellular_Component_2018', 'GO_Molecular_Function_2018','Panther_2016','DrugMatrix','DSigDB']
    framelist = []

    sys.ps1 = 'test'
    # sample gene list below
    #GeneList = ['CTLA2B','CMBL', 'CLIC6', 'IL13RA1', 'TACSTD2', 'DKKL1', 'CSF1', 'CITED1']
    #enrichr_results = gp.enrichr(gene_list=GeneList, description='test_name', gene_sets='ENCODE_and_ChEA_Consensus_TFs_from_ChIP-X',outdir= 'trythis', cutoff=0.5, scale=0.8, no_plot=True)
    #print enrichr_results

    
    outdirname = 'enrichr_' + analysis
    
    # loop through Enrichr pathways
    for member in SetList:
        enrichr_results = gp.enrichr(gene_list=GeneList,
                                     description='test_name',
                                     gene_sets=member,
                                     outdir= 'trythis',
                                     cutoff=0.5,
                                     #scale=0.8,
                                     no_plot=True)
        #d = {member:0}
        #df = pd.DataFrame(data = d, index= [0])
        #framelist = framelist + [df]
        
        dframe_results = enrichr_results.results
        framelist = framelist + [dframe_results]
    
    return framelist
    #print framelist
    #NameSheet = Region + "_" + GenesetName + Comparison    
    #multiple_dfs(framelist, 'Enrichr2', 'test1.xlsx', 1)


def get_geneset_dataframe(list_of_dframes,
                          filter_on = "`Adjusted P-value` < 0.05"
                         ):
    LIST_OF_FIELDS = ["Gene_set", "Term", "Overlap", "P-value", "Adjusted P-value", "Odds Ratio", "Combined Score", "Genes"]
    dframe_gs = pd.concat(list_of_dframes)[LIST_OF_FIELDS]
    if len(filter_on) > 1:
        dframe_gs = dframe_gs.query(filter_on)
    return dframe_gs



