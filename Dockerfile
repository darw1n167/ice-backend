#Create Node Environment in this container
FROM node:14
#Will create a directory app in the container and switch to this directory
WORKDIR /app
#Copies the package.json file to the app directory created in the container
COPY package*.json ./
#Creates the node_modules for the app directory
RUN npm install
#Copies the source code to the app directory
COPY . .
#Exposes this port to access the app from outside the container aka your browser
EXPOSE 3001
#To start your react app
CMD ["npm", "start"]