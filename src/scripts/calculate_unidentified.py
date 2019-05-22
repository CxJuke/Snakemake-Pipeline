import csv

def get_total(infile):
    with open(infile, "r") as f:
        lines = 0
        for line in f:
            if line.strip():
                lines += 1
        
        lines -= 1
        f.close()
    return lines

def read_int_from_file(file):
    with open(file, r) as f:
        out = f.readline(0)
        f.close()
    return int(out)

def write_as_csv(outfile, total, total_alligned):
    with open(outfile, 'w') as csvfile:
        filewriter = csv.writer(csvfile, delimiter=',', quotechar="@", quoting=csv.QUOTE_MINIMAL)
        filewriter.writerow(['total_bp', 'total_alligned_bp', 'unidentified_bp'])
        unidentified = total - total_alligned
        filewriter.writerow([total, total_alligned, unidentified])


def main():
    total_alligned = get_total(snakemake.input[0])
    total = read_int_from_file(snakemake.input[1])
    write_as_csv(snakemake.output[0], total, total_alligned)

if __name__ == "__main__":
    main()



