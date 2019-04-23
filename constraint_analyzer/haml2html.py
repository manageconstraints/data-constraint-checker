from urllib.parse import urlencode
from urllib.request import Request, urlopen
from bs4 import BeautifulSoup
import sys

def haml2html(file):
    f = open(file, 'r')
    c = f.read()

    url = 'https://haml2erb.org/' # Set destination URL here
    post_fields = {'haml': c, 'converter': 'herbalizer'}     # Set POST fields here
    
    request = Request(url, urlencode(post_fields).encode())
    json = urlopen(request).read().decode()
    soup = BeautifulSoup(json,"html.parser")
    tag = soup.find(id = 'erb')
    #print("results")
    print(tag.string)
    #print("results finished")
def main():
    filename = sys.argv[1]
    haml2html(filename)
    
if __name__ == '__main__':
    main()
