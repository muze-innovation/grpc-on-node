FROM peatisdocking/ts-node-12-alpine

COPY . .

RUN npm install

EXPOSE 50051

CMD [ "node", "/dynamic_codegen/greeter_server.js" ]