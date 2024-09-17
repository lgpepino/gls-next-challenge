In this folder we will find the code related to the application itself.

How to run code locally

Pre requisites:

Docker
Python 3
Flask
Libraries from requirements.txt

How to create/update requirements.txt

pip3 freeze > requirements.txt

If you are using MacOS, please remove this line from the requirements.txt file:

wheel @ SOME_TEXT

How to run code locally

Using Python:

python3 -m pip install --upgrade pip
python3 -m pip install virtualenv
python3 -m venv gls-next
source gls-next/bin/activate
pip install Flask
pip install -r requirements.txt
python3 app.py
Access http://127.0.0.1:5000/status to get the Hello Word endpoint message

Using Docker

docker build -t image_name .
docker run -p 5001:5001 image_name