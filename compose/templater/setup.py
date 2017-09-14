from distutils.core import setup
setup(name='templater',
      version='1.0',
      py_modules=['templater'],
      install_requires=[
          'yaml',
          're',
      ],
      )
