import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  // Get total cache size in MB
  Future<String> getCacheSize() async {
    try {
      double totalSize = 0;

      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        totalSize += await _getDirSize(tempDir);
      }

      // Get app cache directory
      final cacheDir = await getApplicationCacheDirectory();
      if (await cacheDir.exists()) {
        totalSize += await _getDirSize(cacheDir);
      }

      // Convert to MB
      final sizeMB = totalSize / (1024 * 1024);
      if (sizeMB < 1) {
        return '${(sizeMB * 1024).toStringAsFixed(0)} KB';
      }
      return '${sizeMB.toStringAsFixed(1)} MB';
    } catch (e) {
      return '0 KB';
    }
  }

  // Get directory size in bytes
  Future<double> _getDirSize(Directory dir) async {
    double size = 0;
    try {
      if (await dir.exists()) {
        await for (final entity
            in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            size += await entity.length();
          }
        }
      }
    } catch (e) {
      // ignore
    }
    return size;
  }

  // Clear all cache
  Future<bool> clearCache() async {
    try {
      // Clear image cache
      await DefaultCacheManager().emptyCache();

      // Clear temp directory (not available on web — safe to skip)
      try {
        final tempDir = await getTemporaryDirectory();
        if (await tempDir.exists()) {
          await _clearDirectory(tempDir);
        }
      } catch (e) {
        // ignore if not available (e.g. Flutter Web)
      }

      // Clear app cache directory
      try {
        final cacheDir = await getApplicationCacheDirectory();
        if (await cacheDir.exists()) {
          await _clearDirectory(cacheDir);
        }
      } catch (e) {
        // ignore if not available
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Clear all files in a directory
  Future<void> _clearDirectory(Directory dir) async {
    try {
      await for (final entity
          in dir.list(recursive: false, followLinks: false)) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (e) {
          // skip files that can't be deleted
        }
      }
    } catch (e) {
      // ignore
    }
  }
}
