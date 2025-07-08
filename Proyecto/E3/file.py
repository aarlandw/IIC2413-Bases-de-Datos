#  help me convert xlsx file to csv file
import pandas as pd
def convert_xlsx_to_csv(xlsx_file, csv_file):
    """
    Convert an Excel file to a CSV file.

    :param xlsx_file: Path to the input Excel file.
    :param csv_file: Path to the output CSV file.
    """
    try:
        # Read the Excel file
        df = pd.read_excel(xlsx_file)

        # Write to CSV file
        df.to_csv(csv_file, index=False)
        print(f"Successfully converted {xlsx_file} to {csv_file}")
    except Exception as e:
        print(f"Error converting file: {e}")

if __name__ == "__main__":
    # Example usage
    convert_xlsx_to_csv('viajeros.xlsx', 'viajeros.csv')