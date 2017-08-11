import pandas
import numpy

tag_name='user:Component'
raw = pandas.read_csv('COST_ALOCATION.csv', skiprows=1) # First row is some warning about tags not included by default
raw['UsageType'].fillna('???',inplace=True)
raw[tag_name].fillna('???',inplace=True)

pivot = raw.pivot_table(rows=[tag_name], cols=['UsageType'], values=['TotalCost'], aggfunc=numpy.sum, margins=True)

# for newer versions of pandas: raw.pivot_table(index=[tag_name], columns=['UsageType'], values=['TotalCost'], aggfunc=numpy.sum, margins=True)
pivot.to_csv('OUT_FILE.csv')
