# CTF Blog Project

Dự án này là một hệ thống Blog chuyên về CTF (Capture The Flag) được xây dựng bằng Django.

## Tính năng
- Đăng bài, bình luận.
- Quản lý User, Category.
- Tích hợp công cụ test bảo mật (exploit_dump.py).

## Hướng dẫn cài đặt
1. Cài đặt Python: `pip install -r requirements.txt`
2. Khởi tạo Database: `mysql < init.sql`
3. Chạy server: `python manage.py runserver`
