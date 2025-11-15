# 🎬 Data Governance & Analytics Framework: IMDB Movie Dataset
## ✨ Implementasi Formula Excel/Sheets Tingkat Mahir untuk Optimalisasi Operasional

 **Tools Kunci:** ⚙️ Microsoft Excel & Google Sheets

### 📊 1. Ringkasan Proyek

Proyek ini adalah demonstrasi *end-to-end* proses **Kontrol Kualitas Data (DQC)** yang sistematis, mengubah data mentah yang kompleks menjadi aset yang siap digunakan untuk *business intelligence* dan laporan operasional.

**Nilai Jual:** Mampu membangun kerangka kerja **Validasi Data** dan **Kalkulasi Metrik Kinerja** yang akurat dan *real-time* langsung di *spreadsheet*, menghilangkan risiko *Garbage In, Garbage Out (GIGO)*.

---

### 🛠️ 2. Metodologi DQC & Fungsi Kunci (Excel/Sheets)

Metodologi dibagi menjadi tiga tingkat kompleksitas untuk menunjukkan penguasaan dari pembersihan dasar hingga analisis prediktif berbasis formula.

#### A. Tingkat 1: Cleansing & Standarisasi Data (Essential)
Fokus pada penanganan nilai hilang, duplikasi, dan penyeragaman format dasar.

| # | Pilar DQC | Rumus Excel/Sheets | Logika Profesional (Action & Impact) |
| :---: | :--- | :--- | :--- |
| **1** | **Penanganan *Null Values*** | `=IF(ISBLANK(E2), "N/A", E2)` | **Mengisi Kesenjangan:** Mengganti sel kosong (Kolom `Duration`) dengan penanda. **Impact:** Mencegah *error* kalkulasi dan memastikan **kelengkapan data**. |
| **2** | **Kontrol Duplikasi** | `=IF(COUNTIF(A$2:A2, A2)>1, "DUPLICATE", "UNIQUE")` | **Integritas Data:** Menandai *record* berdasarkan **IMBD ID** ganda. **Impact:** Menghasilkan dataset **unik** untuk analisis statistik yang valid. |
| **3** | **Normalisasi Teks** | `=PROPER(TRIM(B2))` | **Konsistensi Format:** `TRIM` menghilangkan spasi ekstra; `PROPER` menyamakan kapitalisasi. **Impact:** **Memastikan *string* yang sama dikelompokkan** (misalnya pada kategori Genre). |
| **4** | **Transformasi Tipe Data** | `=DATEVALUE(C2)` | **Kesiapan Analisis:** Mengubah teks tanggal ke **nilai serial Tanggal** fungsional. **Impact:** Data siap untuk analisis *time-series* (tren waktu). |

#### B. Tingkat 2: Validasi Kualitas & Metrik Terkondisi (Mahir)
Fokus pada *error handling* yang kuat, validasi rentang logis, dan kalkulasi metrik awal.

| # | Pilar DQC | Rumus Excel/Sheets | Logika Profesional (Action & Impact) |
| :---: | :--- | :--- | :--- |
| **5** | **Validasi *Range* (Outlier)** | `=IF(AND(L2>=1, L2<=10), "VALID", "REVIEW")` | **Validasi Kredibilitas:** Memastikan `Score` (Kolom L) berada dalam rentang logis 1-10. **Impact:** **Mengisolasi *outlier*** yang dapat merusak perhitungan rata-rata. |
| **6** | **Kontrol *Error* Lanjutan** | `=IFERROR(VLOOKUP(A2, Sheet2!A:B, 2, FALSE), "NOT FOUND")` | **Penggabungan Data Aman:** Mengganti *error* **#N/A** (dari *VLOOKUP*) dengan *string* informatif. **Impact:** **Meningkatkan *readability* laporan** dan integritas data. |
| **7** | **Validasi Lintas Kolom** | `=AND(ISNUMBER(K2), ISBLANK(J2))` | **Pengecekan Kualitas Logis:** Memastikan `Income` (K2) adalah angka **DAN** kolom *Director* (J2) tidak kosong. **Impact:** Mengidentifikasi data yang secara logis harus lengkap, namun tidak. |
| **8** | **Kalkulasi Metrik Dasar** | `=AVERAGEIF(F:F, "USA", K:K)` | **Analisis Kinerja:** Menghitung **Rata-rata Pendapatan** (Kolom K) hanya untuk film di **"USA"** (Kolom F). **Impact:** Menyediakan **metrik kinerja regional** yang akurat dari data yang sudah diseragamkan. |

#### C. Tingkat 3: Analisis Operasional & Otomasi 
Fokus pada *dynamic reporting*, *in-cell visualization*, dan kalkulasi berbasis waktu.

| # | Pilar DQC | Rumus Excel/Sheets | Logika Profesional (Action & Impact) |
| :---: | :--- | :--- | :--- |
| **9** | **Analisis Kinerja Dinamis** | `=SUMIFS(K:K, F:F, "USA", C:C, ">"&YEAR(TODAY())-5)` | **Analisis Tren Bisnis:** Menghitung total `Income` (K) untuk `USA` (F) **HANYA** untuk 5 tahun terakhir (menggunakan `TODAY()`). **Impact:** Mendukung keputusan investasi dengan **data kinerja terkini** secara dinamis. |
| **10** | **Visualisasi Kontrol Data** | `=REPT("█", ROUND(L2, 0))` | **Visualisasi In-Cell:** Membuat **bar visual** (*Sparkline* Teks) yang panjangnya sesuai dengan `Score` (L2). **Impact:** Memudahkan **Quality Assurance (QA)** dan **review data cepat** secara visual tanpa grafik. |
| **11** | **Peringkat & Identifikasi Performer** | **Excel:** `=RANK.EQ(K2, K:K, 0)` **Sheets:** `=INDEX(FILTER(B:B, K:K=MAX(K:K)), 1, 1)` | **Metrik Kompetitif & Penemuan *Insight*:** Memberikan peringkat (rank) atau **Mengidentifikasi Nama Film *Top Performer*** (Pendapatan Maksimum) secara otomatis. **Impact:** **Otomatisasi laporan** dan penemuan *outlier* positif. |

---

### 🚀 3. Kesimpulan dan Nilai Jual

Kerangka kerja DQC ini adalah bukti kemampuan dalam:

1.  **Membangun *Framework* yang *Robust***: Mampu mendesain alur kerja data yang menjamin **kualitas dan validitas** dari hulu ke hilir.
2.  **Dukungan Operasional Cepat:** Menggunakan fungsi kondisional dan agregasi untuk menghasilkan **metrik kinerja dinamis** tanpa ketergantungan pada *BI Tools* yang kompleks.
3.  **Kesiapan Data:** Dataset akhir yang terjamin kualitasnya telah divalidasi dan siap diinput ke *platform* analisis lanjutan, mempercepat waktu *time-to-insight* (TTI).
