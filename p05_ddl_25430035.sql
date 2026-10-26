-- =====================================================================
-- p05_ddl_25430035.sql
-- Milestone Proyek 5 : DDL dan constraint, proyek Klinik Sehat ZI
-- DBMS               : MariaDB 10.4.32 (XAMPP 8.2.12), mesin InnoDB
--
-- Konvensi nama constraint: pk_<tabel>, fk_<tabel>_<tujuan>, uq_<tabel>_<kolom>,
--                           ck_<tabel>_<kolom>
--
-- RUJUKAN KODE AB-xx : p02_kebutuhan_data_25430035.md, 
--   AB-01 nomor pasien berbeda            -> uq_pasien_no (pk_pasien sebagai kunci pengganti)
--   AB-02 nomor kunjungan berbeda, satu pasien -> uq_kunjungan_no, fk_kunjungan_pasien
--   AB-03 pemeriksaan terkait kunjungan   -> fk_pemeriksaan_kunjungan
--   AB-04 resep berdasarkan pemeriksaan   -> fk_resep_pemeriksaan
--   AB-05 resep memuat obat, jumlah, aturan pemakaian -> detail_resep
--   AB-06 stok obat tidak negatif         -> ck_obat_stok
--   AB-07 pembayaran terkait kunjungan, nomor berbeda -> pk_pembayaran, fk_pembayaran_kunjungan
--   AB-08 akses data kesehatan            -> bukan struktur tabel (Modul 13)
--   AB-09 maksimal P + 2 = 11 jenis obat per resep -> tidak dapat dijaga CHECK (Modul 14)
--
-- NOMOR CETAK DOKUMEN (sesuai formulir sumber p02):
--   no_pasien    CHAR(11)  P-0001-2025
--   no_kunjungan CHAR(12)  KJ-0001-2025
--   no_resep     CHAR(11)  R-0001-2025
-- id_* tetap menjadi kunci primer (kunci pengganti); nomor cetak bersifat UNIQUE.
-- =====================================================================

-- Basis data dibuat di Modul 1. Jika perlu membuatnya sendiri:
-- CREATE DATABASE IF NOT EXISTS klinik_035
--   CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE klinik_035;

DROP TABLE IF EXISTS detail_penerimaan;
DROP TABLE IF EXISTS penerimaan;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_resep;
DROP TABLE IF EXISTS resep;
DROP TABLE IF EXISTS pemeriksaan;
DROP TABLE IF EXISTS kunjungan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS obat;
DROP TABLE IF EXISTS pasien;

-- ---------------------------------------------------------------------
-- 1. Tabel induk (master): tanpa kunci tamu
-- ---------------------------------------------------------------------

-- Master: satu baris = satu pasien. Kolom bertanda [DP] = data pribadi (AB-08).
CREATE TABLE pasien (
  id_pasien     INT                NOT NULL AUTO_INCREMENT,
  no_pasien     CHAR(11)           NOT NULL,              -- AB-01: nomor pasien, format P-0001-2025
  NIK           CHAR(16)           NOT NULL,              -- [DP] asumsi desain: NIK wajib
  nama_pasien   VARCHAR(100)       NOT NULL,              -- [DP]
  tanggal_lahir DATE               NOT NULL,              -- [DP]
  jenis_kelamin ENUM('L','P')      NOT NULL,              -- [DP] nilai dibatasi ENUM
  alamat        VARCHAR(255)       NULL,                  -- [DP]
  no_HP         VARCHAR(15)        NULL,                  -- [DP]
  CONSTRAINT pk_pasien     PRIMARY KEY (id_pasien),
  CONSTRAINT uq_pasien_no  UNIQUE (no_pasien),            -- AB-01: nomor pasien berbeda
  CONSTRAINT uq_pasien_nik UNIQUE (NIK)                   -- asumsi desain (Modul 4): satu NIK satu pasien
) ENGINE=InnoDB;

