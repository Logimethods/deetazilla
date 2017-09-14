import yaml
import re


pattern = '\({2}.*?\){2}'

def yaml_to_dict(path):
    dataMap = {}
    with open(path) as f:
        dataMap = yaml.safe_load(f)
    return dataMap

def file_to_string(path):
    data = ""
    with open (path, "r") as myfile:
        data=myfile.read()
    return data

def find_and_replace(inp, inp_dict):
    new_data = re.sub(pattern, lambda x : inp_dict[x.group().strip().strip("()")], inp)
    return new_data

def replace(inp_path, properties_path):
    my_dict = yaml_to_dict(properties_path)
    my_data = file_to_string(inp_path)
    new_data = find_and_replace(my_data, my_dict)
    with open(inp_path, 'w') as f:
        f.write(new_data)
