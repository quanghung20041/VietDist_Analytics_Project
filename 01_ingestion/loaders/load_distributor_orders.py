import uuid
import time
import sys

sys.path.append('./01_ingestion')

from utils.file_parser import parse_file

from utils.db_utils import (
    add_metadata,
    load_to_bronze,
    get_engine
)

from sqlalchemy import text

# LẤY URL VÀ TÊN FILE

DATA_FOLDER = r"C:\Users\Admin\Downloads\Final_Project\VietDist_Analytics_Project\VietDist_DataSouces"

FILE_NAME = 'SRC05_distributor_orders.xlsx'

TABLE_NAME = 'distributor_orders'


# CHẠY HÀM

def run():

    batch_id = str(uuid.uuid4())

    start = time.time()

    engine = get_engine()

    total_loaded = 0

    try:

        file_path = DATA_FOLDER + "\\" + FILE_NAME

        print(f'\nReading file: {FILE_NAME}')


        df = parse_file(file_path)

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

        print(f'OK: {FILE_NAME} — {rows} rows loaded')

        # GHI LOG THÀNH CÔNG

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

        # GHI LOG LỖI

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

