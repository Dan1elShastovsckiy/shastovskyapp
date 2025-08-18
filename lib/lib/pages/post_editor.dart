import 'package:flutter/material.dart';
import 'package:minimal/components/post_model.dart';
import 'package:minimal/components/post_repository.dart';

class PostEditor extends StatefulWidget {
  final Post? post;

  const PostEditor({super.key, this.post});

  @override
  State<PostEditor> createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _previewController;
  late TextEditingController _imageController;
  late TextEditingController _categoryController;
  late TextEditingController _contentController;
  final List<TextEditingController> _tagControllers = [];
  final PostRepository _postRepository = PostRepository();

  @override
  void initState() {
    super.initState();
    final post = widget.post;
    _titleController = TextEditingController(text: post?.title ?? '');
    _previewController = TextEditingController(text: post?.previewText ?? '');
    _imageController = TextEditingController(text: post?.imageUrl ?? '');
    _categoryController = TextEditingController(text: post?.category ?? '');
    _contentController = TextEditingController(text: post?.content ?? '');
    
    if (post != null) {
      for (final tag in post.tags) {
        _tagControllers.add(TextEditingController(text: tag));
      }
    } else {
      _tagControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Новый пост' : 'Редактирование'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePost,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Заголовок'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите заголовок';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _previewController,
                decoration: const InputDecoration(labelText: 'Краткое описание'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL изображения'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Категория'),
              ),
              ..._buildTagFields(),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Содержание'),
                maxLines: 20,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePost,
                child: const Text('Сохранить пост'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTagFields() {
    return [
      const SizedBox(height: 16),
      const Text('Теги:', style: TextStyle(fontWeight: FontWeight.bold)),
      ..._tagControllers.asMap().entries.map((entry) {
        final index = entry.key;
        final controller = entry.value;
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Тег ${index + 1}',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _removeTag(index),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      ElevatedButton(
        onPressed: _addTag,
        child: const Text('Добавить тег'),
      ),
      const SizedBox(height: 16),
    ];
  }

  void _addTag() {
    setState(() {
      _tagControllers.add(TextEditingController());
    });
  }

  void _removeTag(int index) {
    setState(() {
      _tagControllers.removeAt(index);
    });
  }

  void _savePost() async {
    if (_formKey.currentState!.validate()) {
      final tags = _tagControllers
          .map((c) => c.text.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final post = Post(
        id: widget.post?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        previewText: _previewController.text,
        imageUrl: _imageController.text,
        category: _categoryController.text,
        content: _contentController.text,
        tags: tags,
        publishDate: widget.post?.publishDate ?? DateTime.now(),
      );

      await _postRepository.savePost(post);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _previewController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    for (final controller in _tagControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}