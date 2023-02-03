

from airflow import DAG

from datetime import datetime

from airflow.operators.empty import EmptyOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator


DEFAULT_ARGS = {
    'depends_on_past': False,
    'email': ['admin@example.com'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': 30,
}


dag = DAG(
    dag_id="files_transfer",
    start_date=datetime(2022, 8, 1),
    end_date=datetime(2022, 8, 2),
    schedule_interval="0 0 * * *",
    catchup=True,
    default_args=DEFAULT_ARGS,
)


copy_file = LocalFilesystemToGCSOperator(
    task_id='copy_file',
    dag=dag,
    src="/Users/MSI/PycharmProjects/DE_project/lesson_10/sales/{{ ds }}/*.csv",
    dst="scr1/sales/v1/{{ macros.ds_format(ds,'%Y-%m-%d' ,'%Y/%m/%d') }}/",
    bucket='de07_bucket_02_01_2023',
)


task1 = EmptyOperator(
    task_id='task1',
    dag=dag,
)


task1 >> copy_file
