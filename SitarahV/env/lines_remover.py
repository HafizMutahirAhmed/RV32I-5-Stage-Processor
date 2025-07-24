import sys

if len(sys.argv) != 2:
    print("Usage: python script.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

try:
    with open(filename, 'r') as file:
        lines = file.readlines()

    # Remove the last 4 lines
    updated_lines = lines[:-4]

    with open(filename, 'w') as file:
        file.writelines(updated_lines)

    print(f"Removed last 4 lines from {filename}")
except FileNotFoundError:
    print(f"File not found: {filename}")
except Exception as e:
    print(f"An error occurred: {e}")
