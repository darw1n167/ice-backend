import dotenv from "dotenv";
import jwt from "jsonwebtoken";

dotenv.config();

export default async (req, res, next) => {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    // Checks that request host has been authenticated
    if (token == null) return res.status(401).send("User not authenticated");
    // Verifies token and if it passes, returns a payload we utilize in our route request
    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, token) => {
        if (err) return res.status(403).send("Unauthorized Access");
        req.profile_id = token.profile_id;
        next();
    });
};
