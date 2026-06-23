import os
import uuid

import pandas as pd

from dotenv import load_dotenv

from sqlalchemy import create_engine
from sqlalchemy.types import TEXT


load_dotenv()


def get_engine():

    db_host = os.getenv("DB_HOST")
    db_port = os.getenv("DB_PORT")
    db_name = os.getenv("DB_NAME")
    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")

    connection_string = (
        f"postgresql+psycopg2://"
        f"{db_user}:{db_password}"
        f"@{db_host}:{db_port}/{db_name}"
    )

    engine = create_engine(connection_string)

    return engine


def add_metadata(
    df,
    source_file,
    source_platform,
    batch_id=None
):

    if batch_id is None:
        batch_id = str(uuid.uuid4())

    df["_source_file"] = source_file

    df["_source_platform"] = source_platform

    df["_batch_id"] = batch_id

    df["_ingested_at"] = pd.Timestamp.now()

    return df


def convert_all_to_text(df):

    for col in df.columns:

        df[col] = df[col].astype(str)

    return df


def load_to_bronze(
    df,
    table_name,
    schema='raw',
    if_exists='append'
):

    engine = get_engine()

    df = convert_all_to_text(df)

    dtype_mapping = {
        col: TEXT()
        for col in df.columns
    }

    df.to_sql(
        name=table_name,
        con=engine,
        schema=schema,
        if_exists=if_exists,
        index=False,
        dtype=dtype_mapping
    )

    return len(df)