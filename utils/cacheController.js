import { cache } from "../server.js";
import { DEFAULT_CACHE_EXPIRATION } from "../server.js";

const cacheController = (key, cb) => {
    return new Promise((resolve, reject) => {
        cache.get(key, async (error, data) => {
            // Check for errors
            console.error("Cache error:", error);
            if (error) return reject(error);
            // Check cache for data
            if (data != null) return resolve(JSON.parse(data));
            // Query database for data and store in cache
            const sqlData = await cb();
            cache.set(key, JSON.stringify(sqlData), "EX", DEFAULT_CACHE_EXPIRATION);
            resolve(sqlData);
        });
    });
};

export default cacheController;
