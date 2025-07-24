import sys

def keep_first_n_lines(filename, n):
    with open(filename, 'r') as file:
        lines = file.readlines()

    total_lines = len(lines)
    lines_to_keep = lines[:n]

    with open(filename, 'w') as file:
        file.writelines(lines_to_keep)

    print(f"Kept the first {min(n, total_lines)} lines. Original had {total_lines} lines.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python keep_first_lines.py <filename>")
    else:
        keep_first_n_lines(sys.argv[1], 36)
