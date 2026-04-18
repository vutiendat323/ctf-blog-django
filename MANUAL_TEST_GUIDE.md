# 🛡️ Hướng dẫn Kiểm thử Thủ công (Manual Test Guide)

## Dự án: CTF Blog & Lab System
**Phiên bản:** 1.1
**Mục tiêu:** Đảm bảo hệ thống hoạt động ổn định, bảo mật và mang lại trải nghiệm tốt cho cộng đồng CTF.

---

## 1. Thiết lập & Kiểm tra Môi trường (Environment Sanity Check)

Trước khi test, hãy đảm bảo Container chạy đúng:

1. **Khởi động:** `docker-compose up -d --build`
2. **Kiểm tra trạng thái:** `docker-compose ps` (Tất cả phải là `Up/Healthy`).
3. **Nạp dữ liệu mẫu:** 
   ```bash
   docker-compose exec web python manage.py seed_data
   ```
4. **Kiểm tra kết nối:** Truy cập `http://localhost:8000`. Nếu thấy giao diện Neo-Tokyo/Cyberpunk là OK.

---

## 2. Thông tin Tài khoản Kiểm thử (Test Credentials)

| Vai trò | Username | Password | Mục đích test |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Quản lý bài viết, User, Dashboard. |
| **Member** | `n30_user` | `password123` | Đăng bình luận, xem Profile. |
| **Anonymous** | (None) | (None) | Test quyền truy cập công khai. |

---

## 3. Kịch bản Kiểm thử Chi tiết (Test Scenarios)

### A. Luồng Bảo mật & Xác thực (Security & Auth)
1. **Đăng ký (Negative Test):**
   - Thử đăng ký với Email đã tồn tại -> Mong đợi: Báo lỗi "Email already exists".
   - Thử mật khẩu < 6 ký tự -> Mong đợi: Báo lỗi yêu cầu độ dài tối thiểu.
2. **Quên mật khẩu (Password Reset):**
   - Nhập email -> Kiểm tra log Docker: `docker-compose logs web` để xem link reset có gửi ra không.
   - Truy cập link và đổi pass mới -> Thử đăng nhập bằng pass mới.
3. **Phân quyền (Authorization):**
   - Dùng tài khoản Member truy cập thẳng `/ctf_admin/` -> Mong đợi: Bị đá ra trang Login hoặc báo 403 Forbidden.

### B. Nội dung & Tính năng Blog
1. **Tìm kiếm (Search):**
   - Tìm từ khóa có dấu, không dấu, hoặc từ khóa không tồn tại.
   - Thử nhập các ký tự đặc biệt (SQL Injection đơn giản như `' OR 1=1 --`) -> Mong đợi: Không lỗi trang, hiển thị "No results found".
2. **Bình luận (Comments):**
   - User chưa đăng nhập có thấy nút Bình luận không? (Mong đợi: Không hoặc yêu cầu Login).
   - Đăng bình luận có chứa thẻ HTML `<script>alert(1)</script>` (XSS Test) -> Mong đợi: Hệ thống escape code, không hiện alert.
3. **Bài viết Bí mật (Hidden Flags):**
   - Truy cập bài viết "Q4 Admin Notes" khi chưa đăng nhập Admin -> Mong đợi: Không tìm thấy bài viết (404).

### C. Quản trị (Admin Dashboard)
1. **Quản lý Bài viết:**
   - Tạo bài viết mới, tải lên ảnh Cover -> Kiểm tra xem ảnh có hiển thị đúng từ Cloudinary không.
   - Chỉnh sửa bài viết cũ -> Lưu và kiểm tra ngoài trang chủ.
2. **Thống kê:**
   - Truy cập `/ctf_admin/` -> Kiểm tra các biểu đồ tròn/cột có hiển thị dữ liệu thật không.

---

## 4. Kiểm tra Kỹ thuật & Giao diện (UX/UI & Tech)

- **Dark Mode/Theme:** Kiểm tra màu sắc các thẻ Card, Button có bị lệch tone khi xem trên màn hình độ sáng cao/thấp không.
- **Mobile Responsive:**
  - Menu Navbar có thu gọn thành dạng Hamburger không?
  - Các bảng (Tables) trong bài viết có bị tràn màn hình không?
- **Performance:** 
  - Chuyển trang giữa "Home" và "Post Detail" có mượt không (Dưới 1s).
  - Kiểm tra xem ảnh cover có bị nặng quá không (Sử dụng DevTools Network tab).

---

## 5. Danh sách các Lỗi phổ biến cần tìm (Common Bugs to hunt)

1. **404 Page:** Gõ một URL linh tinh (vd: `/anh-yeu-em`) -> Xem trang 404 có đẹp và có nút "Quay lại trang chủ" không.
2. **Empty State:** Xóa hết bài viết trong một Category -> Xem trang đó hiển thị "Chưa có bài viết nào" hay trắng trang.
3. **Form Validation:** Để trống các trường bắt buộc trong trang Contact rồi nhấn Gửi.

---

## 6. Quy trình báo Bug

Gửi Bug qua kênh Slack/Discord của Team hoặc Create Issue trên GitHub theo mẫu:
- **Environment:** (OS, Browser version)
- **Steps to Reproduce:** (1... 2... 3...)
- **Evidence:** (Ảnh chụp màn hình hoặc Video quay màn hình)
