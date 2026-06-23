import pandas as pd
from pathlib import Path


def read_csv_file(file_path):

    encodings = ['utf-8', 'utf-8-sig', 'cp1258']

    for encoding in encodings:

        try:
            df = pd.read_csv(
                file_path,
                encoding=encoding
            )

            print(f"CSV loaded with encoding: {encoding}")

            return df

        except UnicodeDecodeError:
            continue

    raise ValueError(
        f"Cannot decode CSV file: {file_path}"
    )


def read_excel_file(file_path):

    df = pd.read_excel(file_path)

    return df


def parse_file(file_path):

    file_path = Path(file_path)

    extension = file_path.suffix.lower()

    if extension == '.csv':

        return read_csv_file(file_path)

    elif extension in ['.xlsx', '.xlsm']:

        return read_excel_file(file_path)

    else:

        raise ValueError(
            f"Unsupported file type: {extension}"
        )