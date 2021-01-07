import pandas as pd

dframe_toy = pd.DataFrame({
    'Observation' : ["PTEN", "SCN2A", "Variant1", "Variant2", "Variant3", "PELEVEN" ],
    'Experiment1' : ["UP",   "DOWN",     "Y",        "Y",        "N",       "UP" ],
    'Experiment2' : ["UP",   "DOWN"  ,   "N",        "N",        "Y",       "UP" ],
    'Experiment3' : ["UP",   "DOWN",     "Y",        "Y",        "N",       "UP" ],
    'Experiment4' : ["DOWN", "DOWN",     "Y",        "N",        "N",       "UP" ],
})

dframe_toy.to_csv("test/data/toy-example-3.tsv", sep="\t", index=False)