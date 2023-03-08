"""
Enrich_user_profiles processing pipeline
"""
import datetime as dt

from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator


DEFAULT_ARGS = {
    'depends_on_past': True,
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': 5,
}

dag = DAG(
    dag_id="enrich_user_profiles_pipeline_dag",
    description="Ingest and process sales data",
    schedule_interval=None,
    start_date=dt.datetime(2022, 9, 1),
    catchup=True,
    tags=['enrich_user_profiles'],
    default_args=DEFAULT_ARGS,
)

dag.doc_md = __doc__


transfer_from_dwh_silver_to_dwh_gold = BigQueryInsertJobOperator(
    task_id='transfer_from_dwh_silver_to_dwh_gold',
    dag=dag,
    location='us-east1',
    project_id='de-07-logvinova-viktoriia',
    configuration={
        "query": {
            "query": "{% include 'sql/transfer_from_dwh_silver_to_dwh_gold.sql' %}",
            "useLegacySql": False,
        }
    },
    params={
        'project_id': "de-07-logvinova-viktoriia"
    }
)

transfer_from_dwh_silver_to_dwh_gold
