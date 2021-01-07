# viravate2
aka Environmental effects on risk variants


## Correspondance analysis

### Create the conda environment

```
./import_conda.sh
conda activate viravate2
```

### See options

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


### Default run

See the arguments; there should be files to do just a dry run like so:

`python src/python/corresponder.py`

### Update conda

If you install additional conda packages, the `export_conda.sh` script will update the environement.
