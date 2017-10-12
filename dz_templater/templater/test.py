import templater
import filecmp
import unittest


def compare_files(input_path, input_properties, verifier):
    original_data = templater.file_to_string(input_path)
    out = templater.replace(input_path, input_properties)  #do the template replacement
    result = False
    if (out == templater.file_to_string(verifier)): #compare file to expected val
        result = True
    return result

class TestFileOutput(unittest.TestCase):

    def test_file_output(self):
        self.assertTrue(compare_files('test_1.txt', 'test_1*.yml', 'test_1_verification.txt'))
        self.assertTrue(compare_files('test_2.txt', 'test_2.yml', 'test_2_verification.txt'))

if __name__ == '__main__':
    unittest.main()
