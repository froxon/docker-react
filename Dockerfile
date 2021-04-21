# Primera fase, denominada "builder", aunque en AWS va a dar problemas
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . . 
# Ahora esto ya no es un CMD, sino un RUN, porque queremos que se ejecute
# en tiempo de build, no en tiempo de run
RUN npm run build

# Este FROM arranca la segunda fase del proceso de construcción
# Copiamos la carpeta "build", que fue lo que construyó la anterior
# ojo al COPY --from
FROM nginx
# El EXPOSE es necesario para AWS, porque no tenemos control sobre el comando docker run (no podemos usar la opción -p)
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
# OJO:
# Este contenedor ya arranca nginx, por lo que no es necesario hacer un CMD