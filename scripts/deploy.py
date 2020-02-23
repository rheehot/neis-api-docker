import os
import subprocess

DOCKER_HUB_ID = os.environ["DOCKER_HUB_ID"]
DOCKER_HUB_PW = os.environ["DOCKER_HUB_PW"]
DEPOLY_CMD = os.environ["DEPOLY_CMD"]

login_cmd = "docker login -u " + DOCKER_HUB_ID + " -p " + DOCKER_HUB_PW
build_cmd = "docker build -t ilcm96/neis-api:latest ."
push_cmd = "docker push ilcm96/neis-api:latest"
deploy_cmd = str(DEPOLY_CMD)

subprocess.call(login_cmd, shell=True)
subprocess.call(build_cmd, shell=True)
subprocess.call(push_cmd, shell=True)
subprocess.call(deploy_cmd, shell=True)
