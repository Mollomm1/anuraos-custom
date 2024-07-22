import json
from glob import glob

def edit_json(file_path, changes):
    with open(file_path, 'r') as f:
        data = json.load(f)

    for key, value in changes.items():
        if key == "apps":
            if isinstance(value, list):
                data[key] = data[key] + value
            else:
                data[key] = [value] + data[key]
        else:
            data[key] = value

    with open(file_path, 'w') as f:
        json.dump(data, f, indent=4)

changes = {
    "apps": [],
}

customapps = glob("../CustomApps/*", recursive=False)
for i in customapps:
    changes["apps"].append(i.replace("../CustomApps/", "apps/"))

edit_json('./static_version/config.json', changes)