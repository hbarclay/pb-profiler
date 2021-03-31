import pandas as pd
import csv
import matplotlib

import itertools
import sys

num_cores = 12
df = pd.read_csv(sys.argv[1], comment='#', error_bad_lines=False, header=None)

df[5] = df[5].round()

if (num_cores > 1):
    df['group'] = list(itertools.chain.from_iterable([x]*num_cores for x in range(0, len(df[1])/num_cores)))

    df = df.groupby(['group', 3]).agg({1:['sum']})

# this section is specific to the events measured
print("CPI: " + str(df.iloc[0, 0] / float(df.iloc[1, 0])));
print("Br MPKI: " + str(1000.0 * (df.iloc[2, 0] / float(df.iloc[3, 0]))));
print("L1 MPKI: " + str(1000.0 * (df.iloc[4, 0] / float(df.iloc[5, 0]))));
print("dTLB MPKI: " + str(1000.0 * ((df.iloc[6, 0] + df.iloc[7,0]) / float(df.iloc[8, 0]))));
print("iTLB MPKI: " + str(1000.0 * (df.iloc[9, 0] / float(df.iloc[10, 0]))));




