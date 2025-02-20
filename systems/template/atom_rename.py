

import sys

template_atom=sys.argv[1]  #right atom name
template_corr=sys.argv[2]  #right coordinate

atom_name=[]

out=''.join([template_corr.split('.pdb')[0],'_renamed.pdb'])

with open(template_atom,'r') as read:
    for line in read:
        if 'ATOM' in line:
            atom_name.append(line[12:21])
print(len(atom_name))


i=0
with open(out,'w') as write:
    with open(template_corr,'r') as read:
        for line in read:
            if 'HETATM' in line or 'ATOM' in line:
                new_line=line.replace(line[12:21],atom_name[i])
                new_line=new_line.replace('HETATM','ATOM  ')
                i=i+1
                print(new_line,file=write,end='')
