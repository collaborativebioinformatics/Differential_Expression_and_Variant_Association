#!/bin/bash

PYTHONPATH=$(readlink -f .)/src/python jupyter lab --notebook-dir="$(readlink -f .)"
