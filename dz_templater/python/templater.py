import yaml
import re
import sys
import glob

pattern = '\({2}.*?\){2}'

def yaml_to_dict(path):
    dataMap = {}
    for filename in glob.glob(path):
        with open(filename, 'r') as f:
            dataMap.update(yaml.safe_load(f))
    return dataMap

def file_to_string(path):
    data = ""
    with open (path, "r") as myfile:
        data=myfile.read()
    return data

def find_and_replace(inp, inp_dict):
    new_data = re.sub(pattern, lambda x : inp_dict.get(x.group().strip().strip("()"), x.group()), inp)
    return new_data

def replace(inp_path, properties_path):
    my_dict = yaml_to_dict(properties_path)
    my_data = file_to_string(inp_path)
    new_data = find_and_replace(my_data, my_dict)
    return new_data

if __name__ == '__main__':
    print(replace(sys.argv[1], sys.argv[2]))
