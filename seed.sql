-- seed.sql

DROP TABLE IF EXISTS user_auth, refresh_tokens, profiles, organizations, skills, people_viewed, poss_connections, mutual_connections;

CREATE TABLE user_auth (
    user_id SERIAL PRIMARY KEY,
    email TEXT NOT NULL,
    password VARCHAR NOT NULL,
    profile_id INTEGER NOT NULL
);

CREATE TABLE refresh_tokens (
    token VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL
);

CREATE TABLE profiles (
    profile_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    headline TEXT,
    about TEXT,
    location TEXT,
    profile_img TEXT,
    background_img TEXT,
    roles_open_to TEXT,
    total_connections INTEGER,
    open_to_work BOOLEAN DEFAULT false,
    premium_member BOOLEAN DEFAULT false,
    total_followers INTEGER
);

CREATE TABLE organizations (
    org_id SERIAL PRIMARY KEY,
    org_name TEXT NOT NULL UNIQUE,
    job_title TEXT NOT NULL,
    date_started TEXT,
    date_ended TEXT,
    description TEXT NOT NULL, 
    org_img TEXT,
    skills TEXT,
    location TEXT
);

CREATE TABLE people_viewed (
    id SERIAL,
    name TEXT,
    headline TEXT,
    pic_url TEXT
);

CREATE TABLE mutual_connections (
    conn_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    img_url TEXT NOT NULL
);


CREATE TABLE skills (
    id SERIAL PRIMARY KEY,
    skill_name TEXT NOT NULL,
    endorsements INTEGER,
    org_ref INT NOT NULL,
    FOREIGN KEY (org_ref) REFERENCES organizations (org_id)
);


CREATE TABLE poss_connections (
    id SERIAL,
    name TEXT,
    headline TEXT,
    pic_url TEXT
);

-- DO NOT REMOVE OR COMMENT OUT
ALTER TABLE user_auth ADD CONSTRAINT fk_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE;
ALTER TABLE refresh_tokens ADD CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_auth(user_id) ON DELETE CASCADE;

INSERT INTO profiles (first_name, last_name, headline, about, location, profile_img, background_img, roles_open_to, total_connections, open_to_work, premium_member, total_followers)
    VALUES('Jacob','Linson','Software Engineer | Full Stack Developer | JavaScript | Security Clearance',
    'Personnel management leader with 7 years of experience in managerial positions that have proven my capabilities to lead a strong team. Quickly to adapt to a changing work environment while continuing my software engineering skills in JavaScript (Common JS and ES6), HTML5, CSS3, NodeJS, RESTful APIs with CRUD functionality, relational databases using PostgreSQL, and many other technologies. Looking to pursue a career in software engineering to continue to expand my education and knowledge. Please feel free to contact me at jlinson16@gmail.com',
    'Killeen-Temple Area',
    'https://media.licdn.com/dms/image/D5635AQHJ_F92_uKKwQ/profile-framedphoto-shrink_800_800/0/1675903807084?e=1680307200&v=beta&t=hSuwvjYpd5JfukZZxjLTp7ZXGFljQcF3R6cpM5AuMVs',
    'https://media.licdn.com/dms/image/D5616AQGTHMmUqEJEYQ/profile-displaybackgroundimage-shrink_350_1400/0/1675449763296?e=1683763200&v=beta&t=BuJTa8QuZqxC_ce10i-8XNJpVvJ6Ck1WJicumkcjDM4',
    'Software Engineer',
    41,
    true,
    true,
    39
);

INSERT INTO user_auth (email, password, profile_id) VALUES ('jDoe@123.com', '$2b$10$3eI62nH/dPjuHF71EasQGOpcTJxumQY.qK1OzDOUgTFAblKyX7XCC', 1);

