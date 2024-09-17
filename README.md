Code challenge for GLS-NEXT

The documentation about how to run this application is separeted in different files with a detailed instructions and explanation of the design.

Pipeline:

In this case, I'm using ngithub workflows to perform the CI/CD of the application.

In this case, I prefer to use the solution provided by Github, since the integration from the code with cd workflow is easier.

Also, the tool provide the possiblity to build, deploy and check the status of the application after the deployment.

The images built in the pipeline will be stored in a Dockerhub repository. To authenticate in Dockerhub, a step where created in pipeline, and the username and password are stored in secrets area of the project, to don't hardcode sensitive information in the code.
