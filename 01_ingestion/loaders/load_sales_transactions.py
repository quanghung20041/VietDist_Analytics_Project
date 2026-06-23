import sys
import uuid
import time

sys.path.append("./01_ingestion")

from utils.file_parser import parse_file
from utils.db_utils import (
    add_metadata,
    load_to_bronze,
    get_engine
)

from sqlalchemy import text


DATA_FOLDER = r"C:\Users\Admin\Downloads\Final_Project\VietDist_Analytics_Project\VietDist_DataSouces"

FILE_NAME = "SRC01_sales_transactions.csv"

TABLE_NAME = "sales_transactions"


def run():

    batch_id = str(uuid.uuid4())

    start = time.time()

    engine = get_engine()

    try:

        file_path = DATA_FOLDER + "\\" + FILE_NAME

        print(f"Reading file: {FILE_NAME}")

        df = parse_file(file_path)

        print(f"Rows found: {len(df)}")

        df = add_metadata(
            df,
            source_file=FILE_NAME,
            source_platform="local",
            batch_id=batch_id
        )

        rows = load_to_bronze(
            df,
            table_name=TABLE_NAME
        )

        duration = round(
            time.time() - start,
            2
        )

        with engine.begin() as conn:

            conn.execute(text("""

                INSERT INTO raw.ingest_log (

                    batch_id,
                    source_name,
                    source_file,
                    source_platform,
                    rows_loaded,
                    status,
                    duration_sec

                )

                VALUES (

                    :batch_id,
                    :source_name,
                    :source_file,
                    :source_platform,
                    :rows_loaded,
                    :status,
                    :duration_sec

                )

            """), {

                "batch_id": batch_id,
                "source_name": TABLE_NAME,
                "source_file": FILE_NAME,
                "source_platform": "local",
                "rows_loaded": rows,
                "status": "SUCCESS",
                "duration_sec": duration

            })

        print(f"{rows} rows loaded successfully!")

    except Exception as e:

        print(f"ERROR: {e}")


if __name__ == "__main__":

    run()