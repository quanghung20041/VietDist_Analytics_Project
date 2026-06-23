import uuid
import time
import sys
import pandas as pd

sys.path.append('./01_ingestion')

from utils.db_utils import (
    add_metadata,
    load_to_bronze,
    get_engine
)

from sqlalchemy import text

DATA_FOLDER = r"C:\Users\Admin\Downloads\Final_Project\VietDist_Analytics_Project\VietDist_DataSouces"

FILE_NAME = 'SRC07_employee_master.xlsx'

TABLE_NAME = 'employee_master'


def run():

    batch_id = str(uuid.uuid4())

    start = time.time()

    engine = get_engine()

    total_loaded = 0

    try:

        file_path = DATA_FOLDER + "\\" + FILE_NAME

        print(f'\nReading file: {FILE_NAME}')

        excel_file = pd.ExcelFile(file_path)

        print(f'Sheets found: {excel_file.sheet_names}')


        for sheet_name in excel_file.sheet_names:

            if sheet_name == 'Change_Log':

                print(f'Skipping sheet: {sheet_name}')

                continue


            print(f'\nProcessing sheet: {sheet_name}')

            df = pd.read_excel(

                file_path,

                sheet_name=sheet_name

            )

            print(f'Rows found: {len(df)}')

            df = add_metadata(

                df,

                FILE_NAME,

                'local',

                batch_id

            )

            rows = load_to_bronze(

                df,

                TABLE_NAME,

                if_exists='append'

            )

            total_loaded += rows

            print(f'OK: {sheet_name} — {rows} rows loaded')

        with engine.begin() as conn:

            conn.execute(text(

                'INSERT INTO raw.ingest_log ('
                'batch_id, source_name, source_file, '
                'source_platform, rows_loaded, '
                'status, duration_sec) '

                'VALUES ('
                ':bid, :sn, :sf, '
                ':sp, :rl, '
                ':st, :dur)'

            ), dict(

                bid=batch_id,

                sn=TABLE_NAME,

                sf=FILE_NAME,

                sp='local',

                rl=total_loaded,

                st='SUCCESS',

                dur=round(time.time() - start, 2)

            ))


    except Exception as e:

        print(f'ERROR: {FILE_NAME} — {e}')

        with engine.begin() as conn:

            conn.execute(text(

                'INSERT INTO raw.ingest_log ('
                'batch_id, source_name, source_file, '
                'source_platform, rows_loaded, '
                'status, error_message, duration_sec) '

                'VALUES ('
                ':bid, :sn, :sf, '
                ':sp, :rl, '
                ':st, :err, :dur)'

            ), dict(

                bid=batch_id,

                sn=TABLE_NAME,

                sf=FILE_NAME,

                sp='local',

                rl=0,

                st='FAILED',

                err=str(e),

                dur=round(time.time() - start, 2)

            ))


    print(f'\nTotal loaded: {total_loaded} rows')


if __name__ == '__main__':

    run()
