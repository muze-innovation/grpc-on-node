#!/bin/sh
STARTTIME=$(date +%s)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
export BUILD_TARGET=stag
echo "Building target = $BUILD_TARGET"

nvm use

ENDTIME=$(date +%s)

export AWS_PROFILE=hagatron
export AWS_ACCOUNT_ID=918386376161
export HOST=0.0.0.0
export PORT=50051
export REGION=ap-southeast-1
export REG_TAG=$(git log --pretty=%H -n1)
export IMAGE_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hagatron/grpc-on-node-server:$BUILD_TARGET-$REG_TAG

docker build --build-arg HOST=$HOST,PORT=$PORT -t $IMAGE_NAME . -f Dockerfile

export TOKEN=$(aws ecr get-login-password --region ap-southeast-1 --profile $AWS_PROFILE | cut -d' ' -f6)

docker login -u AWS -p $TOKEN https://$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/
docker push $IMAGE_NAME

