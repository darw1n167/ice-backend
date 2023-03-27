import dotenv from "dotenv";
import postgres from "postgres";
import bcrypt from "bcrypt";
import { jwtAccessGen, jwtRefreshGen } from "../utils/jwtTokenGen.js";

dotenv.config();
const sql = postgres(process.env.DATABASE_URL);

export default async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // Check if user exists or return error
        const user = await sql`SELECT * FROM user_auth WHERE email = ${email};`;
        if (user.length < 1) {
            return res.status(404).send("User not found, please register.");
        }

        // Verify password is correct
        const validPassword = await bcrypt.compare(password, user[0].password);
        if (!validPassword) {
            return res.status(401).send("Invalid username or password, please try again or register for an account.");
        }

        // Create a jwt access and refresh token
        const accessToken = jwtAccessGen(user[0].profile_id);
        let refreshToken = jwtRefreshGen(user[0].profile_id);

        // Check that the refresh token is unique or reproduce a new refresh token
        let refreshTokenDuplicateCheck = await sql`SELECT * FROM refresh_tokens WHERE token = ${refreshToken}`;
        while (refreshTokenDuplicateCheck.length > 0) {
            refreshToken = jwtRefreshGen(user[0].profile_id);
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
        res.status(200).json({ accessToken });
    } catch (error) {
        res.status(500).send("Server error");
    }
};
