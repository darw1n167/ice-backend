import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

export const jwtAccessGen = (profile_id) => {
    return jwt.sign({ profile_id }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: "10m" });
};

export const jwtRefreshGen = (profile_id) => {
    return jwt.sign({ profile_id }, process.env.REFRESH_TOKEN_SECRET, { expiresIn: "1d" });
};
