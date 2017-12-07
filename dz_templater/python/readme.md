How-To:
=====

First install Pyyaml:
`pip install pyyaml`

To run from the cmd line:
`python3 python/templater.py input_file properties_file`

To use in your own project, import:

`import templater`

To use the templater module simply do:

`templater.replace(input_file, properties_file)`

Where `input_file` is the path to the file that needs replacements and `properties_file` is the path to the file storing the dictionary in yaml format.

What it Does:
=============

Python Templater replaces keys or tags surrounded by (( )) with their corresponding value which is found in .yaml file. There is no support for nested tags or yaml at this time.

Example:

Let the following be a dictionary defined by a yaml file:

```
my-credentials: foo
my-name: bar
```
Let the following be an input file:

```
hello world!
I am a walrus!
My name is ((my-name)) and I love to tell everyone my password which is ((my-credentials))
This ((key)) is not found in the dictionary so it is ignored.
```

Then the output after running the replace function is:

```
hello world!
I am a walrus!
My name is bar and I love to tell everyone my password which is foo
This ((key)) is not found in the dictionary so it is ignored.
```
