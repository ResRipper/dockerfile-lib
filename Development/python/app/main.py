import requests

if __name__ == '__main__':
    print('Hello')
    print(requests.get('https://api.github.com/zen').text)