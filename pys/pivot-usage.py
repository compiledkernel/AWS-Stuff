import pandas
import numpy
tag_name='user:Component'
tag_value='ExpensiveComonent'

raw = pandas.read_csv('DETAILED.csv')
filtered = raw.loc[raw[tag_name]==tag_value][['ResourceId','UsageType','Cost']]
filtered['ResourceId'].fillna('???',inplace=True)
pivot = filtered.pivot_table(rows=['ResourceId'], cols=['UsageType'], values=['Cost'], aggfunc=numpy.sum, margins=True) # Newer pandas - see above
pivot.to_csv('OUT_FILE.csv')
