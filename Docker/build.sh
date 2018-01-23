#!/bin/bash
DEFAULT_ENV="local"
DEFAULT_PRJ="shinydash"
DEFAULT_ECR_REPO="064484720015.dkr.ecr.eu-west-1.amazonaws.com/$DEFAULT_ENV-$DEFAULT_PRJ"
DEFAULT_GIT_PATH="shiny-server/DO_shiny"
DEFAULT_CONTAINER_NAME="worker"

echo "repo : $DEFAULT_ECR_REPO"
function Usage()
{

echo "Usage: `basename $0` options (-d)"
echo 
echo "-e : environment (default to local)"
echo "-r : repository"
echo "-c : container name"
echo "-p : project name"
echo "-v : version"
echo "-h : help"
echo

exit;
}

function Version()
{
  echo "`basename $0` versione $VERSION"
  exit;
}

while getopts "e:r:c:p:vh" Option
do
  case $Option in
   e )
       ENVIRONMENT=$OPTARG
       ;;
   r )
       ECR_REPO=$OPTARG
       ;;
   c )
       CONTAINER_NAME=$OPTARG
       ;;
   p )
       PROJECT=$OPTARG
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

# Domain 

if [ -z $ENVIRONMENT ]
then
  echo
  echo "Building with default environment: $DEFAULT_ENV "
  ENVIRONMENT=$DEFAULT_ENV
  echo
fi

if [ -z $ECR_REPO ]
then
  echo
  echo "Building with default ECR repository:"
  ECR_REPO=$DEFAULT_ECR_REPO
  echo "$ECR_REPO"
fi

if [ -z $CONTAINER_NAME ]
then
  echo
  echo "Building with default container name: $DEFAULT_CONTAINER_NAME "
  CONTAINER_NAME=$DEFAULT_CONTAINER_NAME
  echo
fi

if [ -z $PROJECT ]
then
  echo
  echo "Building with default project: $DEFAULT_PRJ "
  PROJECT=$DEFAULT_PRJ
  echo
fi

#1. Checkout Dashboard Code
# cd $DEFAULT_GIT_PATH
# git fetch

# if [ ${ENV} == "prod" ]; then
#    git checkout master
# else
#     git checkout ${ENV}
# fi


# Login, build tag and push on ECR registry


aws ecr get-login --no-include-email --region eu-west-1| sh

echo "docker build -t ${ENVIRONMENT}-${PROJECT}:${CONTAINER_NAME} ${CONTAINER_NAME}"

docker build -t ${ENVIRONMENT}-${PROJECT}:${CONTAINER_NAME} ${CONTAINER_NAME}

if [ ${ENV} == "local" ]; then
    echo "Container built and tagged as: ${ENVIRONMENT}-${PROJECT}:${CONTAINER_NAME} "

else
    docker tag ${ENVIRONMENT}-${PROJECT}:${CONTAINER_NAME} ${ECR_REPO}:${CONTAINER_NAME}
    docker push ${ECR_REPO}:${CONTAINER_NAME}
fi

# docker build -t ${ENV}-$DEFAULT_PRJ:nginx nginx
# docker tag ${ENV}-$DEFAULT_PRJ:nginx ${ECR_REPO}:nginx
# docker push ${ECR_REPO}:nginx


# docker build -t ${ENV}-$DEFAULT_PRJ:shiny-server shiny-server
# docker tag ${ENV}-$DEFAULT_PRJ:shiny-server ${ECR_REPO}:shiny-server
# docker push ${ECR_REPO}:shiny-server