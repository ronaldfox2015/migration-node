import {MigrationInterface, QueryRunner} from "typeorm";
import * as fs from "fs";

export class PostRefactoring1555873332922 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<any> {
        const sql = fs.readFileSync('../sql/delta.sql', 'utf8');
        await queryRunner.query(sql);
    }

    public async down(queryRunner: QueryRunner): Promise<any> {
        await queryRunner.query("");
    }

}