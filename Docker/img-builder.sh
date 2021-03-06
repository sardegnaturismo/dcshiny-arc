#!/bin/bash -ex

CONFIG_FILENAME="prod.config"


# Setting defaults


if [ -z $AWS_REGION ]
then
  echo
  echo "No REGION set, using default eu-west-1"
  echo
  AWS_REGION="eu-west-1"
fi

if [ -z $AWS_PROFILE ]
then
  echo
  echo "No PROFILE set, using default from .aws/credentials"
  echo
fi

function Usage()
{

echo "Usage: `imd-builder $0` options (-d)"
echo 
echo "-r : repository URI"
echo "-t : container IMAGE_TAG"
echo "-d : container DOCKER_ROOT"
echo "-c : clear build cache before building"
echo "-C : environment configuration filename"
echo "-v : version"
echo "-h : help"
echo

exit;
}

function Version()
{
  echo "`base IMAGE_TAG $0` version $VERSION"
  exit;
}

while getopts "r:t:d:c:C:vh" Option
do
  case $Option in
   r )
       REPOSITORY_URI=$OPTARG
       ;;
   t )
       IMAGE_TAG=$OPTARG
       ;;
   d )
       DOCKER_ROOT=$OPTARG
       ;;
   c )
       NO_CACHE="--no-cache"
       ;; 
   C )
       CONFIG_FILENAME=$OPTARG
       ;;
   v )
       Version
       exit
       ;;
   h )
       Usage
       exit
       ;;
   * )
       Usage
       exit;
       ;;
  esac
done


# Reads config file

if [ ! -f ${CONFIG_FILENAME}  ]; then
    echo "Config file not found, exiting ..."
    exit;
else
    eval $(cat ${CONFIG_FILENAME})
fi


# Domain 

if [ -z $REPOSITORY_URI ]
then
  echo
  echo "No Repository URI specified, exiting"
  echo
  exit;
fi

if [ -z $IMAGE_TAG ]
then
  echo
  echo "Please enter Docker Image tag, exiting "
  echo
  exit;
fi

if [ -z $DOCKER_ROOT ]
then
  echo
  echo "DOCKER_ROOT empty, building Dockerfile on current directory"
  echo
  DOCKER_ROOT="."
fi


echo $CONFIG_FILENAME
# Login, build tag and push on ECR registry


aws ecr get-login --no-include-email --region ${AWS_REGION} --profile ${AWS_PROFILE}| sh

echo "docker build ${NO_CACHE} -t ${IMAGE_TAG}:${IMAGE_TAG} ${DOCKER_ROOT}"

docker build -t ${IMAGE_TAG}:${IMAGE_TAG} ${DOCKER_ROOT}


docker tag ${IMAGE_TAG}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}
docker push ${REPOSITORY_URI}:${IMAGE_TAG}
