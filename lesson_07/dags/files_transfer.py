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
    end_date=datetime(2022, 8, 3),
    schedule_interval="0 0 * * *",
    catchup=True,
    default_args=DEFAULT_ARGS,
    max_active_runs=1,
)


# copy_file = LocalFilesystemToGCSOperator(
#     task_id='copy_file',
#     dag=dag,
#     src="/Users/MSI/PycharmProjects/DE_project/lesson_10/sales/2022-08-02/*.csv",
#     dst="scr1/",
#     bucket='de07_bucket_02_01_2023',
#     gcp_conn_id='de-07-logvinova-viktoriia',
# )


task1 = EmptyOperator(
    task_id='task1',
    dag=dag,
)

task2 = EmptyOperator(
    task_id='task2',
    dag=dag,
)

task1 >> task2