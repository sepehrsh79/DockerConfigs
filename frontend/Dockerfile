FROM node:20.10.0

WORKDIR /frontend

ADD ./package.json ./package-lock.json ./
ADD ./postcss.config.js ./tailwind.config.js webpack.config.js ./babel.config.js ./.env ./

# RUN npm install --verbose

ADD ./frontend /frontend

# ENTRYPOINT ["npm", "run", "build"]
ENTRYPOINT ["tail", "-f", "/dev/null"]