INSERT INTO organizations (org_name, job_title, date_started, date_ended, description, org_img, skills, location)
    VALUES('Galvanize Inc',
    'Computer Software Engineering',
    'Dec 2022',
    'Apr 2023', 
    'Fully immersive course learning full stack application development using JavaScript, HTML, CSS, NodeJS, RESTful APIs with CRUD functionality, and relational databases with PostgreSQL.',
    'https://media.licdn.com/dms/image/C560BAQFKNxOZ4X0g8Q/company-logo_200_200/0/1670610916338?e=1686787200&v=beta&t=VRcM3RzZyMapiaz1SQ0eorQGXCIEOQVlU4TlByaCX-A',
    'Team leadeship - Veterans - Supervisory Skills - Personnel Management',
    NULL
    ),
    ('United States Department of Defense', 
    'Infantry Squad Leader', 
    'Jul 2018',
    'Jan 2023',
    'Responsible for the discipline, training, control, conduct and welfare of 10 soldiers at all times. Signed for and responsible for the condition, care, and effective use of the squads equipment.Responsible for the discipline, training, control, conduct and welfare of 10 soldiers at all times. Signed for and responsible for the condition, care, and effective use of the squads equipment.',
    'https://media.licdn.com/dms/image/C4D0BAQE4xab46KlLMA/company-logo_200_200/0/1643657220769?e=1686787200&v=beta&t=2SyPzzpyE_GwcE4uBoGdxst54hXDUBlYR2yR3XhmGA0',
    'Team Leadership - Veterans - Supervisory Skills - Personnel Management',
    'Fort Hood, Texas, United States'
);

INSERT INTO mutual_connections (name , img_url)
VALUES 
('Moises Martinez', 'https://media.licdn.com/dms/image/D4E35AQFrxTuJ5vwV2w/profile-framedphoto-shrink_800_800/0/1675714804846?e=1680307200&v=beta&t=wv9kAik6qSDbA6nd2bGNDWnf0cRIT17htksm26d-UZ8'),
('Chase Shertzer', 'https://media.licdn.com/dms/image/D5603AQHlpZDtNhXkVA/profile-displayphoto-shrink_800_800/0/1670595086348?e=1684368000&v=beta&t=EgaIW4EgPcOexfmR_3Za5vNgqCXcnspld7lghqxJNeU');




INSERT INTO skills (skill_name, endorsements, org_ref)
VALUES('JavaScript', 3, 1),
('Front-End Development', 3, 1),
('Back-End Web Development', 3, 1);

-- CREATE TABLE interests (
--     id SERIAL PRIMARY KEY,
--     top_voices JSONB, 
--     companies JSONB, 
--     groups JSONB,
--     schools JSONB
-- );

-- INSERT INTO interests (top_voices, companies, groups, schools) VALUES (
--     '{
--         "name": "Clement Mihailescu",
--         "role": "Co-Founder & CEO of AlgoExpert | Ex-Google & Ex-Facebook Software Engingeer | LinkedIn Top Voice,
--         "followers": "468,836"
--     }',
--     '{
--         "name": "Slack",
--         "url": "",
--         "followers": "1,229,646",
--     }'
-- )

