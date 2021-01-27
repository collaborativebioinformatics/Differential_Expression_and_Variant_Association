#!/usr/env/bin python

import pandas as pd

import prince

import plotnine as p9

def calculate_mca(dframe : pd.DataFrame) -> prince.MCA:
    mca = prince.MCA(
                    n_components=2,
                    n_iter=3,
                    copy=True,
                    check_input=True,
                    engine='auto',
                    random_state=42
    )

    return mca.fit(dframe) 

def mca_to_coordinates(dframe : pd.DataFrame, mca : prince.MCA) -> pd.DataFrame:
    dframe_coords = mca.column_coordinates(dframe).reset_index()
    dframe_coords.columns = ["Factor", "x", "y"]
    dframe_coords["AssociationType"] = [x.split("_")[0] for x in dframe_coords["Factor"].tolist()]
    dframe_coords["Value"] = ["_".join(x.split("_")[1:]) for x in dframe_coords["Factor"].tolist()]
    dframe_coords.sort_values("x")
    
    return dframe_coords

def plot_mca_coords(dframe: pd.DataFrame, jitter_x=0, jitter_y=0):
    p9.options.figure_size = 10,10
    gg = (p9.ggplot(dframe) +
        p9.aes(x='x', y='y', 
               fill="Factor") +
        p9.geom_jitter(size=3, height=jitter_y, width=jitter_x) 
    )
    return gg