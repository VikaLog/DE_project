"""
Sales processing pipeline
"""
import datetime as dt

from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

from table_defs.sales_csv import sales_csv


DEFAULT_ARGS = {
    'depends_on_past': True,
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': 5,
}

dag = DAG(
    dag_id="sales_pipeline_dag",
    description="Ingest and process sales data",
    schedule_interval='0 7 * * *',
    start_date=dt.datetime(2022, 9, 1),
    end_date=dt.datetime(2022, 10, 1),
    catchup=True,
    tags=['sales'],
    default_args=DEFAULT_ARGS,
)

dag.doc_md = __doc__


transfer_from_data_lake_to_raw = BigQueryInsertJobOperator(
    task_id='transfer_from_data_lake_to_raw',
    dag=dag,
    location='us-east1',
    project_id='de-07-logvinova-viktoriia',
    configuration={
        "query": {
            "query": "{% include 'sql/transfer_from_data_lake_raw_to_bronze.sql' %}",
            "useLegacySql": False,
            "tableDefinitions": {
                "sales_csv": sales_csv,
            },
        }
    },
    params={
        'data_lake_raw_bucket': "de07_final_project_bucket_05_03_2023",
        'project_id': "de-07-logvinova-viktoriia"
    }
)

transfer_from_dwh_bronze_to_dwh_silver = BigQueryInsertJobOperator(
    task_id='transfer_from_dwh_bronze_to_dwh_silver',
    dag=dag,
    location='us-east1',
    project_id='de-07-logvinova-viktoriia',
    configuration={
        "query": {
            "query": "{% include 'sql/transfer_from_dwh_bronze_to_dwh_silver.sql' %}",
            "useLegacySql": False,
        }
    },
    params={
        'project_id': "de-07-logvinova-viktoriia"
    }
)

transfer_from_data_lake_to_raw >> transfer_from_dwh_bronze_to_dwh_silver
