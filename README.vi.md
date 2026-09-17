# Nền tảng phân tích Xom Arcade

[English](README.md) | [Tiếng Việt](README.vi.md)

![Kiến trúc project](images/project-architecture.svg)

Dự án Modern Data Stack ELT end-to-end cho catalog game mobile Xom Arcade:

1. **Source**: Xom Dataset Microsoft SQL Server là nguồn OLTP production.
2. **Replication**: Fivetran replicate `mobile_games.games` vào Supabase PostgreSQL.
3. **Transformation**: dbt Core làm sạch dữ liệu thô và xây dựng các mô hình chiều (dimensional models) cùng các analytical marts phục vụ báo cáo genre, developer và release trend theo mô hình **Medallion Architecture** (Bronze &rarr; Silver &rarr; Gold &rarr; Platinum).
4. **Analytics & BI**: dbt Charts cung cấp semantic dashboards tương tác giải quyết trọn vẹn yêu cầu nghiệp vụ (từ Q1 đến Q15).
5. **Governance**: dbt Docs tự động tạo data catalog trực quan và sơ đồ lineage DAG.

## Cấu trúc thư mục dự án

| Thư mục | Mục đích & Tài liệu |
| :--- | :--- |
| [`models/`](models/README.md) | Các tầng biến đổi dữ liệu theo kiến trúc Medallion: |
| &emsp;├─ [`bronze/`](models/bronze/README.md) | Khai báo nguồn dữ liệu thô và data contracts (`sources.yml`). |
| &emsp;├─ [`silver/`](models/silver/README.md) | Tầng staging chuẩn hóa kiểu, làm sạch chuỗi và trích xuất đặc trưng (`stg_games.sql`). |
| &emsp;├─ [`gold/`](models/gold/README.md) | Star-schema cốt lõi: `dim_game`, `fct_games` và `int_release_trends`. |
| &emsp;└─ [`plat/`](models/plat/README.md) | 14 analytical marts phục vụ trực tiếp các câu hỏi nghiệp vụ Q1&ndash;Q15. |
| [`charts/`](charts/README.md) | Cấu hình dbt Charts và định nghĩa dashboard (`overview` & `research`). |
| [`scripts/`](scripts/README.md) | Script cấu hình cơ sở dữ liệu (`supabase_fivetran_setup.sql`) và hướng dẫn tích hợp. |
| [`images/`](images/README.md) | Ảnh vector kiến trúc hệ thống và ảnh chụp màn hình kiểm thử từng bước. |
| [`macros/`](macros/README.md) | Jinja macros tái sử dụng: `clean_text`, `count_delimited_values`, `safe_divide`. |
| [`tests/`](tests/README.md) | Bộ kiểm thử chất lượng dữ liệu: schema tests & 8 singular assertions độc lập. |
| [`analyses/`](analyses/README.md) | Các câu lệnh SQL phân tích ad-hoc được dbt biên dịch. |
| [`seeds/`](seeds/README.md) | Dữ liệu CSV tham chiếu tĩnh được quản lý phiên bản. |
| [`snapshots/`](snapshots/README.md) | Định nghĩa theo dõi thay đổi lịch sử SCD Type-2. |

## Yêu cầu môi trường

- Python 3.10+
- `uv` để quản lý Python và các công cụ CLI
- Đã cấu hình Fivetran connector và dự án Supabase PostgreSQL

## Cài đặt môi trường local

1. Khởi tạo môi trường ảo và cài đặt dbt Core:

```sh
uv python install 3.12
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python dbt-postgres
uv tool install dbt-charts
```

2. Sao chép `.env.example` thành `.env` và điền thông tin xác thực. File `.env` local đã được Git ignore.
3. Chạy `scripts/supabase_fivetran_setup.sql` khi kết nối vào database Supabase `postgres` mặc định.
4. Cấu hình Fivetran theo hướng dẫn tại `scripts/fivetran_source_setup.md`.
5. Sau lần sync đầu tiên của Fivetran, chạy:

```sh
set -a
. ./.env
set +a
DBT_PROFILES_DIR="$PWD" dbt debug
DBT_PROFILES_DIR="$PWD" dbt build
```

## Hình ảnh trực quan các bước triển khai

### 1. Cấu hình nguồn dữ liệu (Source)

Nguồn là Microsoft SQL Server chứa bảng `mobile_games.games`.

![Cấu hình SQL Server source](images/source-sql-server-setup.png)

![Tùy chọn sync source trên Fivetran](images/source-sql-server-sync-option.png)

![Kết quả sync source trên Fivetran](images/source-sql-server-sync-result.png)

### 2. Cấu hình đích đến (Destination)

Fivetran ghi dữ liệu vào database Supabase `postgres` trong schema `mobile_games` qua cổng Session Pooler (hỗ trợ IPv4).

![Schema destination Supabase](images/dest-postgres-schema.png)

![Kết quả destination Supabase](images/dest-postgres-result.png)

### 3. Khám phá dbt Charts

Dự án bao gồm Executive Overview và Research Board 4 tab (Executive, Market & Portfolio, Quality & Trends, Search & Discovery).

![Thư mục dbt Charts](images/dct-directory.png)

![Research board - Executive](images/dct-dashboard-demo-p1.png)

![Research board - Market and Portfolio](images/dct-dashboard-demo-p2.png)

![Research board - Quality and Trends](images/dct-dashboard-demo-p3.png)

![Research board - Search](images/dct-dashboard-demo-p4.png)

### 4. Khởi tạo dbt Docs

Biên dịch và mở giao diện tra cứu data catalog cùng biểu đồ lineage DAG:

```sh
DBT_PROFILES_DIR="$PWD" dbt docs generate
DBT_PROFILES_DIR="$PWD" dbt docs serve --port 8080
```

![dbt Docs](images/dbt-docs-generate.png)

## Sử dụng dbt Charts

Kiểm tra cú pháp và chạy thử nghiệm dashboard local:

```sh
dct validate charts/
set -a
. ./.env
set +a
DBT_PROFILES_DIR="$PWD" dct render charts/xom_arcade_overview.yml --format terminal
dct serve
```

Mở trình duyệt tại địa chỉ `http://localhost:3000` để tương tác trực tiếp với dashboard.

## Kiểm thử & Chất lượng dữ liệu

Chạy bộ kiểm thử tự động kiểm tra tính duy nhất của khóa chính, miền giá trị số học và cân đối số liệu giữa các tầng:

```sh
set -a
. ./.env
set +a
DBT_PROFILES_DIR="$PWD" dbt test
```
