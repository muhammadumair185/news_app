# Use an official Node.js image as the base image
FROM node:16-alpine as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the app files to the container
COPY . .

# Build the React app
RUN npm run build

# Use a smaller image for serving the built app
FROM node:16-alpine

# Install serve globally to serve the static files
RUN npm install -g serve

# Set the working directory to /app
WORKDIR /app

# Copy the build folder from the previous stage
COPY --from=build /app/build ./build

# Expose the port that the app will run on
EXPOSE 5000

# Command to run the app
CMD ["serve", "-s", "build", "-l", "5000"]
