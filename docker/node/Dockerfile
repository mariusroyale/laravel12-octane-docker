FROM node:current-alpine3.21

# Set working directory
WORKDIR /var/www

# Install global npm packages
RUN npm install -g vite vitest eslint

# Optional: copy package.json and package-lock.json for caching dependencies
# COPY package*.json ./
# RUN npm install

# Default command to keep container running (optional)
CMD ["tail", "-f", "/dev/null"]