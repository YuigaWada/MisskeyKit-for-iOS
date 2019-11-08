# MIT License
#
# Copyright (c) 2019 YuigaWada
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


#   **   Markdown Api Document Generator   **   #


import urllib.request
import json
import re
import glob
import os

from urllib.parse import urlparse

dirname = os.path.dirname(os.path.abspath(__file__)).replace('python_utls','')
pattern = re.compile('func ([^\\(]+)\\([^\)]+\\)( )*\\{([^\\}])*handleAPI\\(.*api:( )*"(.+)"([^\\}]+)\\}') # target: group1 / group5

def search_api(api_methods, class_name, text):
    for method_name, _, _,_, api_name, _ in pattern.findall(text):
        method_name = class_name + '.' + method_name

        if not api_name in api_methods:
            api_methods[api_name] = []

        if not method_name in api_methods[api_name]:
            api_methods[api_name].append(method_name)


def get_contents(path):
    with open(path) as file:
        return file.read()

def get_all_file_paths():
    return glob.glob(dirname + "/MisskeyKit/APIs/Wrapper/*/*.swift")

def generate_markdown(api_methods):
    markdown = '|Misskey API|MisskeyKit Methods|\n|---|---|\n'

    for api_name, methods in api_methods.items():
        markdown += '|{}|{}|\n'.format(api_name, ', '.join(methods))

    return markdown

def save(text):
    with open(dirname + 'python_utls/output.md', mode='w') as file:
        file.write(text)



def main():
    api_methods = {} # api : methods
    all_file_path = get_all_file_paths()

    for file_path in all_file_path:
        class_name = os.path.basename(file_path)[:-6]
        contents = get_contents(file_path)

        search_api(api_methods, class_name, contents)

    markdown = generate_markdown(api_methods)
    save(markdown)

main()
print("\nsuccess!\n")
