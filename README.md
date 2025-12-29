# ie103-project-report

IE103 Project Report (Typst)

## Quy Cách Tổ Chức

- `noi-dung`: các tài liệu của các phần báo cáo được lưu trữ ở đây, tương đương với thư mục [`noi-dung`](https://drive.google.com/drive/folders/1e9e2FMezlBpznZvsrrtDtkm6hDfzODi0?usp=drive_link) trên GDrive.
- `report`: thư mục chứa mã nguồn soạn thảo báo cáo.

## Nội Dung

- Bám sát hướng dẫn về Yêu Cầu [ĐỒ ÁN MÔN HỌC QUẢN LÝ THÔNG TIN](noi-dung/FinalProject_GUIDE-Yeu_Cau.md).

### 1. Mô tả bài toán

* Phát biểu bài toán, mục tiêu, đối tượng sử dụng.
* Mô tả quy trình trong thực tế liên quan đến bài toán (mô tả theo từng bước, và vẽ sơ đồ nếu có. Có thể tham khảo các quy trình có sẵn trong thực tế để xây dựng).

### 2. Phân tích và thiết kế (Mô hình dữ liệu)

* Liệt kê và mô tả các chức năng của hệ thống.
* Các đối tượng nào cần quản lý, mối quan hệ giữa các đối tượng (Tức chi tiết các thực thể cần quản lý, các thuộc tính cần có và mối quan hệ giữa chúng).
* Trình bày các ràng buộc trên các đối tượng (nếu có).
* Vẽ mô hình mức quan niệm cho mối quan hệ giữa các thực thể tương ứng với loại mô hình dữ liệu lựa chọn (VD: Sơ đồ ERD cho Mô hình quan hệ, Đồ thị quan hệ cho mô hình Đồ thị-Graph, ...).
* Thiết kế CSDL cho bài toán tương ứng với loại mô hình dữ liệu lựa chọn (Tức chuyển sang mô hình mức logic). Lưu ý kèm theo các giải thích cho các bảng trong CSDL (Tân từ).

### 3. Cài đặt

* Cài đặt mô hình dữ liệu trên một hệ quản trị CSDL (Trong loại mô hình dữ liệu đã lựa chọn) gồm: tạo bảng, tạo khoá chính, khoá ngoại, các ràng buộc (nếu có).
* Tạo dữ liệu mẫu hoặc thu thập dữ liệu trong thực tế.

### 4. Quản lý thông tin

* Xử lý thông tin (Stored Procedure, Trigger, Function, Cursor).
* An toàn thông tin (Xác thực, Phân quyền, Import, Export, Backup, Restore).
* Trình bày thông tin (Menu, Form, Report, Help).
* Các chức năng của hệ thống (Từ phần phân tích)
* **Lưu ý:** Demo cho các chức năng (Trên nền tảng Web, Desktop, Mobile, ...)

## Công Cụ

- ERD:
  - Chen Notation:
    - PlantUML: text-based; commit vào git được. https://plantuml.com/er-diagram
    - Visual Diagram (như ví dụ): quản lý theo project, tập trung nhiều loại diagram; binary, không commit vào git được.

![visual-diagram-example](assets/visual-diagram-example.png)