-- Master: satu baris = satu jenis obat.
CREATE TABLE obat (
  id_obat    INT            NOT NULL AUTO_INCREMENT,
  nama_obat  VARCHAR(100)   NOT NULL,
  satuan     VARCHAR(20)    NOT NULL,
  harga_obat DECIMAL(12,2)  NOT NULL,
  stok_obat  INT            NOT NULL DEFAULT 0,
  CONSTRAINT pk_obat       PRIMARY KEY (id_obat),
  CONSTRAINT ck_obat_harga CHECK (harga_obat >= 0),       -- asumsi desain: harga tidak boleh negatif
  CONSTRAINT ck_obat_stok  CHECK (stok_obat >= 0)         -- AB-06 / kamus data: stok tidak boleh kurang dari 0
) ENGINE=InnoDB;

-- Master: satu baris = satu pemasok obat.
CREATE TABLE pemasok (
  id_pemasok   INT           NOT NULL AUTO_INCREMENT,
  nama_pemasok VARCHAR(100)  NOT NULL,
  alamat       VARCHAR(255)  NULL,
  no_HP        VARCHAR(15)   NULL,
  CONSTRAINT pk_pemasok PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. Tabel dengan kunci tamu (induk dibuat lebih dulu)
-- ---------------------------------------------------------------------

-- Kepala transaksi: satu baris = satu kunjungan pasien.
CREATE TABLE kunjungan (
  id_kunjungan      INT          NOT NULL AUTO_INCREMENT,
  no_kunjungan      CHAR(12)     NOT NULL,                -- AB-02: nomor kunjungan, format KJ-0001-2025
  id_pasien         INT          NOT NULL,
  tanggal_kunjungan DATE         NOT NULL,
  jenis_kunjungan   VARCHAR(50)  NOT NULL,
  keluhan           TEXT         NULL,                    -- [DP] data kesehatan (AB-08)
  CONSTRAINT pk_kunjungan        PRIMARY KEY (id_kunjungan),
  CONSTRAINT uq_kunjungan_no     UNIQUE (no_kunjungan),        -- AB-02: nomor kunjungan berbeda
  CONSTRAINT fk_kunjungan_pasien FOREIGN KEY (id_pasien)       -- AB-02: kunjungan terhubung dengan satu pasien
    REFERENCES pasien (id_pasien)
) ENGINE=InnoDB;

-- Satu baris = satu pemeriksaan dalam satu kunjungan.
CREATE TABLE pemeriksaan (
  id_pemeriksaan    INT           NOT NULL AUTO_INCREMENT,
  id_kunjungan      INT           NOT NULL,
  hasil_pemeriksaan TEXT          NOT NULL,               -- [DP] data kesehatan (AB-08)
  diagnosis         VARCHAR(255)  NOT NULL,               -- [DP] data kesehatan (AB-08)
  CONSTRAINT pk_pemeriksaan           PRIMARY KEY (id_pemeriksaan),  -- AB-03
  CONSTRAINT fk_pemeriksaan_kunjungan FOREIGN KEY (id_kunjungan)     -- AB-03: pemeriksaan terkait kunjungan yang tercatat
    REFERENCES kunjungan (id_kunjungan)
) ENGINE=InnoDB;

-- Kepala resep: satu baris = satu resep dari satu pemeriksaan.
CREATE TABLE resep (
  id_resep       INT           NOT NULL AUTO_INCREMENT,
  no_resep       CHAR(11)      NOT NULL,                  -- nomor resep, format R-0001-2025
  id_pemeriksaan INT           NOT NULL,
  tanggal_resep  DATE          NOT NULL,
  dokter         VARCHAR(100)  NOT NULL,
  CONSTRAINT pk_resep             PRIMARY KEY (id_resep),        -- AB-04
  CONSTRAINT uq_resep_no          UNIQUE (no_resep),             -- kamus data: nomor resep berbeda
  CONSTRAINT fk_resep_pemeriksaan FOREIGN KEY (id_pemeriksaan)   -- AB-04: resep berdasarkan hasil pemeriksaan
    REFERENCES pemeriksaan (id_pemeriksaan)
) ENGINE=InnoDB;

-- Detail transaksi (entitas asosiatif resep x obat):
-- satu baris = satu jenis obat di dalam satu resep.
CREATE TABLE detail_resep (
  id_resep         INT           NOT NULL,
  id_obat          INT           NOT NULL,
  jumlah_obat      SMALLINT      NOT NULL,
  aturan_pemakaian VARCHAR(255)  NOT NULL,
  CONSTRAINT pk_detail_resep PRIMARY KEY (id_resep, id_obat),    -- satu jenis obat hanya sekali per resep (kunci komposit)
  CONSTRAINT fk_detail_resep_resep FOREIGN KEY (id_resep)        -- AB-05: rincian obat melekat pada resep; ikut terhapus bila resep dihapus
    REFERENCES resep (id_resep) ON DELETE CASCADE,
  CONSTRAINT fk_detail_resep_obat  FOREIGN KEY (id_obat)         -- AB-05: obat pada resep harus obat yang terdaftar; obat yang pernah diresepkan tidak boleh dihapus
    REFERENCES obat (id_obat),
  CONSTRAINT ck_detail_resep_jumlah CHECK (jumlah_obat > 0)      -- AB-05: jumlah obat tercatat dan bernilai > 0 (per baris)
) ENGINE=InnoDB;

-- Satu baris = satu pembayaran atas satu kunjungan.
CREATE TABLE pembayaran (
  id_pembayaran      INT                             NOT NULL AUTO_INCREMENT,
  id_kunjungan       INT                             NOT NULL,
  tanggal_pembayaran DATE                            NOT NULL,
  total_bayar        DECIMAL(12,2)                   NOT NULL,
  metode_pembayaran  ENUM('tunai','transfer','QRIS') NOT NULL,
  CONSTRAINT pk_pembayaran           PRIMARY KEY (id_pembayaran),   -- AB-07: nomor pembayaran berbeda
  CONSTRAINT fk_pembayaran_kunjungan FOREIGN KEY (id_kunjungan)     -- AB-07: pembayaran terkait kunjungan pasien
    REFERENCES kunjungan (id_kunjungan),
  CONSTRAINT ck_pembayaran_total CHECK (total_bayar >= 0)           -- kamus data: total_bayar tidak boleh negatif
) ENGINE=InnoDB;

-- Kepala penerimaan: satu baris = satu kali penerimaan obat dari pemasok.
CREATE TABLE penerimaan (
  id_penerimaan      INT   NOT NULL AUTO_INCREMENT,
  id_pemasok         INT   NOT NULL,
  tanggal_penerimaan DATE  NOT NULL,
  CONSTRAINT pk_penerimaan         PRIMARY KEY (id_penerimaan),
  CONSTRAINT fk_penerimaan_pemasok FOREIGN KEY (id_pemasok)         -- pemasok wajib ada
    REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

-- Detail transaksi (entitas asosiatif penerimaan x obat).
CREATE TABLE detail_penerimaan (
  id_penerimaan   INT       NOT NULL,
  id_obat         INT       NOT NULL,
  jumlah_diterima SMALLINT  NOT NULL,
  CONSTRAINT pk_detail_penerimaan PRIMARY KEY (id_penerimaan, id_obat),
  CONSTRAINT fk_detail_penerimaan_penerimaan FOREIGN KEY (id_penerimaan)  -- rincian ikut terhapus bila penerimaan dibatalkan
    REFERENCES penerimaan (id_penerimaan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_penerimaan_obat FOREIGN KEY (id_obat)
    REFERENCES obat (id_obat),
  CONSTRAINT ck_detail_penerimaan_jumlah CHECK (jumlah_diterima > 0)      -- jumlah per baris harus > 0
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Aturan yang TIDAK dapat dijaga CHECK / struktur tabel
-- ---------------------------------------------------------------------
-- Parameter personal (p02 bagian 9): P = (35 mod 9) + 1 = 9
--   batas maksimal item per transaksi = P + 2 = 11
--   AB-09 (p02 bagian 5): satu resep memuat paling banyak P + 2 = 11 jenis obat.
--
-- Menyangkut SATU BARIS  -> dijaga CHECK (sudah ada di atas):
--       ck_detail_resep_jumlah      jumlah_obat > 0
--       ck_detail_penerimaan_jumlah jumlah_diterima > 0
--       ck_obat_stok                stok_obat >= 0       (AB-06)
--
-- =====================================================================