import re
import itertools
import collections
import numpy as np
from collections import OrderedDict


# Function to compute gc content
def gc_content(dna):
     g = dna.count('G')
     c = dna.count('C')
     gc_frac = (g+c)/float(len(dna))
     return gc_frac

seq = OrderedDict()
cds_region = []
gc_gene = collections.defaultdict(list)

# Read the fasta sequences
with open('gencode.v25.pc_transcripts.fa') as f:
    for line1,line2 in itertools.izip_longest(*[f]*2):
        if re.search("CDS", line1):
            line1 = line1.rstrip('\n')
            line2 = line2.rstrip('\n')
            seq[line1] = line2


f.close()


# Extract positions for CDS region -- basically trimming out UTRs
for i in seq:
    cds_region.append(tuple(map(int, re.search("\|CDS:(.+?)\|", i).group(1).split('-'))))

# Extract CDS region of each transcript
gc_cds_seq = {key: value[i-1:j] for (key, value) in seq.items() for i,j in cds_region}
gc_cds_seq = {key: gc_content(value) for (key, value) in gc_cds_seq.items()}

for key,value in gc_cds_seq.items():
	gc_gene[key.split('|')[1]].append(value)

gc_gene = {key: np.mean(value) for (key, value) in gc_gene.items()}

with open('gene_gc_content.txt', 'w') as f:
    for (key,value) in gc_gene.items():
        f.write('\t'.join(key.split('_')) + '\t' + str(value) + '\n')
