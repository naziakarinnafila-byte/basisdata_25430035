# Modul 4 — Normalisasi dan Skema Relasional
## Contoh: Sistem Penjualan KOPMA

> **Tujuan:** Menormalisasi data penjualan agar data tidak berulang secara berlebihan dan lebih mudah dijaga konsistensinya.

---

## 1. Dari UNF ke 1NF

### 1.1 Bentuk UNF

Satu nota dapat memuat beberapa barang. Daftar barang pada nota merupakan grup berulang.

```text
NOTA_UNF (
    no_nota_penjualan,
    tgl_penjualan,
    kode_petugas,
    nama_petugas,
    no_anggota,
    nama_anggota,
    {
        kode_barang,
        nama_barang,
        qty_detail_penjualan,
        harga_satuan_detail_penjualan,
        subtotal_detail_penjualan
    },
    jumlah_penjualan,
    diskon_penjualan,
    total_penjualan
)
```

### 1.2 Bentuk 1NF

Grup berulang diubah sehingga setiap baris mewakili satu barang dalam satu nota. Kunci primer relasi awal ini adalah gabungan `(no_nota_penjualan, kode_barang)`.

```text
NOTA_1NF (
    no_nota_penjualan,
    kode_barang,
    tgl_penjualan,
    kode_petugas,
    nama_petugas,
    no_anggota,
    nama_anggota,
    nama_barang,
    qty_detail_penjualan,
    harga_satuan_detail_penjualan,
    subtotal_detail_penjualan,
    jumlah_penjualan,
    diskon_penjualan,
    total_penjualan
)
```

---

## 2. Dependensi Fungsional

Dependensi fungsional (FD) diturunkan dari aturan bisnis Pertemuan 2, bukan hanya dari isi spreadsheet.

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | `no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota` | AB-01 |
| FD2 | `kode_petugas → nama_petugas` | Data petugas |
| FD3 | `no_anggota → nama_anggota` | AB-05 |
| FD4 | `kode_barang → nama_barang` | Data barang |
| FD5 | `(no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan` | AB-04 |
| FD6 | `(qty_detail_penjualan, harga_satuan_detail_penjualan) → subtotal_detail_penjualan` | Nilai turunan |

---

## 3. Menuju 2NF dan 3NF

### 3.1 Bentuk Normal Kedua (2NF)

Pada relasi 1NF, sebagian atribut hanya bergantung pada sebagian dari kunci komposit. Informasi nota dipisahkan ke relasi `PENJUALAN`, informasi barang ke relasi `BARANG`, dan informasi jumlah serta harga saat transaksi disimpan pada `DETAIL_PENJUALAN`.

### 3.2 Bentuk Normal Ketiga (3NF)

Di relasi penjualan terdapat ketergantungan transitif:

- `no_nota_penjualan → kode_petugas → nama_petugas`
- `no_nota_penjualan → no_anggota → nama_anggota`

Karena itu, data petugas dan anggota dipisahkan ke relasi masing-masing.

### 3.3 Skema relasional hasil normalisasi

```text
PENJUALAN (
    no_nota_penjualan [PK],
    tgl_penjualan,
    kode_petugas [FK],
    no_anggota [FK],
    bayar_penjualan
)

DETAIL_PENJUALAN (
    no_nota_penjualan [PK, FK],
    kode_barang [PK, FK],
    qty_detail_penjualan,
    harga_satuan_detail_penjualan
)

BARANG (
    kode_barang [PK],
    nama_barang,
    kategori_barang,
    harga_jual_barang,
    stok_barang,
    stok_min_barang
)

PETUGAS (
    kode_petugas [PK],
    nama_petugas,
    peran_petugas
)

ANGGOTA (
    no_anggota [PK],
    nim_anggota,
    nama_anggota,
    prodi_anggota,
    no_hp_anggota,
    status_anggota,
    tgl_daftar_anggota
)
```

**Keterangan:** PK = kunci primer dan FK = kunci tamu. Skema di atas merangkum hasil normalisasi awal; pada skema kanonik, kunci pengganti seperti `id_penjualan`, `id_barang`, `id_petugas`, dan `id_anggota` juga dapat digunakan.

---

## 4. Keputusan Penyimpanan Nilai Turunan

| Atribut | Keputusan | Alasan |
|---|---|---|
| `subtotal_detail_penjualan` | Tidak disimpan | Dapat dihitung dari kuantitas dikalikan harga satuan transaksi. |
| `jumlah_penjualan` | Tidak disimpan | Dapat dihitung dengan menjumlahkan subtotal setiap detail penjualan. |
| `total_penjualan` | Tidak disimpan pada tabel operasional | Dapat dihitung dari jumlah penjualan dan diskon sesuai aturan perhitungan. |
| `harga_satuan_detail_penjualan` | Disimpan | Mencatat harga yang berlaku saat transaksi, sehingga riwayat tidak berubah ketika harga barang diperbarui. |

Keputusan tidak menyimpan nilai turunan mengikuti contoh materi. Jika sistem perlu menyimpan nominal pembayaran aktual sebagai bukti transaksi, aturan penyimpanan tersebut perlu dijelaskan secara terpisah.

---

## 5. Mencocokkan dengan Skema Kanonik

### 5.1 Pemeriksaan PK, UNIQUE, dan FK

| Tabel | Kunci primer (PK) | Kunci unik | Kunci tamu (FK) |
|---|---|---|---|
| `petugas` | `id_petugas` | `kode_petugas` | — |
| `anggota` | `id_anggota` | `no_anggota`, `nim_anggota` | — |
| `barang` | `id_barang` | `kode_barang` | — |
| `pemasok` | `id_pemasok` | — | — |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_anggota` (boleh NULL) |
| `detail_penjualan` | `(id_penjualan, id_barang)` | — | `id_penjualan`, `id_barang` |
| `pembelian` | `id_pembelian` | — | `id_pemasok` |
| `detail_pembelian` | `(id_pembelian, id_barang)` | — | `id_pembelian`, `id_barang` |

### 5.2 Pemeriksaan BCNF

Setiap determinan pada dependensi fungsional nontrivial harus merupakan kunci kandidat. Contohnya, `kode_barang` menentukan `nama_barang`, sehingga `kode_barang` harus unik pada tabel barang. Pada tabel detail, gabungan kunci menentukan kuantitas dan harga transaksi. Jika ditemukan determinan yang bukan kunci kandidat, relasi tersebut perlu diperiksa kembali.

---

## 6. Kesimpulan

Normalisasi pada contoh KOPMA dimulai dari UNF, dilanjutkan ke 1NF, 2NF, dan 3NF. Proses ini memisahkan data nota, barang, petugas, dan anggota berdasarkan dependensi fungsionalnya. Nilai yang dapat dihitung dipertimbangkan untuk tidak disimpan sebagai data terpisah, sedangkan harga satuan saat transaksi tetap dicatat agar riwayat penjualan tidak berubah ketika harga barang diperbarui.
