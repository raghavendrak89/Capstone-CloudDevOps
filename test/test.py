#imports
import requests

def main():
    r = requests.get("http://localhost:8885/health")
    if r.status_code == 200:
        return 'Hello'

if __name__ == '__main__':
    main()
