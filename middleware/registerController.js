import dotenv from "dotenv";
import postgres from "postgres";
import bcrypt from "bcrypt";
import { jwtAccessGen, jwtRefreshGen } from "../utils/jwtTokenGen.js";

dotenv.config();
const sql = postgres(process.env.DATABASE_URL);

export default async (req, res, next) => {
    const { email, password, firstName, lastName } = req.body;
    try {
        // Check if user exists and return error
        const query = await sql`SELECT * FROM user_auth WHERE email = ${email}`;
        if (query.length !== 0) {
            res.status(403).json({ message: "User already exists." });
        } else {
            // Insert Profile Data
            const profile =
                await sql`INSERT INTO profiles (first_name, last_name) VALUES (${firstName}, ${lastName}) RETURNING profile_id;`;

            // Encrypting password for database insertion
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(password, salt);

            // Insert User Authentication Data
            const user =
                await sql`INSERT INTO user_auth (email, password, profile_id) VALUES (${email}, ${hashedPassword}, ${profile[0].profile_id}) RETURNING user_id;`;

            // Create a jwt access and refresh token
            const accessToken = jwtAccessGen(profile[0].profile_id);
            let refreshToken = jwtRefreshGen(profile[0].profile_id);

            // Check that the refresh token is unique or reproduce a new refresh token
            let refreshTokenDuplicateCheck = await sql`SELECT * FROM refresh_tokens WHERE token = ${refreshToken}`;
            while (refreshTokenDuplicateCheck.length > 0) {
                refreshToken = jwtRefreshGen(profile[0].profile_id);
                refreshTokenDuplicateCheck = await sql`SELECT * FROM refresh_tokens WHERE token = ${refreshToken}`;
            }

            //Insert refresh token into user_auth with corresponding user_id
            await sql`INSERT INTO refresh_tokens (token, user_id) VALUES (${refreshToken}, ${user[0].user_id});`;
            // Respond with refresh token in an http-only cookie and access token in json to be stored in state on client-side
            res.cookie("jwt", refreshToken, {
                httpOnly: true,
                secure: true,
                sameSite: "None",
                maxAge: 24 * 60 * 60 * 1000,
            });
            res.status(201).json({ accessToken });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
