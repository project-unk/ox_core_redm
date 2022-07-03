export type Character = {
    firstname: string;
    lastname: string;
    location?: string;
    gender: string;
    dateofbirth: string;
    groups?: string[],
    phone_number?: string;
    last_played: string;
    slot: number;
}