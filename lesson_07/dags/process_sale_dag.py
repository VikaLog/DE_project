from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
import sys
sys.path.insert(1, '/Users/MSI/PycharmProjects/DE_project/')

import lesson_02.job1
import lesson_02.job2


DEFAULT_ARGS = {
    'depends_on_past': False,
    'email': ['admin@example.com'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': 30,
}

dag = DAG(
    dag_id='process_sale_dag',
    start_date=datetime(2022, 8, 9),
    end_date=datetime(2022, 8, 11),
    schedule_interval="0 1 * * *",
    catchup=True,
    default_args=DEFAULT_ARGS,
    max_active_runs=1,
)

extract_data_from_api = PythonOperator(
    task_id='extract_data_from_api',
    dag=dag,
    python_callable=lesson_02.job1.main,
)

convert_to_avro = PythonOperator(
    task_id='convert_to_avro',
    dag=dag,
    python_callable=lesson_02.job1.main,
)


extract_data_from_api >> convert_to_avro
