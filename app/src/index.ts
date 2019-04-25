import "reflect-metadata";
import {ConnectionOptions, createConnection} from "typeorm";
import { Migrations } from './entity/migrations';
const ormconfig = require('./config/ormconfig.json');


const options: ConnectionOptions = {
    type: "mysql",
    host: ormconfig.host,
    port: ormconfig.port,
    username: ormconfig.username,
    password: ormconfig.password,
    database: ormconfig.database,
    synchronize: ormconfig.synchronize,
    logging: ["query", "error"],
    entities: [Migrations],
};

createConnection(options).then(async connection => {
    // run all migrations
    await connection.runMigrations();
    // and undo migrations two times (because we have two migrations)
        await connection.undoLastMigration();
        await connection.undoLastMigration();
    console.log("Done. We run two migrations then reverted them.");   

}).catch(error => console.log("Error: ", error));