-- CTF Blog Database Init Script
-- Run: mysql -u root -p < init.sql

CREATE DATABASE IF NOT EXISTS ctf_blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ctf_blog;

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- ===========================
-- USERS TABLE
-- ===========================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- CATEGORIES TABLE
-- ===========================
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- ===========================
-- POSTS TABLE
-- ===========================
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    content TEXT NOT NULL,
    excerpt TEXT,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    is_published TINYINT(1) DEFAULT 1,
    views INT DEFAULT 0,
    secret_flag VARCHAR(100) DEFAULT NULL,
    cover_image VARCHAR(500) DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- ===========================
-- COMMENTS TABLE
-- ===========================
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    author_name VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);

-- ===========================
-- SEED DATA
-- ===========================

-- Users: admin password is MD5('admin123') = 0192023a7bbd73250516f069df18b500
-- Hint: password is weak, hash is from common wordlist
INSERT INTO users (username, password, email, role) VALUES
('admin',    '0192023a7bbd73250516f069df18b500', 'admin@neural-feed.local', 'admin'),
('n30_user', 'a665a45920422f9d417e4867efdc4fb8', 'neo@matrix.local',         'user'),
('ghost',    '5994471abb01112afcc18159f6cc74b4', 'ghost@shell.local',         'user');

-- Categories
INSERT INTO categories (name, slug, description) VALUES
('Content Creation', 'content-creation', 'Digital content and creative expression in the cyber age'),
('Security',         'security',         'Cybersecurity research, tools, and techniques'),
('Marketing',        'marketing',        'Digital marketing strategies and growth hacks'),
('Featured',         'featured',         'Editor picked featured transmissions');

