# ✈️ Root Cause Analysis Keterlambatan Penerbangan: End-to-End Data Workflow (Excel - Tableau)

## 📌  (Executive Summary)

Proyek ini adalah studi kasus krusial dalam **Operational Performance** yang bertujuan melakukan **Root Cause Analysis (RCA)** terhadap data historis keterlambatan penerbangan. Sebagai Data Analyst, saya menerapkan *end-to-end data workflow*, mulai dari *Data Cleansing* dan *Feature Engineering* di **Microsoft Excel/Google Sheets** hingga visualisasi *insights* operasional di **Tableau Desktop**. Hasilnya adalah *dashboard* yang memberikan *actionable insights* bagi tim Operasional untuk meningkatkan kinerja ketepatan waktu (*On-Time Performance*).

## 🛠️ Tools dan Data

* **Data Engineering & Cleansing:** Microsoft Excel / Google Sheets
* **Visualisasi & Dashboarding:** Tableau Desktop
* **Data Source:** Data penyebab keterlambatan penerbangan (`Airline_Delay_Cause.csv`).

---

## ⚙️ Fase 1: Data Engineering & Feature Engineering (Detail Excel/Sheets)

Fase ini menggunakan Excel/Sheets untuk membersihkan data dan menciptakan metrik baru (*calculated fields*) yang esensial untuk analisis mendalam.

| Level | Tugas | Rumus Excel/Sheets Kunci | Deskripsi Fungsional |
| :--- | :--- | :--- | :--- |
| **Basic** | **Pembersihan Teks** | **`=TRIM(A2)`** | Menghilangkan spasi berlebih pada kolom teks (`airport_name`, `carrier_name`) untuk menjamin *data integrity*. |
| **Basic** | **Total Waktu Delay** | **`=SUM(I2:M2)`** | Menghitung Total Waktu Delay (dalam menit) per baris dari semua kolom penyebab. (Asumsi I2:M2 adalah kolom delay). |
| **Intermediate** | **Ekstraksi Tanggal** | **`=DATE(A2, B2, 1)`** | Menggabungkan kolom `year` (A2) dan `month` (B2) menjadi satu kolom Tanggal Bulanan yang seragam untuk analisis *Time Series*. |
| **Intermediate** | **Persentase Kontribusi** | **`=J2/$N2`** (dengan $N2 dikunci) | Menghitung persentase kontribusi setiap penyebab (misal, `carrier_delay` di J2) terhadap *Total Waktu Delay* (N2) untuk analisis *share of blame*. |
| **Advance** | **Klasifikasi Risiko** | **`=IF(N2 > 100000, "High Risk", "Normal")`** | Membuat kategori risiko operasional menggunakan `IF` atau `IFS` untuk menandai bandara/maskapai yang total waktu *delay*-nya melebihi ambang batas tertentu. |
| **Advance** | **Pengecekan Unik** | **`=COUNTA(UNIQUE(E:E))`** | Mengkonfirmasi jumlah unik entitas (maskapai atau bandara) setelah proses *cleansing* (Hanya tersedia di Excel 365/Google Sheets). |

---

## 📊 Fase 2: Analisis Kunci dan Visualisasi (Pivot Table & Tableau)

### 2.1 Analisis Pivot Table (Excel/Sheets)

* **KPI Utama:** Menghitung rata-rata *Total Waktu Delay* dan *Total Volume Penerbangan*.
* **Root Cause Dominan:** Menggunakan kolom **`Penyebab Delay`** sebagai *Column Label* dan **SUM** `Total Waktu Delay` sebagai *Value* untuk mengukur *bottleneck*.
* **Hotspot Operasional:** Mengidentifikasi **Top 10 Bandara** dan **Maskapai** dengan *delay* tertinggi melalui *Value Filters*.

### 2.2 Visualisasi Tableau (Detail Calculated Fields)

Visualisasi dirancang untuk mengkomunikasikan *insights* operasional secara visual dan interaktif.

| Visualisasi | Tipe Chart/Metode | Calculated Field (Jika Ada) | Wawasan Operasional Utama |
| :--- | :--- | :--- | :--- |
| **Peta Hotspot Keterlambatan** | **Geo-Spatial Map** | N/A (Menggunakan *Field* geografis `city` dan `state` yang sudah ada). | Menunjukkan lokasi bandara/negara bagian dengan **Total Waktu Delay** tertinggi, memfokuskan intervensi geografis. |
| **Kontribusi Penyebab** | **Stacked Bar Chart** | **`[Delay Tipe Internal] = [carrier_delay]`**<br>**`[Delay Tipe Eksternal] = [weather_delay] + [nas_delay]`** | Membandingkan secara visual *share of blame* masalah **Internal** (*Carrier Delay*) vs **Eksternal** (*Weather/NAS Delay*). |
| **Tren Musiman** | **Line Chart** | **`DATETRUNC('month', [Date])`** (Digunakan untuk memastikan data agregat per bulan). | Memantau perubahan kinerja bulanan, membantu *forecasting* kebutuhan *buffer time* terutama pada *Peak Season*. |
| **Perbandingan Kinerja** | **Bar Chart (Top N Filter)** | **`RANK(SUM([Total Waktu Delay]))`** (Digunakan untuk menampilkan *Top 10* maskapai/bandara). | Menentukan maskapai mana yang menjadi *outlier* terburuk dibandingkan kompetitornya. |

---

## 💡 Key Insights & Rekomendasi Strategis

Analisis ini menghasilkan temuan yang dapat ditindaklanjuti untuk peningkatan kinerja **Operations**:

1.  **Isu Internal vs Eksternal:** Klarifikasi apakah masalah utama terletak pada *Internal Operations* (jika **Carrier Delay** dominan) atau faktor eksternal (jika **NAS/Weather Delay** dominan).
2.  **Mitigasi Risiko:** Gunakan data musiman (*Seasonal Trends*) dan *Weather Delay* untuk merekomendasikan penambahan **Buffer Time** yang strategis pada rute dan bulan dengan risiko tertinggi.
3.  **Targeted Improvement:** Daftar Bandara **Top 10 Delay** menjadi target prioritas untuk *review* alur kerja dan koordinasi *Air Traffic Control* guna mengurangi **NAS Delay**.
