import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/blog_model.dart';
import '../../providers/blog_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class BlogFormScreen extends StatefulWidget {
  final Blog? blog; // null untuk create, ada value untuk edit

  const BlogFormScreen({Key? key, this.blog}) : super(key: key);

  @override
  State<BlogFormScreen> createState() => _BlogFormScreenState();
}

class _BlogFormScreenState extends State<BlogFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _bannerController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = Constants.blogCategories[0];
  final List<String> _images = [];

  bool get isEditMode => widget.blog != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.blog!.title;
      _bodyController.text = widget.blog!.body;
      _bannerController.text = widget.blog!.banner;
      _selectedCategory = widget.blog!.category;
      _images.addAll(widget.blog!.images);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _bannerController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addImage() {
    final url = _imageUrlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _images.add(url);
        _imageUrlController.clear();
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final blog = Blog(
      id: isEditMode ? widget.blog!.id : '',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      body: _bodyController.text.trim(),
      banner: _bannerController.text.trim(),
      images: _images,
    );

    final blogProvider = context.read<BlogProvider>();
    bool success;

    if (isEditMode) {
      success = await blogProvider.updateBlog(widget.blog!.id, blog);
    } else {
      success = await blogProvider.createBlog(blog);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode ? 'Blog berhasil diupdate' : 'Blog berhasil dibuat',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(blogProvider.errorMessage ?? 'Terjadi kesalahan'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Blog' : 'Buat Blog Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Blog',
                hintText: 'Masukkan judul blog',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
              maxLines: 2,
            ),

            const SizedBox(height: 20),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
              ),
              items: Constants.blogCategories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // Banner URL
            TextFormField(
              controller: _bannerController,
              decoration: const InputDecoration(
                labelText: 'URL Banner',
                hintText: 'https://example.com/image.jpg',
                prefixIcon: Icon(Icons.image),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'URL Banner tidak boleh kosong';
                }
                if (!value.startsWith('http')) {
                  return 'URL harus dimulai dengan http:// atau https://';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Body
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Isi Konten',
                hintText: 'Tulis konten blog di sini...',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konten tidak boleh kosong';
                }
                if (value.length < 50) {
                  return 'Konten minimal 50 karakter';
                }
                return null;
              },
              maxLines: 10,
            ),

            const SizedBox(height: 24),

            // Additional Images Section
            const Divider(),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.photo_library, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Galeri Foto Tambahan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Add Image Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      hintText: 'URL Foto',
                      prefixIcon: Icon(Icons.add_photo_alternate),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addImage,
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primary,
                  iconSize: 32,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Images List
            if (_images.isNotEmpty)
              ...List.generate(_images.length, (index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _images[index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      _images[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      onPressed: () => _removeImage(index),
                    ),
                  ),
                );
              })
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Belum ada foto tambahan',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Submit Button
            Consumer<BlogProvider>(
              builder: (context, blogProvider, _) {
                return CustomButton(
                  text: isEditMode ? 'Update Blog' : 'Simpan Blog',
                  onPressed: _handleSubmit,
                  isLoading: blogProvider.isLoading,
                  icon: isEditMode ? Icons.update : Icons.save,
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
