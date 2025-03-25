import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Post {
  int id;
  String title;
  String caption;
  String imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.caption,
    required this.imageUrl,
  });
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({
    Key? key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            // Caption text
            Text(post.caption),
            SizedBox(height: 8),
            Image.network(
              post.imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return Text('Error loading image');
              },
            ),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostListPage(),
    );
  }
}

class PostListPage extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<Post> posts = [
    Post(
      id: 1,
      title: 'Post 1',
      caption: 'Amazing scenery!',
      imageUrl:
      'https://cdn0-production-images-kly.akamaized.net/ipCXTzX3F9ojmAGeMmrNRwTxbIc=/640x360/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3525017/original/020979200_1627547148-theleiofficial.jpeg',
    ),
    Post(
      id: 2,
      title: 'Post 2',
      caption: 'Another great view.',
      imageUrl:
      'https://cdn0-production-images-kly.akamaized.net/ipCXTzX3F9ojmAGeMmrNRwTxbIc=/640x360/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3525017/original/020979200_1627547148-theleiofficial.jpeg',
    ),
    Post(
      id: 3,
      title: 'Post 3',
      caption: 'Enjoying the moment!',
      imageUrl:
      'https://cdn0-production-images-kly.akamaized.net/ipCXTzX3F9ojmAGeMmrNRwTxbIc=/640x360/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3525017/original/020979200_1627547148-theleiofficial.jpeg',
    ),
  ];

  int _nextId = 4;

  void _addOrEditPost({Post? post}) {
    final isEditing = post != null;
    final titleController = TextEditingController(text: post?.title ?? '');
    final captionController = TextEditingController(text: post?.caption ?? '');
    final imageUrlController = TextEditingController(text: post?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Post' : 'New Post'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: captionController,
                  decoration: InputDecoration(labelText: 'Caption'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Save' : 'Add'),
              onPressed: () {
                final title = titleController.text;
                final caption = captionController.text;
                final imageUrl = imageUrlController.text;
                if (title.isNotEmpty &&
                    caption.isNotEmpty &&
                    imageUrl.isNotEmpty) {
                  setState(() {
                    if (isEditing) {
                      post.title = title;
                      post.caption = caption;
                      post.imageUrl = imageUrl;
                    } else {
                      posts.add(Post(
                        id: _nextId++,
                        title: title,
                        caption: caption,
                        imageUrl: imageUrl,
                      ));
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePost(Post post) {
    setState(() {
      posts.removeWhere((p) => p.id == post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(
            post: post,
            onEdit: () => _addOrEditPost(post: post),
            onDelete: () => _deletePost(post),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditPost(),
        child: Icon(Icons.add),
      ),
    );
  }
}
