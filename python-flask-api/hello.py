from flask import Flask, jsonify

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

tasks = [
    {
        'id': 1,
        'title': '日用品を買ってくる',
        'description': 'ミルク、チーズ、ピザ、フルーツ',
        'done': False
    },
    {
        'id': 2,
        'title': 'Python の勉強',
        'description': 'Python で Restful API を作る',
        'done': False
    }
]

@app.route('/')
def hello_world():
    return jsonify({'tasks': tasks})

if __name__ == '__main__':
    app.run(debug=False, host="0.0.0.0", port=5000)