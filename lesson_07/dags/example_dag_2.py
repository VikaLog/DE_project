from airflow import DAG
from airflow.models import Variable

from datetime import datetime

from airflow.operators.email import EmailOperator
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator


# never use it!
# my_var = Variable.get("my_var")
# print(my_var)


dag = DAG(
    dag_id="example_dag_2",
    start_date=datetime(2022, 9, 16),
    schedule_interval=None,
    catchup=True,
)

copy_file = GCSToGCSOperator(
    task_id='copy_file',
    dag=dag,
    source_bucket='my-bucket-de2022',
    source_object='sales.csv',
    destination_bucket='my-bucket-de2022',
    destination_object='new_folder/sales_{{ ds }}.csv',
)

run_bigquery_job = BigQueryInsertJobOperator(
    task_id='run_bigquery_job',
    dag=dag,
    location='us-east1',
    project_id='de2022-robot-dreams',
    configuration={
        "query": {
            "query": "{% include 'sql/select_42.sql' %}",
            "useLegacySql": False,
        }
    },
    params={
        'x': 42
    }
)

send_success_email = EmailOperator(
    task_id='send_success_email',
    dag=dag,
    to='boss@example.com',
    subject='Data pipeline finished successfully!',
    html_content="<b>Success!</b>"
)


copy_file >> run_bigquery_job >> send_success_email

