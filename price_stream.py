import time
import MetaTrader5 as mt5

def main():
    print("Mencoba menghubungkan ke MetaTrader 5...")
    if not mt5.initialize():
        print("Gagal menginisialisasi MT5. Kode error =", mt5.last_error())
        quit()
        
    print("Berhasil terhubung ke MetaTrader 5!")

    # Buat sub-folder 'txt' untuk wadah log
    import os
    if not os.path.exists('txt'):
        os.makedirs('txt')

    # AMBIL SELURUH SYMBOL MATA UANG YANG TERSEDIA PADA BROKER (Mode: Show All)
    symbols_data = mt5.symbols_get()
    if symbols_data is None:
        print("Gagal mengambil daftar simbol dari server broker.")
        mt5.shutdown()
        quit()
        
    # Memasukkan semua nama instrumen ke dalam daftar sasaran (Tanpa mempedulikan Visibilitas Market Watch)
    all_symbols = [s.name for s in symbols_data]
    print(f"Total {len(all_symbols)} Symbol instrumen ditemukan pada Broker ini.")

    print("Mengeksekusi 'Show All' di Market Watch (Proses ini mungkin memakan waktu)...")
    for symbol in all_symbols:
        mt5.symbol_select(symbol, True)

    print("\nMenyiapkan perekaman harga streaming (Log ke TXT)...")
    print("Tekan Ctrl+C untuk menghentikan program.")
    print("=" * 60)

    from datetime import datetime
    try:
        while True:
            # Tanda bahwa sistem sedang bekerja merekam 
            print(f"\r[ {datetime.now().strftime('%H:%M:%S')} ] Merekam log dari {len(all_symbols)} Pair ke /txt (1 Detik/baris)...", end='', flush=True)

            for symbol in all_symbols:
                tick = mt5.symbol_info_tick(symbol)
                info = mt5.symbol_info(symbol)
                
                if tick is not None and info is not None:
                    spread = round((tick.ask - tick.bid) / info.point)
                    # Waktu milisecond presisi (Format YYYY-MM-DD HH:MM:SS.mmm)
                    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
                    
                    # Menyusun String Catatan Baris 
                    log_line = f"[{timestamp}], Bid: {tick.bid:.5f}, Ask: {tick.ask:.5f}, Spread: {spread}\n"
                    
                    # Menempel (Append) rekam harga ke file uniknya masing-masing
                    with open(f"txt/{symbol}.txt", "a") as file_db:
                        file_db.write(log_line)
                        
            # Delay dikunci 1 DETIK agar file TXT di log secara tertata tanpa hiper-spam
            time.sleep(1) 
            
    except KeyboardInterrupt:
        print("\n\nPerekaman dihentikan paksa oleh pengguna (KeyboardInterrupt).")
    finally:
        mt5.shutdown()
        print("Koneksi MetaTrader 5 diputus secara aman.")

if __name__ == "__main__":
    main()
