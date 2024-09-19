# How to run code locally

### Additional Pre-requisites:

The addiotional pre-requisites will be installed when we will run the application locally

| Library | How to install |
|---------|----------------| 
| Flask   | [here](https://github.com/lgpepino/gls-next-challenge/blob/develop/code/README.md?plain=1#L44)               |
| requirements.txt | [here](https://github.com/lgpepino/gls-next-challenge/blob/develop/code/README.md?plain=1#L45)      |

### How to create/update requirements.txt

This file contains all the libraries we need to execute our python application.

If you update the app with new libraries you need to recreate the file

```bash
pip3 freeze > requirements.txt
```

If you are using MacOS, please remove this line from the requirements.txt file:

```text
wheel @ SOME_TEXT
```

## How to run code locally

### Attention!

Please check if you running only one instance of the application (Python or Docker) to avoid problems with the app port in use.

If you need to run more then one instance, please change the app code to use another port.

### Using Python:

Starting the application:
```bash
python3 -m pip install --upgrade pip
python3 -m pip install virtualenv
python3 -m venv gls-next
source gls-next/bin/activate
pip install Flask
pip install -r requirements.txt
python3 app.py
```
Access http://127.0.0.1:5001/ to get the Hello Word endpoint message

Stopping the application:
```bash
Press control + C
deactivate
```

### Using Docker

- If you need to test a new image before push the code changes to the repository, you can build a image locally
- Start Docker in your machine
- Build the image
```bash
cd ..
docker build -t local_container_python .
```
- Execute the image:
```bash
docker run -p 5001:5001 local_container_python
```
Access http://127.0.0.1:5001/ to get the Hello World endpoint message