-- Posts (published)
INSERT INTO posts (title, slug, content, excerpt, author_id, category_id, is_published, views, cover_image) VALUES
(
    'The Art of Digital Infiltration',
    'art-of-digital-infiltration',
    '<p>In the neon-lit alleyways of cyberspace, the line between art and hacking has never been thinner. Digital infiltration is not merely a technical exercise — it is an art form, a dance between the attacker and the system.</p><h2>The Mindset</h2><p>Every great infiltrator starts with curiosity. The question is never "can I break this?" but rather "how does this work?" Understanding a system at its deepest level is the prerequisite to mastery.</p><h2>The Tools</h2><p>From port scanners to payload crafters, the modern digital artist has an arsenal unlike anything seen before. Tools like nmap, Burp Suite, and custom Python scripts form the palette of the cyber artisan.</p><h2>Ethics & Boundaries</h2><p>The true art lies in restraint. Knowing what you can do versus what you should do separates the artist from the vandal. Always operate within legal and ethical boundaries — CTF challenges and authorized penetration tests are the legitimate canvas.</p><p>Remember: every lock exists to be understood, not necessarily opened.</p>',
    'In the neon-lit alleyways of cyberspace, the line between art and hacking has never been thinner. Digital infiltration is not merely a technical exercise — it is an art form.',
    1, 4, 1, 79,
    'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&q=80'
),
(
    'Best Tools for Network Analysis in 2024',
    'best-tools-network-analysis-2024',
    '<p>Network analysis is the backbone of modern security research. Whether you are a blue team defender or a red team operator, understanding traffic flows is non-negotiable.</p><h2>Wireshark</h2><p>Still the gold standard. Nothing beats packet-level inspection for understanding exactly what is traversing your network. The filter language is a skill unto itself.</p><h2>nmap & masscan</h2><p>Port scanning at scale. masscan can scan the entire internet in under 5 minutes — a sobering reminder of how exposed the global infrastructure really is.</p><h2>Zeek (formerly Bro)</h2><p>For high-throughput environments, Zeek generates structured logs from raw traffic, making it ideal for SIEM integration and threat hunting at scale.</p><h2>Burp Suite</h2><p>The essential web proxy for any security researcher. The Intruder and Repeater modules alone justify the professional license.</p>',
    'Network analysis is the backbone of modern security research. Here are the essential tools every security researcher should master.',
    1, 2, 1, 36,
    'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80'
),
(
    'Top 5 Cyberpunk Anime That Predicted the Future',
    'top-5-cyberpunk-anime',
    '<p>Long before the term "cyberpunk" became mainstream, Japanese animators were exploring dystopian futures with unsettling accuracy. Here are five series that feel less like fiction and more like prophecy.</p><h2>Ghost in the Shell (1995)</h2><p>Masamune Shirow''s masterpiece asks what it means to be human in an age of cyber-enhanced bodies. The concept of a "ghost" — the essential self — has never been more relevant.</p><h2>Serial Experiments Lain (1998)</h2><p>Before social media, before the metaverse, Lain explored the dissolution of the boundary between the digital and physical worlds. Disturbing and prophetic.</h2><h2>Ergo Proxy (2006)</h2><p>In a domed city where humans live alongside androids, a government agent uncovers a conspiracy that shakes the foundations of her reality.</p><h2>Psycho-Pass (2012)</h2><p>A society where an omniscient AI predicts criminal intent before crimes occur. Sound familiar?</p><h2>Texhnolyze (2003)</h2><p>Perhaps the bleakest entry — a city beneath the earth where factions war over cybernetic enhancements. Not for the faint-hearted.</p>',
    'Long before "cyberpunk" went mainstream, Japanese animators were exploring dystopian futures with unsettling accuracy. Five series that feel like prophecy.',
    2, 4, 1, 120,
    'https://images.unsplash.com/photo-1534972195531-d756b9bfa9f2?w=800&q=80'
),
(
    'Understanding Buffer Overflows: A Practical Guide',
    'understanding-buffer-overflows',
    '<p>Buffer overflow vulnerabilities remain one of the most fundamental classes of security flaws, despite being well-understood for decades. Understanding them is essential for any security practitioner.</p><h2>What is a Buffer?</h2><p>A buffer is a contiguous block of memory allocated to hold data. In C, when you declare <code>char buf[64]</code>, you are reserving 64 bytes on the stack.</p><h2>What Happens When You Overflow?</h2><p>If a program copies more data into that buffer than it can hold — without bounds checking — the excess data overwrites adjacent memory. On the stack, this typically means overwriting the saved return address.</p><h2>Classic Exploitation</h2><p>By carefully crafting the overflow payload, an attacker can redirect execution to shellcode injected in the buffer itself, or to existing executable code (ret2libc, ROP chains).</p><h2>Modern Mitigations</h2><p>ASLR, stack canaries, NX/DEP, and PIE have made exploitation significantly harder — but not impossible. CTF challenges routinely defeat these protections with creative techniques.</p>',
    'Buffer overflow vulnerabilities remain fundamental despite being well-understood for decades. A practical guide for security practitioners and CTF players.',
    1, 2, 1, 67,
    'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80'
),
(
    'Neo-Tokyo Ramen: The Underground Bowls You Cannot Miss',
    'neo-tokyo-ramen-underground',
    '<p>In the basement izakayas and hidden ramen shops of Tokyo''s Shinjuku ward, a culinary revolution has been quietly simmering. Far from the tourist-facing shops, the underground ramen scene is where the real innovation happens.</p><h2>Tonkotsu Noir</h2><p>Black garlic oil transforms the classic pork bone broth into something otherworldly. The Hakata-style shops that pioneered this style have spawned countless imitators, none quite capturing the original''s depth.</p><h2>The Digital Age Ramen Shop</h2><p>QR-code menus, automated ordering kiosks, and ramen vending machines have changed the eating experience. Some purists lament this, but the efficiency is undeniable — and the quality has not suffered.</p><h2>Where to Find the Hidden Gems</h2><p>The best shops have no English menus, no Instagram presence, and no tourist maps. They are found through word of mouth, through the recommendations of Tokyo''s network of ramen obsessives.</p>',
    'In the basement izakayas and hidden ramen shops of Tokyo, a culinary revolution has been quietly simmering. The underground bowls you cannot miss.',
    3, 1, 1, 12,
    'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=80'
);

-- PRIVATE post with secret_flag (is_published = 0) — the CTF target
INSERT INTO posts (title, slug, content, excerpt, author_id, category_id, is_published, views, secret_flag, cover_image) VALUES
(
    'Q4 Admin Notes - CLASSIFIED',
    'admin-notes-q4-classified',
    '<p>CLASSIFIED INTERNAL DOCUMENT</p><p>System audit results for Q4. All findings marked CONFIDENTIAL.</p><p>Root access credentials have been rotated. New backup credentials stored in vault.</p><p>Next penetration test scheduled for next quarter.</p>',
    'Internal admin notes — not for public access.',
    1, 2, 0, 0,
    'CTF{Un10n_SQL1_M4st3r}',
    'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=800&q=80'
);

-- Comments
INSERT INTO comments (post_id, author_name, content) VALUES
(1, 'n30_user',  'Absolutely mind-bending perspective. The intersection of art and hacking is underexplored.'),
(1, 'gh0st_r1d3r', 'Great writeup. Have you covered OSINT methodologies? Would love a follow-up.'),
(3, 'anim3_fan',  'Ghost in the Shell changed my life. The puppet master arc is philosophy disguised as fiction.'),
(3, 'n30_user',  'Lain is still the most accurate depiction of internet culture I have ever seen.'),
(4, 'sec_newbie', 'This helped me understand ret2libc. Finally clicked after reading this!'),
(5, 'ramen_ghost', 'Been to Tokyo three times hunting these shops. Worth every yen.');
