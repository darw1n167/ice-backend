import dotenv from "dotenv";
import postgres from "postgres";

dotenv.config();
const sql = postgres(process.env.DATABASE_URL);

export default async (req, res, next) => {
    const cookies = req.cookies;

    //Checks if cookie exists with a jwt
    if (!cookies?.jwt) return res.sendStatus(204);

    try {
        const user = await sql`SELECT user_id FROM refresh_tokens WHERE token = ${cookies.jwt}`;
        // Confirms refresh token exists in database
        if (user.length < 1) {
            res.clearCookie("jwt", {
                httpOnly: true,
                secure: true,
                sameSite: "None",
                maxAge: 100,
            });
            res.sendStatus(204);
        } else {
            await sql`DELETE FROM refresh_tokens WHERE user_id = ${user[0].user_id}`;
            res.clearCookie("jwt", {
                httpOnly: true,
                secure: true,
                sameSite: "None",
                maxAge: 100,
            });
            res.sendStatus(204);
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
