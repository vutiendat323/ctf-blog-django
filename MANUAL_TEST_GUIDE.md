# Hướng dẫn Kiểm thử Thủ công (Manual Test Guide)
## Dự án: CTF Blog & Education System

Tài liệu này hướng dẫn Tester cách thiết lập môi trường và thực hiện kiểm thử các tính năng chính của hệ thống.

---

## 1. Thiết lập Môi trường (Prerequisites)

Để chạy dự án local, bạn cần cài đặt Docker và Docker Compose.

**Các bước khởi động:**
1. Mở terminal tại thư mục gốc của dự án.
2. Chạy lệnh: `docker-compose up -d --build`
3. Chờ hệ thống khởi động. Truy cập tại: `http://localhost:8000`

**Dữ liệu mẫu (Seed Data):**
Nếu database trống, hãy chạy lệnh sau để nạp dữ liệu mẫu:
```bash
docker-compose exec web python manage.py seed_data
```

---

## 2. Thông tin Tài khoản Kiểm thử

| Vai trò | Username | Password |
| :--- | :--- | :--- |
| Admin | `admin` | (Tùy thiết lập hoặc dùng `admin123`) |
| Member | `tester01` | `password123` |

---

## 3. Danh mục Kiểm thử (Test Cases)

### A. Hệ thống Xác thực (Authentication)
- **Đăng ký (Register):** Kiểm tra tạo tài khoản mới, kiểm tra các ràng buộc (email hợp lệ, mật khẩu trùng khớp).
- **Đăng nhập (Login):** Kiểm tra đăng nhập thành công, đăng nhập sai pass.
- **Quên mật khẩu:** Kiểm tra luồng gửi mail reset password (nếu có cấu hình).
- **Trang cá nhân (Profile):** Kiểm tra xem và cập nhật thông tin cá nhân.

### B. Blog & Nội dung
- **Trang chủ:** Kiểm tra hiển thị danh sách bài viết mới nhất.
- **Chi tiết bài viết:** Kiểm tra hiển thị nội dung, hình ảnh, định dạng Markdown.
- **Tìm kiếm:** Kiểm tra tính năng tìm kiếm bài viết theo từ khóa tại `/search`.
- **Bình luận:** Kiểm tra việc đăng bình luận (phải đăng nhập) và phản hồi bình luận.

### C. Quản trị (CTF Admin Dashboard)
- Truy cập: `http://localhost:8000/ctf_admin/`
- Kiểm tra các biểu đồ thống kê trên Dashboard.
- Kiểm tra quản lý bài viết (Thêm/Xóa/Sửa).

### D. Các trang thông tin khác
- **Contact:** Gửi form liên hệ và kiểm tra thông báo thành công.
- **About:** Kiểm tra hiển thị thông tin giới thiệu.

---

## 4. Kiểm tra Kỹ thuật (Technical Checks)

- **Responsive:** Kiểm tra giao diện trên Mobile, Tablet và Desktop.
- **Tốc độ tải:** Trang chủ không nên mất quá 3 giây để load.
- **Lỗi hệ thống:** Theo dõi log của Docker để phát hiện lỗi 500:
  ```bash
  docker-compose logs -f web
  ```

---

## 5. Quy trình báo lỗi (Bug Reporting)

Khi phát hiện lỗi, vui lòng báo cáo theo mẫu:
1. **Tiêu đề:** [Feature] - Mô tả ngắn gọn lỗi.
2. **Bước thực hiện:** (1, 2, 3...)
3. **Kết quả mong đợi:** ...
4. **Kết quả thực tế:** (Kèm ảnh chụp màn hình/Log nếu có).
5. **Mức độ:** (High/Medium/Low).
