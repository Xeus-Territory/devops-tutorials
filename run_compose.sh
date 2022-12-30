
docker pull mhart/alpine-node:12
docker build -t nodejs12:v12 ./Node_Hello_12/

docker pull mhart/alpine-node:14
docker build -t nodejs14:v14 ./Node_Hello_14/

docker-compose up --detach


echo "-----------------------------------------------"
sleep 2
test12=$(docker exec -it devops_orienttrainningsession_nodejs12_1 curl -I localhost:3000 | awk '/HTTP\// {print $2}')
test14=$(docker exec -it devops_orienttrainningsession_nodejs14_1 curl -I localhost:3001 | awk '/HTTP\// {print $2}')
if [[ $test12 == "200" ]]
then 
    echo "The local web nodejs12 can accesible inside"
else 
    echo "The local web nodejs12 can NOT accesible inside"
fi

if [[ $test14 == "200" ]]
then 
    echo "The local web nodejs14 can accesible inside"
else 
    echo "The local web nodejs14 can NOT accesible inside"
fi