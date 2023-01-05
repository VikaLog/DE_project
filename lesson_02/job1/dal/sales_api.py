from typing import List, Dict, Any
import os
import requests
import itertools
import json

API_URL = 'https://fake-api-vycpfa6oca-uc.a.run.app/sales'
AUTH_TOKEN = os.environ.get("AUTH_TOKEN")


def get_sales(date: str) -> List[Dict[str, Any]]:
    """
    Get data from sales API for specified date.
    :param date: data retrieve the data from
    :return: list of records
    """
    # TODO: implement me
    full_data = [date]
    for p in itertools.count(start=0):
        p += 1
        response = requests.get(
            url=API_URL,
            params={'date': date, 'page': p},
            headers={'Authorization': AUTH_TOKEN},
        )
        if response.status_code == 200:
            data = response.json()
            full_data.append(data)
        else:
            print(response.text)
            break
    return full_data


if __name__ == '__main__':
    get_sales('2022-08-09')
