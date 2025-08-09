import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:minimal/components/post_model.dart';

class PostRepository {
  static const String _postsPath = 'assets/posts/';

  // Загрузка всех постов
  Future<List<Post>> loadAllPosts() async {
    final manifest = await rootBundle.loadString('AssetManifest.json');
    final files = json
        .decode(manifest)
        .keys
        .where((key) => key.startsWith(_postsPath))
        .toList();

    final posts = <Post>[];
    for (final file in files) {
      if (file.endsWith('.json')) {
        final content = await rootBundle.loadString(file);
        final post = Post.fromJson(json.decode(content));
        posts.add(post);
      }
    }

    // Сортировка по дате публикации (новые сначала)
    posts.sort((a, b) => b.publishDate.compareTo(a.publishDate));
    return posts;
  }

  // Загрузка конкретного поста по ID
  Future<Post> loadPost(String id) async {
    final content = await rootBundle.loadString('$_postsPath$id.json');
    return Post.fromJson(json.decode(content));
  }

  // Метод для сохранения поста (для редактора)
  Future<void> savePost(Post post) async {
    final file = File('$_postsPath${post.id}.json');
    await file.writeAsString(json.encode(post.toJson()));
  }
}
