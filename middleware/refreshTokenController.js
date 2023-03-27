import dotenv from "dotenv";
import postgres from "postgres";
import jwt from "jsonwebtoken";
import { jwtAccessGen } from "../utils/jwtTokenGen.js";

dotenv.config();
const sql = postgres(process.env.DATABASE_URL);

export default async (req, res, next) => {
    const cookies = req.cookies;
    let userId;

    // Checks that cookie exists with a jwt included
    if (!cookies?.jwt) return res.status(401).send("User not authenticated");

    const refreshToken = cookies.jwt;

    try {
        const user = await sql`SELECT user_id FROM refresh_tokens WHERE token = ${cookies.jwt}`;
        // Confirms refresh token exists in database
        if (user.length < 1) return res.status(403).send("Forbidden");
        userId = user[0].user_id;
    } catch (error) {
        res.status(500).json({ message: error.message });
    }

    jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, async (err, token) => {
        // Verifies token and if it passes, returns a payload we utilize in our route request
        try {
            // Confirms cookie payload has not been altered
            const profile = await sql`SELECT profile_id FROM user_auth WHERE user_id = ${userId}`;
            if (profile[0].profile_id !== token.profile_id) return res.status(403).send("Forbidden");
        } catch (error) {
            res.status(500).json({ message: error.message });
        }

        if (err) return res.status(403).send("Unauthorized Access");

        const accessToken = jwtAccessGen(token.profile_id);
        res.status(200).json({ accessToken });
    });
};
