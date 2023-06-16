# DONE ON LOCAL MACHINE

# importing modules
import pandas as pd

clean_phenotypes = pd.read_csv("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clean_phenotypes.txt", sep="\t")
out = clean_phenotypes.fillna(0)
out.to_csv("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clean_phenotypes.txt", sep="\t", index=None)


