from lesson_02.job1.dal import local_disk, sales_api
import os
import time
import requests


AUTH_TOKEN = os.environ.get("AUTH_TOKEN")
BASE_DIR = os.environ.get("BASE_DIR")


def save_sales_to_local_disk(date: str, raw_dir: str) -> None:
    # 1. get data from the API
    # 2. save data to disk
    print("\tI'm in get_sales(...) function!")
    json_content = sales_api.get_sales(date)
    local_disk.save_to_disk(json_content, raw_dir)

    print("Files is saved!")
    pass


if __name__ == '__main__':
    save_sales_to_local_disk('2022-08-09', BASE_DIR)
