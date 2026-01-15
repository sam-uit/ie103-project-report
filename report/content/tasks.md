```{=typst}
#heading("Báo Cáo Tiến Độ", numbering: none)
```

(Sẽ xóa file này sau khi hoàn thành.)

Các hạng mục công việc:

- [x] 1. Mô tả bài toán
- [x] 2. Phân Tích Và Thiết Kế
- [x] 2.1 Các Chức Năng Nghiệp Vụ
- [x] 2.2 Đối Tượng Và Mối Quan Hệ
- [x] 2.3 Mô Hình Mức Quan Niệm
- [x] 2.4 Thiết Kế Cơ Sở Dữ Liệu
- [x] 3. Cài Đặt Và Triển Khai
- [x] 3.1 Cài Đặt Mô Hình Dữ Liệu
- [x] 3.2 Dữ Liệu Mẫu
- [x] 4. Quản Lý Thông Tin
- [x] 4.1 Xử Lý Thông Tin
- [x] 4.1.1 Stored Procedures
- [x] 4.1.1.a SP_TAO_DANH_GIA: Tạo đánh giá cho đặt phòng sau khi đã thanh toán và trả phòng
- [x] 4.1.1.b SP_AP_DUNG_VOUCHER: Áp dụng voucher cho một đặt phòng
- [x] 4.1.1.c SP_SU_DUNG_DICH_VU: Sử dụng dịch vụ đi kèm trong thời gian lưu trú
- [x] 4.1.1.d SP_CHECK_PHONG_TRONG: Kiểm tra phòng trống
- [x] 4.1.1.e SP_HOAN_TIEN: Hoàn tiền cho một giao dịch
- [x] 4.1.2 Triggers
- [x] 4.1.2.a trg_DATPHONG_CheckTime: Kiểm tra thời gian đặt phòng (DATPHONG)
- [x] 4.1.2.b trg_CTDP_Insert_ValidatePrice: Chèn chi tiết đặt phòng + tự động đơn giá (CT_DATPHONG)
- [x] 4.1.2.c trg_CTDP_SyncRoomStatus: Đồng bộ trạng thái phòng theo CT_DATPHONG
- [x] 4.1.2.d trg_REFUNDS_Insert_CheckAndUpdate: Kiểm tra Hoàn Tiền + Cập nhật lại giao dịch
- [x] 4.1.2.e trg_PAYMENTS_Insert_CheckAndPaid: Kiểm tra thanh toán + Cập nhật lại giao dịch
- [x] 4.1.3 Functions
- [x] 4.1.4 Cursors
- [/] 4.2 An Toàn Thông Tin
- [ ] 4.2.1 Backup
- [ ] 4.2.2 Restore
- [ ] 4.2.3 Import
- [ ] 4.2.4 Export
- [ ] 4.3 Trình Bày Thông Tin
- [ ] 4.3.1 Menu
- [ ] 4.3.2 Form
- [ ] 4.3.3 Report