INSERT INTO poss_connections (name, headline, pic_url)
    VALUES
    ('Bain Obermark', '| US Army Veteran | Full Stack Software Engineer | Secret Clearance |', 'https://media.licdn.com/dms/image/D5635AQEiyNs34E1KOg/profile-framedphoto-shrink_800_800/0/1669216900239?e=1680307200&v=beta&t=hEXSmjD7m7VpX36MFGrt6QjfXqyVEDNbdRmMp58lwZE'), 
    ('Simon Solomon', 'Full Stack Web Developer | US Army Veteran | JavaScript - HTML5 - CSS3 | React - Next.JS - P/MERN', 'https://media.licdn.com/dms/image/D5635AQHzSD63LnvVJw/profile-framedphoto-shrink_800_800/0/1673927756448?e=1680307200&v=beta&t=8kyCbOz4Vg_aWEgu3gKG32TQTsgQhijs0g4z6nOmce0'),
    ('Fernando Castro', 'Full Stack Developer | USMC Vet | Secret clearance', 'https://media.licdn.com/dms/image/D5603AQEpR6tMe2HJBA/profile-displayphoto-shrink_100_100/0/1673969407084?e=1683763200&v=beta&t=NdpE6ywAgeSKEa765JL2-w6ELcx61ueCTmKKwJy-FiU'),
    ('Paul Devlin', 'Veteran | Father | Software Engineer at Booz Allen Hamilton', 'https://media.licdn.com/dms/image/C5603AQGG7EKP3nBajA/profile-displayphoto-shrink_100_100/0/1635520992526?e=1683763200&v=beta&t=kFuFDbVJbGgm6zFXqmtlxluAtDJocF_LnfHvB773iXE'),
    ('Ryan Lonergan', 'Placing the right people and resources needed to meet internal and external requirements | Project Manager | Comprehensive process improvement', 'https://media.licdn.com/dms/image/D4D03AQG6aC2dT2XQ5Q/profile-displayphoto-shrink_100_100/0/1675010061985?e=1683763200&v=beta&t=Q-w0lSyiL1-GlxfvreiNrDxFVhAqgfpkNkjM9Hf8QvM'),
    ('Lucas Tousignant', 'Full-Stack Software Engineer', 'https://media.licdn.com/dms/image/D5635AQEI-jpAiD3cWQ/profile-framedphoto-shrink_100_100/0/1677026172764?e=1678816800&v=beta&t=HuKagFgKrAaF7UZ4i_6QEVBkpnCgI3sVoASkOpiPpCs'),
    ('Stephen Netzley, MSW', 'Military Career Transition Strategist', 'https://media.licdn.com/dms/image/C5603AQEywuL-5xEpkw/profile-displayphoto-shrink_100_100/0/1660187552114?e=1683763200&v=beta&t=ZBJqlMi26Et1AdkWmq4LG7l1JVa_0Hfn3l6Hvl7Pb4Q'),
    ('Brandon White', 'Transitioning Veteran, Full-Stack Software Engineer', 'https://media.licdn.com/dms/image/D4D35AQEPAMWmMeVzXA/profile-framedphoto-shrink_100_100/0/1676425599559?e=1678816800&v=beta&t=fJxxT3aw3BI9C9FW9nXQgemZrJ6f4ptYNRmQiqJPhcs'),
    ('Jacquon Nicholson', 'US Air Force Veteran ||  Certified Front End and Back End Developer || Full Stack Software Engineer || Project Management | JavaScript | Front End Engineer | Back End Engineer  Actively Looking for new Opportunities', 'https://media.licdn.com/dms/image/D5603AQG2n8U1sFeClg/profile-displayphoto-shrink_100_100/0/1666818772831?e=1683763200&v=beta&t=9Ao00Nm-JSZm732Pb6On8Wkf0l0Li2lW51iU4kRyMVA'),
    ('Magdiel R.', 'Software Engineer | PERN/MERN | US Air Force Vet | Motorsport Enthusiast', 'https://media.licdn.com/dms/image/D4D35AQExjWmU4tjvlA/profile-framedphoto-shrink_100_100/0/1657908314496?e=1678816800&v=beta&t=rQXS56u0L0BHAsnW8N6OASPVXrdYTIayZP2Xc8LOP3c');


