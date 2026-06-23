# load_sales_targets.py

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

FILE_NAME = 'SRC02_sales_target_plan.xlsx'

TABLE_NAME = 'sales_target_versions'

def run():

    batch_id = str(uuid.uuid4())

    start = time.time()

    engine = get_engine()

    total_loaded = 0

    try:

        file_path = DATA_FOLDER + "\\" + FILE_NAME

        print(f'\nReading workbook: {FILE_NAME}')

        sheets = pd.read_excel(

            file_path,

            sheet_name=None

        )

        print(f'Sheets found: {list(sheets.keys())}')

        for sheet_name, df in sheets.items():


            if not sheet_name.lower().startswith('plan'):

                print(f'Skipping sheet: {sheet_name}')

                continue

            print(f'\nProcessing version: {sheet_name}')

            print(f'Rows found: {len(df)}')
        
            df = df.dropna(how='all')

            df = add_metadata(

                df,

                FILE_NAME,

                'local',

                batch_id

            )

            df['version_label'] = sheet_name

            for col in df.columns:

                df[col] = df[col].astype(str)

            rows = load_to_bronze(

                df,

                TABLE_NAME,

                if_exists='append'

            )

            total_loaded += rows

            print(

                f'OK: {sheet_name} — {rows} rows loaded'

            )

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

                    rl=rows,

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

