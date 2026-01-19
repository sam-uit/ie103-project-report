import { Scenario, ScenarioType, ReportFile, LogEntry } from './types';

// --- HELPER CONSTANTS & COLS ---

const COLS_BOOKING = [
  { key: 'id', label: 'Booking ID', isPk: true },
  { key: 'user_id', label: 'User ID' },
  { key: 'check_in', label: 'Check In' },
  { key: 'check_out', label: 'Check Out' },
  { key: 'trang_thai', label: 'Trạng Thái' }
];

const COLS_APPLY_VOUCHER = [
  { key: 'id', label: 'Booking ID', isPk: true },
  { key: 'voucher_id', label: 'Voucher ID' },
  { key: 'ma_code', label: 'Mã Code' },
  { key: 'phan_tram_giam', label: '% Giảm' },
  { key: 'so_lan_da_dung', label: 'Đã Dùng' },
  { key: 'trang_thai', label: 'Trạng Thái' }
];

const COLS_USED_SERVICE = [
  { key: 'id', label: 'ID', isPk: true },
  { key: 'datphong_id', label: 'Booking ID' },
  { key: 'dichvu_id', label: 'Dịch Vụ ID' },
  { key: 'so_luong', label: 'Số Lượng' },
  { key: 'don_gia', label: 'Đơn Giá' },
  { key: 'thanh_tien', label: 'Thành Tiền' }
];

const COLS_REVIEW = [
  { key: 'id', label: 'Review ID', isPk: true },
  { key: 'user_id', label: 'User ID' },
  { key: 'phong_id', label: 'Phòng ID' },
  { key: 'datphong_id', label: 'Booking ID' },
  { key: 'so_sao', label: 'Số Sao' },
  { key: 'binh_luan', label: 'Bình Luận' },
  { key: 'trang_thai', label: 'Trạng Thái' }
];

const COLS_REVENUE_REPORT = [
  { key: 'booking_id', label: 'Mã Đặt Phòng', isPk: true },
  { key: 'full_name', label: 'Khách Hàng' },
  { key: 'tien_phong', label: 'Tiền Phòng' },
  { key: 'tien_dich_vu', label: 'Tiền Dịch Vụ' },
  { key: 'tong_cong', label: 'Tổng Cộng' }
];

const COLS_VOUCHER = [
  { key: 'id', label: 'Voucher ID', isPk: true },
  { key: 'ma_code', label: 'Mã Code' },
  { key: 'so_lan_da_dung', label: 'Đã Dùng' },
  { key: 'so_lan_toi_da', label: 'Tối Đa' },
  { key: 'trang_thai', label: 'Trạng Thái' }
];

// --- 1. STORED PROCEDURES (5) ---

