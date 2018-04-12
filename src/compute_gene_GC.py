# import libraries
import re
import itertools
import collections
from collections import OrderedDict
import numpy as np
import sys

fastaFile = sys.argv[1]
saveFn = sys.argv[2]

# Function to compute gc content
def gc_content(dna):
     g = dna.count('G')
     c = dna.count('C')
     gc_frac = (g+c)/float(len(dna))
     return gc_frac


# Initialize variables
seq = OrderedDict()
cds_region = []
gc_gene = collections.defaultdict(list)
gc_full_gene = collections.defaultdict(list)

# Read the fasta sequences with CDS
with open(sys.argv[1]) as f:
    for line1,line2 in itertools.izip_longest(*[f]*2):
        line1 = line1.rstrip('\n')
        line2 = line2.rstrip('\n')
        seq[line1] = line2


f.close()


## compute GC content for genes and transcripts
gc_seq={key: gc_content(value) for (key, value) in seq.items()}

for key,value in gc_seq.items():
	gc_full_gene[key.split('|')[1].strip()].append(value)

gc_full_gene_mean = {key: np.mean(value) for (key, value) in gc_full_gene.items()}

# write transcript level gc_content to file
# with open('transcript_full_gc_content.txt', 'w') as f:
#     for (key,value) in gc_seq.items():
#         f.write(key + '\t' + str(value) + '\n')
        
# f.close()

# write gene level gc content to file
with open(saveFn, 'w') as f:
    for (key,value) in gc_full_gene_mean.items():
        f.write(key + '\t' + str(value) + '\n')
        
f.close()

