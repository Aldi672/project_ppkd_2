import 'package:path/path.dart';
import 'package:project_2/app_crud/models/book.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Supaya hanya ada satu instance DatabaseHelper di seluruh aplikasi
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  // Kalau database sudah ada → pakai yang lama.
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Kalau belum ada → bikin baru
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // lokasi database di HP
    final path = join(dbPath, filePath); // digabung jadi alamat lengkap
    // Kalau database pertama kali dibuat → jalankan
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textTypeNullable = 'TEXT';
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title $textType,
        author $textType,
        description $textType,
        genre $textType,
        totalPages $integerType,
        currentPage INTEGER DEFAULT 0,
        status TEXT DEFAULT 'to_read',
        coverImagePath $textTypeNullable,
        dateAdded $textType,
        dateCompleted $textTypeNullable,
        image_path TEXT
      )
    ''');
  }

  Future<Book> createBook(Book book) async {
    final db = await instance.database;
    final id = await db.insert('books', book.toMap());
    return book.copyWith(id: id);
  }

  Future<Book?> readBook(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'books',
      columns: [
        'id',
        'title',
        'author',
        'description',
        'genre',
        'totalPages',
        'currentPage',
        'status',
        'coverImagePath',
        'dateAdded',
        'dateCompleted',
        'image_path',
      ],
      // Ambil data berdasarkan id.
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Ambil semua buku → urut dari terbaru
  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;
    const orderBy = 'dateAdded DESC';
    final result = await db.query('books', orderBy: orderBy);
    return result.map((json) => Book.fromMap(json)).toList();
  }

  // Bisa cari berdasarkan title, author, atau genre.
  Future<List<Book>> searchBooks(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'books',
      where: 'title LIKE ? OR author LIKE ? OR genre LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'dateAdded DESC',
    );
    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<List<Book>> getBooksByStatus(String status) async {
    final db = await instance.database;
    final result = await db.query(
      'books',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'dateAdded DESC',
    );
    return result.map((json) => Book.fromMap(json)).toList();
  }

  // Update data berdasarkan id.
  Future<int> updateBook(Book book) async {
    final db = await instance.database;
    return db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // Hapus data berdasarkan id.
  Future<int> deleteBook(int id) async {
    final db = await instance.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  // Dapetin jumlah semua buku.
  Future<int> getTotalBooks() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM books');
    return result.first['count'] as int;
  }

  // Dapetin jumlah buku yang sudah selesai.
  Future<int> getCompletedBooks() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM books WHERE status = ?',
      ['completed'],
    );
    return result.first['count'] as int;
  }

  // Dapetin jumlah buku yang sedang dibaca.
  Future<int> getCurrentlyReading() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM books WHERE status = ?',
      ['reading'],
    );
    return result.first['count'] as int;
  }

  // Tutup database kalau sudah tidak dipakai.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