const SP_SCENARIOS: Scenario[] = [
  {
    id: 'sp-booking-room',
    title: 'SP: Đặt Phòng Khách Sạn',
    type: ScenarioType.StoredProcedure,
    shortDesc: 'Tạo đặt phòng mới với kiểm tra phòng trống và thời gian hợp lệ.',
    sqlFile: 'sp_BookingRoom.sql',
    tables: ['DATPHONG', 'CT_DATPHONG'],
    columns: COLS_BOOKING,
    params: [
      { name: '@UserId', type: 'int', defaultValue: 1 },
      { name: '@PhongId', type: 'int', defaultValue: 1 },
      { name: '@CheckIn', type: 'string', defaultValue: '2026-02-01 14:00:00' },
      { name: '@CheckOut', type: 'string', defaultValue: '2026-02-05 12:00:00' }
    ],
    mockData: {
      before: [],
      after: [{ id: 1, user_id: 1, check_in: '2026-02-01T14:00:00', check_out: '2026-02-05T12:00:00', trang_thai: 'PENDING' }]
    },
    sqlContent: ''
  },
  {
    id: 'sp-apply-voucher',
    title: 'SP: Áp Dụng Voucher Giảm Giá',
    type: ScenarioType.StoredProcedure,
    shortDesc: 'Áp dụng mã giảm giá cho đặt phòng và tính toán giảm giá tự động.',
    sqlFile: 'sp_ApplyVoucher.sql',
    tables: ['DATPHONG', 'VOUCHERS'],
    columns: COLS_APPLY_VOUCHER,
    params: [
      { name: '@DatPhongId', type: 'int', defaultValue: 1 },
      { name: '@VoucherCode', type: 'string', defaultValue: 'SALE20' }
    ],
    mockData: {
      before: [{ id: 1, voucher_id: null, ma_code: null, phan_tram_giam: null, so_lan_da_dung: null, trang_thai: null }],
      after: [{ id: 1, voucher_id: 1, ma_code: 'SALE20', phan_tram_giam: 20, so_lan_da_dung: 1, trang_thai: 'ACTIVE' }]
    },
    sqlContent: ''
  },
  {
    id: 'sp-cancel-room',
    title: 'SP: Hủy Đặt Phòng',
    type: ScenarioType.StoredProcedure,
    shortDesc: 'Hủy đặt phòng khi chưa check-in và đang ở trạng thái PENDING.',
    sqlFile: 'sp_CancelRoom.sql',
    tables: ['DATPHONG'],
    columns: COLS_BOOKING,
    params: [
      { name: '@BookingId', type: 'int', defaultValue: 1 },
      { name: '@UserId', type: 'int', defaultValue: 1 },
      { name: '@LyDo', type: 'string', defaultValue: 'Thay đổi kế hoạch' }
    ],
    mockData: {
      before: [{ id: 1, user_id: 1, check_in: '2026-03-01T14:00:00', check_out: '2026-03-05T12:00:00', trang_thai: 'PENDING' }],
      after: [{ id: 1, user_id: 1, check_in: '2026-03-01T14:00:00', check_out: '2026-03-05T12:00:00', trang_thai: 'CANCELLED' }]
    },
    sqlContent: ''
  },
  {
    id: 'sp-used-service',
    title: 'SP: Sử Dụng Dịch Vụ',
    type: ScenarioType.StoredProcedure,
    shortDesc: 'Ghi nhận sử dụng dịch vụ đi kèm trong thời gian lưu trú.',
    sqlFile: 'sp_UsedService.sql',
    tables: ['CT_SUDUNG_DV'],
    columns: COLS_USED_SERVICE,
    params: [
      { name: '@DatPhongId', type: 'int', defaultValue: 1 },
      { name: '@DichVuId', type: 'int', defaultValue: 1 },
      { name: '@SoLuong', type: 'int', defaultValue: 2 },
      { name: '@GhiChu', type: 'string', defaultValue: 'Gọi phòng' }
    ],
    mockData: {
      before: [],
      after: [{ id: 1, datphong_id: 1, dichvu_id: 1, so_luong: 2, don_gia: 50000, thanh_tien: 100000 }]
    },
    sqlContent: ''
  },
  {
    id: 'sp-create-reviews',
    title: 'SP: Tạo Đánh Giá',
    type: ScenarioType.StoredProcedure,
    shortDesc: 'Tạo đánh giá cho đặt phòng sau khi đã thanh toán và trả phòng.',
    sqlFile: 'sp_CreateReviews.sql',
    tables: ['REVIEWS'],
    columns: COLS_REVIEW,
    params: [
      { name: '@UserId', type: 'int', defaultValue: 1 },
      { name: '@DatPhongId', type: 'int', defaultValue: 1 },
      { name: '@SoSao', type: 'int', defaultValue: 5 },
      { name: '@BinhLuan', type: 'string', defaultValue: 'Phòng rất đẹp và sạch sẽ!' }
    ],
    mockData: {
      before: [],
      after: [{ id: 1, user_id: 1, phong_id: 1, datphong_id: 1, so_sao: 5, binh_luan: 'Phòng rất đẹp và sạch sẽ!', trang_thai: 'PENDING' }]
    },
    sqlContent: ''
  }
];

// --- 2. CURSORS (2) ---

