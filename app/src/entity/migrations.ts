import { Entity, ObjectIdColumn, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Migrations {

    @PrimaryGeneratedColumn()
    id: string;

    @Column()
    timestamp: string;
    @Column()
    name: string;

}
