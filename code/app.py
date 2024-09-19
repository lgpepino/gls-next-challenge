from flask import Flask

app = Flask(__name__)

@app.route('/')
def get_status():
        return f'Hello World, the app is Running'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)