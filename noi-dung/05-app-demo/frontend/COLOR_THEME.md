# Hướng Dẫn Sử Dụng Bộ Màu Mới - Dark Theme

## Bảng Màu Chính

### 1. Màu Nền (Background)
- `dark:bg-dark-bg` - Nền chính (#0f1117) - Tối nhất
- `dark:bg-dark-surface` - Nền card/surface (#1a1d29) - Tối vừa
- `dark:bg-dark-elevated` - Nền elevated (#242837) - Sáng hơn một chút

### 2. Màu Viền (Border)
- `dark:border-dark-border` - Viền chính (#2d3142)

### 3. Màu Hover
- `dark:hover:bg-dark-hover` - Hover state (#323749)

### 4. Màu Chữ (Text)
- `dark:text-dark-text-primary` - Chữ chính (#e2e8f0)
- `dark:text-dark-text-secondary` - Chữ phụ (#94a3b8)
- `dark:text-dark-text-muted` - Chữ mờ (#64748b)

### 5. Màu Primary (Blue)
- `dark:bg-primary-400` - #60a5fa
- `dark:bg-primary-500` - #3b82f6
- `dark:bg-primary-600` - #2563eb
- `dark:bg-primary-700` - #1d4ed8

### 6. Màu Accent

#### Orange
- `dark:bg-accent-orange-400` - #fb923c
- `dark:bg-accent-orange-500` - #f97316
- `dark:text-accent-orange-400` - Chữ màu cam

#### Purple
- `dark:bg-accent-purple-400` - #c084fc
- `dark:bg-accent-purple-500` - #a855f7
- `dark:text-accent-purple-400` - Chữ màu tím

#### Green
- `dark:bg-accent-green-400` - #4ade80
- `dark:bg-accent-green-500` - #22c55e
- `dark:text-accent-green-400` - Chữ màu xanh lá

#### Pink
- `dark:bg-accent-pink-400` - #f472b6
- `dark:bg-accent-pink-500` - #ec4899
- `dark:text-accent-pink-400` - Chữ màu hồng

#### Cyan
- `dark:bg-accent-cyan-400` - #22d3ee
- `dark:bg-accent-cyan-500` - #06b6d4
- `dark:text-accent-cyan-400` - Chữ màu xanh dương nhạt

## Quy Tắc Thay Thế

### Thay thế màu cũ:
```
dark:bg-slate-950 → dark:bg-dark-bg
dark:bg-slate-900 → dark:bg-dark-surface
dark:bg-slate-800 → dark:bg-dark-elevated
dark:border-slate-800 → dark:border-dark-border
dark:border-slate-700 → dark:border-dark-border
dark:text-slate-100 → dark:text-dark-text-primary
dark:text-slate-300 → dark:text-dark-text-secondary
dark:text-slate-400 → dark:text-dark-text-secondary
dark:text-slate-500 → dark:text-dark-text-muted
```

### Màu nhấn (Accent):
```
dark:bg-red-600 → dark:bg-accent-orange-500
dark:text-red-500 → dark:text-accent-orange-500
dark:bg-blue-600 → dark:bg-primary-600
dark:text-blue-400 → dark:text-primary-400
```

## Ví Dụ Sử Dụng

### Button Primary
```tsx
className="bg-gradient-to-r from-primary-600 to-primary-700 text-white hover:from-primary-700 hover:to-primary-800"
```

### Card
```tsx
className="bg-white dark:bg-dark-surface border border-slate-200 dark:border-dark-border"
```

### Hover State
```tsx
className="hover:bg-slate-100 dark:hover:bg-dark-hover"
```

### Text
```tsx
className="text-slate-900 dark:text-dark-text-primary"
```

### Accent Button (Orange)
```tsx
className="bg-accent-orange-500 hover:bg-accent-orange-600 text-white"
```

### Status Indicators
- Success: `dark:bg-accent-green-500/10 dark:border-accent-green-500 dark:text-accent-green-400`
- Error: `dark:bg-accent-pink-500/10 dark:border-accent-pink-500 dark:text-accent-pink-400`
- Warning: `dark:bg-accent-orange-500/10 dark:border-accent-orange-500 dark:text-accent-orange-400`
- Info: `dark:bg-accent-cyan-500/10 dark:border-accent-cyan-500 dark:text-accent-cyan-400`