const CUR_SCENARIOS: Scenario[] = [
  {
    id: 'cs-book-revenue-report',
    title: 'Cursor: Báo Cáo Doanh Thu',
    type: ScenarioType.Cursor,
    shortDesc: 'Tổng hợp doanh thu chi tiết từng đặt phòng (Tiền phòng + Dịch vụ).',
    sqlFile: 'cs_BookRevenueReport.sql',
    tables: ['DATPHONG', 'CT_DATPHONG', 'CT_SUDUNG_DV'],
    columns: COLS_REVENUE_REPORT,
    params: [],
    mockData: {
      before: [
        { booking_id: 1, full_name: 'Nguyễn Văn A', tien_phong: 0, tien_dich_vu: 0, tong_cong: 0 },
        { booking_id: 2, full_name: 'Trần Thị B', tien_phong: 0, tien_dich_vu: 0, tong_cong: 0 }
      ],
      after: [
        { booking_id: 1, full_name: 'Nguyễn Văn A', tien_phong: 2000000, tien_dich_vu: 300000, tong_cong: 2300000 },
        { booking_id: 2, full_name: 'Trần Thị B', tien_phong: 1500000, tien_dich_vu: 150000, tong_cong: 1650000 }
      ]
    },
    sqlContent: ''
  },
  {
    id: 'cs-check-update-voucher',
    title: 'Cursor: Kiểm Tra & Cập Nhật Voucher',
    type: ScenarioType.Cursor,
    shortDesc: 'Duyệt qua voucher để cập nhật trạng thái INACTIVE khi hết lượt dùng.',
    sqlFile: 'cs_CheckAndUpdateManyVoucher.sql',
    tables: ['VOUCHERS'],
    columns: COLS_VOUCHER,
    params: [],
    mockData: {
      before: [
        { id: 1, ma_code: 'SALE20', so_lan_da_dung: 98, so_lan_toi_da: 100, trang_thai: 'ACTIVE' },
        { id: 2, ma_code: 'SALE50', so_lan_da_dung: 100, so_lan_toi_da: 100, trang_thai: 'ACTIVE' },
        { id: 3, ma_code: 'FREESHIP', so_lan_da_dung: 50, so_lan_toi_da: 200, trang_thai: 'ACTIVE' }
      ],
      after: [
        { id: 1, ma_code: 'SALE20', so_lan_da_dung: 98, so_lan_toi_da: 100, trang_thai: 'ACTIVE' },
        { id: 2, ma_code: 'SALE50', so_lan_da_dung: 100, so_lan_toi_da: 100, trang_thai: 'INACTIVE' },
        { id: 3, ma_code: 'FREESHIP', so_lan_da_dung: 50, so_lan_toi_da: 200, trang_thai: 'ACTIVE' }
      ]
    },
    sqlContent: ''
  }
];

export const SCENARIOS: Scenario[] = [
  ...SP_SCENARIOS,
  ...CUR_SCENARIOS
];

// --- 3. REPORT CATEGORIES & FILES ---

export const REPORTS: (ReportFile & { url: string })[] = [
  { 
    id: 'r-fin-1', 
    category: 'Báo Cáo Doanh Thu',
    name: 'Bao_Cao_Doanh_Thu_Q3_2023.pdf', 
    type: 'pdf', 
    size: '2.4 MB', 
    date: 'Oct 15, 2023', 
    thumbnailUrl: 'https://placehold.co/600x800/e6f2ff/0055aa?text=Doanh+Thu+Q3',
    url: 'https://pdfobject.com/pdf/sample.pdf' 
  },
  { 
    id: 'r-fin-2', 
    category: 'Báo Cáo Doanh Thu',
    name: 'Tong_Hop_Hoa_Don_Thang_10.pdf', 
    type: 'pdf', 
    size: '1.8 MB', 
    date: 'Nov 01, 2023', 
    thumbnailUrl: 'https://placehold.co/600x800/e6fff2/00aa55?text=Hoa+Don+T10',
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf' 
  },
  { 
    id: 'r-cus-1', 
    category: 'Quản Lý Khách Hàng',
    name: 'Danh_Sach_User_Gold.pdf', 
    type: 'pdf', 
    size: '500 KB', 
    date: 'Oct 10, 2023', 
    thumbnailUrl: 'https://placehold.co/600x800/fff0f0/aa0000?text=VIP+List',
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'
  }
];

export const LOGS: LogEntry[] = [
  { id: 'l1', timestamp: '2023-10-30 14:30:00', scenarioTitle: 'SP: Đặt Phòng Khách Sạn', type: ScenarioType.StoredProcedure, status: 'Success', durationMs: 120 },
  { id: 'l2', timestamp: '2023-10-30 14:32:15', scenarioTitle: 'SP: Áp Dụng Voucher', type: ScenarioType.StoredProcedure, status: 'Success', durationMs: 45 },
  { id: 'l3', timestamp: '2023-10-30 14:35:00', scenarioTitle: 'Cursor: Báo Cáo Doanh Thu', type: ScenarioType.Cursor, status: 'Success', durationMs: 180 },
];
