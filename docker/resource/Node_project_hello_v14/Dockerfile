FROM node:20-alpine

# Clone git hub repo to work dir
RUN git clone https://github.com/johnpapa/node-hello.git /app

# Remove something on docker and upgrade a new
RUN rm index.js && rm package.json

# Copy the index12.js into docker container
COPY ./Node_project_hello_v14 .

#  Build Project 
RUN npm install

# Expose port for enable access port 3000
EXPOSE 3000

#  RUN Project
CMD ["npm", "start"]