import sys

# Define the path to your original PDB file
original_pdb_path = sys.argv[1]
# Define the path for the modified PDB file
modified_pdb_path = sys.argv[2]

# Function to modify chain identifiers
def modify_chains(original_pdb_path, modified_pdb_path):
    with open(original_pdb_path, 'r') as file:
        lines = file.readlines()

    # Initialize a variable to keep track of TER cards encountered
    ter_count = 0
    for i, line in enumerate(lines):
        if line.startswith("TER"):
            ter_count += 1
            continue

        # If the line represents an atom and is before the first TER, change the chain to 'A'
        if line.startswith("ATOM") and ter_count == 0:
            lines[i] = line[:21] + 'A' + line[22:]

        # If the line represents an atom and is after the first TER, change the chain to 'B'
        if line.startswith("ATOM") and ter_count >= 1:
            lines[i] = line[:21] + 'B' + line[22:]

    with open(modified_pdb_path, 'w') as file:
        file.writelines(lines)

# Call the function with your file paths
modify_chains(original_pdb_path, modified_pdb_path)

