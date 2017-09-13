import templater
import filecmp

def test(input_path, input_properties, verifier):
    original_data = templater.file_to_string(input_path)
    templater.replace(input_path, input_properties)  #do the template replacement
    result = "Failed."
    if (filecmp.cmp(input_path, verifier)): #compare file to expected val
        result = "Success!"
    with open(input_path, 'w') as f:
        f.write(original_data) #rewrite original data to retest
    return result

print("Test case 1: "+test('test_1.txt', 'test_1.yml', 'test_1_verification.txt'))
print("Test case 2: "+test('test_2.txt', 'test_2.yml', 'test_2_verification.txt'))
#print("Test case 3: "+test('test_3.txt', 'test_3.yml', 'test_3_verification.txt'))  ---doesnt exist yet
