from typing import List, Dict, Any
import os
import json


BASE_DIR = os.environ.get("BASE_DIR")


def save_to_disk(json_content: List[Dict[str, Any]], path: str) -> None:
    date = json_content[0]
    for i in range(1, len(json_content)):
        file_to_write = json_content[i]
        with open(f"{path}/sales_{date}_{i+1}.json", "w+") as f:
            json.dump(file_to_write, f)
    return None


if __name__ == '__main__':
    save_to_disk(object_to_write, BASE_DIR)