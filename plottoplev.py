import pandas as pd
import csv
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

import itertools
import sys

threshold = 3.0

df = pd.read_csv(sys.argv[1], comment='#', error_bad_lines=False)

# remove extra columns
df = df.iloc[:,0:2]

# just get L2 stats and exclude small values
df = df[(df['Area'].str.contains("\\.") & (not df['Area'].empty))]
df = df[df['Value'] > threshold]


df['group'] = df.apply(lambda row: row['Area'].split(".")[0], axis=1)
df['Area'] = df.apply(lambda row: row['Area'].split(".")[1], axis=1)

dfgroup = df.groupby('group', sort=False)

print(df)

fig, ax = plt.subplots()
size = 0.3

cmaps = sorted(m for m in plt.cm.datad if not m.endswith("_r"))
#print(cmaps)
cmap = plt.get_cmap("Pastel2")

#print(plt.cm.get_clim(cmap))

# TODO
# fix these colors
outer = cmap((np.arange(dfgroup.ngroups)*4)/24.0)
inner = cmap(np.array([1,2,5,6,9,10,13,14])/24.0)

ax.pie(dfgroup['Value'].sum(), radius=1, colors=outer, labels=df['group'].drop_duplicates())

# add legend with outer labels

p, t, _ = ax.pie(df['Value'], radius=1-size, colors=inner, autopct='%1.1f%%')

labels=df['Area'].tolist()
plt.legend(p, labels, loc="upper right", prop={'size': 10})
ax.set(aspect="equal", title="Toplev Bottleneck Data")

plt.savefig('bottleneck.png')

