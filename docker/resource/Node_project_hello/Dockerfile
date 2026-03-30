FROM node:20-alpine

# Clone git hub repo to work dir
RUN git clone https://github.com/johnpapa/node-hello.git /app

#  Build Project 
RUN npm install

# Expose port for enable access port 3000
EXPOSE 3000

#  RUN Project
CMD ["npm", "start"]