## An Toàn Thông Tin

### Xác Thực Và Phân Quyền

```{=typst}
#todo[(Xác Thực Và Phân Quyền) THỰC HIỆN PHÂN QUYỀN.]
```

Hệ thống áp dụng mô hình bảo mật dựa trên vai trò (RBAC - Role Based Access Control).

- Xác thực:
    - Mật khẩu người dùng được mã hóa (Hashing) trước khi lưu vào cơ sở dữ liệu (giả lập logic ứng dụng).
- Bảng phân quyền:

<!-- | STT | **Vai Trò** | **Quyền Hạn** |
|----:|----|----|
| 1 | Admin | Quản lý tất cả |
| 2 | Staff | Quản lý đặt phòng |
| 3 | End User | Đặt phòng | -->

```{=typst}
#figure(
    table(
    columns: (10%, 20%, 70%),
    align: (right, left, left),
    [STT], [#strong[Vai Trò]], [#strong[Quyền Hạn]], [1], [Admin], [Quản lý tất cả], [2], [Staff], [Quản lý đặt phòng], [3], [End User], [Đặt phòng]
    ),
    caption: [An Toàn Thông Tin - Bảng Phân Quyền]
)
```

### Sao Lưu & Phục Hồi

```{=typst}
#todo[(Sao Lưu & Phục Hồi) TRÌNH BÀY BACKUP/RESTORE.]
```

Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
- Transaction Log Backup: Mỗi 4 giờ/lần để giảm thiểu rủi ro mất dữ liệu giao dịch.

#### Import - Export Dữ Liệu

#### Backup – Restore Dữ Liệu