INSERT INTO people_viewed (name, headline, pic_url)
    VALUES
    ('Davis Harper', '35N signals intelligence analysts coming to the end of my U.S Army contract. TS/SCI w/Full Scope poly. Tactical and strategic training.', 'https://media.licdn.com/dms/image/D5603AQHOXvuA2jiJJw/profile-displayphoto-shrink_100_100/0/1672620314522?e=1683763200&v=beta&t=PLjBQGEKifITpW_7Jxm3yrDvKPIsXNMvQZQfgt-h9Eg'), 
    ('Hunter Melgren', 'Bachelors in Mechanical Engineering.', 'https://media.licdn.com/dms/image/C5603AQFu_2heBxILfw/profile-displayphoto-shrink_100_100/0/1605648817291?e=1683763200&v=beta&t=MI_tH_IVt3eFRh9YcghSdG5XD6KnZ807pB8dJ3WGGbs'),
    ('Dwayne Holman Jr.', 'USN Veteran | Active Clearance | Team Builder and Leader', 'https://media.licdn.com/dms/image/D4E03AQG5a-34r5zhGg/profile-displayphoto-shrink_100_100/0/1674851265923?e=1683763200&v=beta&t=RFVwPVbz5A7YVA_HrjZW13E0Hs1BeR0VjZMemB0IeB8'),
    ('Darryl Giron', 'Highly motivated transitioning Veteran | Secret Clearance | Currently seeking entry-level opportunities as a Cloud Application Developer, Software Engineer or similar position | WaV2T Student', 'https://media.licdn.com/dms/image/D4D03AQF08txeP1JsMg/profile-displayphoto-shrink_100_100/0/1676397157798?e=1683763200&v=beta&t=kLKO6JV2eG692RkdQouZ1XYIjaoEoUqZCHrad5UfVDs'),
    ('Travis French', 'Veteran; active security clearance;', 'https://media.licdn.com/dms/image/D5603AQG9gPchB1wvCQ/profile-displayphoto-shrink_100_100/0/1669835821045?e=1683763200&v=beta&t=oWanfiSexmWyuCq5M_ydKICeSFHzWb1LrVHvU1WXBck'),
    ('Juan Acevedo ', 'DoD Secret | Veteran | ITF+ | Aspiring to be a Cloud Engineer | US Army Signal System Support Specialist | Communication Security Manager | ADDS | Microsoft Azure | Python | Linux', 'https://media.licdn.com/dms/image/D5603AQEXCziilkWepQ/profile-displayphoto-shrink_100_100/0/1673811998279?e=1683763200&v=beta&t=CHKlCnuEmRt1NdxL3W-98UpgS5y6AKWp0O428vDS4xg'),
    ('Grace Lawrence ', 'Aspiring Software Engineer | WA Vets2Tech (WAV2T) Student | Secret Clearance | Transitioning US Army HR Officer', 'https://media.licdn.com/dms/image/D5603AQFGbaWId_67CQ/profile-displayphoto-shrink_100_100/0/1676415794598?e=1683763200&v=beta&t=9cbFyo3xcd9-Un-dWY6VeLlAmAa35qP77R0Ou9kSQHk'),
    ('Toryan Washington ', 'Open to new opportunities as I transition out of the military.', 'https://media.licdn.com/dms/image/D5603AQH6Adhldd9iYg/profile-displayphoto-shrink_100_100/0/1674849139157?e=1683763200&v=beta&t=59MzJXLkTdBAuHK-vJW3pDz8iFEAdCXSkjdD-ydVuew'),
    ('Jacob Lester', 'Combat Specialist', 'https://media.licdn.com/dms/image/C4E03AQEzjYIGVHxBDw/profile-displayphoto-shrink_100_100/0/1662785475206?e=1683763200&v=beta&t=WlSN0XrJDReSt7vVFdcCvQtP5RIuKQjnulun_T_qm4w'),
    ('Brandon Hamlyn ', 'Software Development Engineering Student│WAVets2Tech Student at St. Martins University│Retired Military Veteran', 'https://media.licdn.com/dms/image/D5603AQE7x5bgh3FRkA/profile-displayphoto-shrink_100_100/0/1675285025247?e=1683763200&v=beta&t=ZLQxvubMFYEiOkBjpIXgAAzn2NnvMYJ__pPJV4b6q1g');


-- ALTER TABLE profiles ADD CONSTRAINT fk_title FOREIGN KEY(current_title) REFERENCES experience(exp_id) ON DELETE CASCADE;
-- ALTER TABLE profiles ADD CONSTRAINT fk_employment FOREIGN KEY(current_employment) REFERENCES organizations(org_id) ON DELETE CASCADE;
-- ALTER TABLE experience ADD CONSTRAINT fk_org FOREIGN KEY(org_id) REFERENCES organizations(org_id) ON DELETE CASCADE;
-- ALTER TABLE skills ADD CONSTRAINT fk_skill FOREIGN KEY(org_ref) REFERENCES organizations(org_id) ON DELETE CASCADE;