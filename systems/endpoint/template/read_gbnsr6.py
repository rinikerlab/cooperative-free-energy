import numpy as np
import sys

in_file  = sys.argv[1]
out_file = sys.argv[2]

# Read the data from the file
with open(in_file, 'r') as file:
    # Initialize an empty list to store matrix elements
    matrix_elements = []

    # Iterate through each line in the file
    for line in file:
        # Check if the line contains the "DG" pattern
        if line.startswith("DG"):
            # Split the line into values
            parts = line.split()

            # Extract i, j, and E values
            i = int(parts[1])
            j = int(parts[2])
            E = float(parts[3])

            # Append the tuple (i, j, E) to the list
            matrix_elements.append((i, j, E))

# Determine the matrix size
matrix_size = max(max(i, j) for i, j, _ in matrix_elements)

# Create a NumPy array filled with zeros
matrix_array = np.zeros((matrix_size, matrix_size))

# Fill the array with the values from the list
for i, j, E in matrix_elements:
    matrix_array[i - 1, j - 1] = E
    matrix_array[j - 1, i - 1] = E

# Print or manipulate the NumPy array as needed
np.save(out_file,matrix_array)
