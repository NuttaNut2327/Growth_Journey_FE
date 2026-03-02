import 'package:fe/pages/blog/models/blog_model.dart';

class BlogRepository {

  final List<Blog> _mockBlogs = [
      Blog(
        blogId: '1',
        userId: '123e4567-e89b-12d3-a456-426614174023', 
        name: 'Twilight', 
        imagePath: 'https://i.pinimg.com/1200x/3c/11/f6/3c11f6372fec64103de3eef197a33f6e.jpg', 
        creatTime: '2026-03-02 08:00:00',
        content: 'Today I took a walk in the park and practiced mindfulness. The fresh air and gentle sounds of nature really helped me feel more grounded. Remember, small steps count!',
        totalLikes: 5,
        isLikedByCurrentUser: false,
      ),
      Blog(
        blogId: '2',
        userId: '9f1c2d3e-4a5b-678c-9d0e-f1a2b3c4d5g8', 
        name: 'Amarela', 
        imagePath: 'https://i.pinimg.com/736x/0a/cc/da/0accda430a16bd9b5c7ad7d699d5f3d7.jpg', 
        creatTime: '2026-03-01 12:00:00',
        content: 'Sharing a gentle reminder: It\'s okay to not be okay. You don\'t have to be strong all the time. Reach out when you need support. You\'re not alone in this journey.',
        totalLikes: 10,
        isLikedByCurrentUser: false,
      ),
      Blog(
        blogId: '3',
        userId: '7b8c9d0e-1f23-4567-89ab-cdef01264589', 
        name: 'Pinkie pie', 
        imagePath: 'https://i.pinimg.com/736x/c9/74/23/c97423c2b49f178612406acb46c923f6.jpg', 
        creatTime: '2026-02-03 12:00:00',
        content: 'Started my gratitude journal today. Writing down three things I\'m grateful for each day is such a simple practice, but it really shifts my perspective. Highly recommend! ',
        totalLikes: 25,
        isLikedByCurrentUser: false,
      ),
      Blog(
        blogId: '4',
        userId: '9f1c2d3e-4a5b-678c-9d0e-f1a2b3c4d5g8', 
        name: 'Rainbowwwwwwwwwwwwwwwwwwwwwwwww', 
        imagePath: 'https://i.pinimg.com/1200x/d4/a3/c2/d4a3c2cf522a1880a3c519c1f3d9257e.jpg', 
        creatTime: '2026-02-04 12:00:00',
        content: 'This is a sample blog post by Rainbow.',
        totalLikes: 80,
        isLikedByCurrentUser: false,
      ),
      Blog(
        blogId: '5',
        userId: 'c1e8a245-9f73-4d62-8b0e-3a7c51f96a9c', 
        name: 'Applejack', 
        imagePath: 'https://i.pinimg.com/736x/1d/1c/43/1d1c430d3e82f15361cbffe4643a2029.jpg', 
        creatTime: '2025-12-05 12:00:00',
        content: 'This is a sample blog post by Applejack.',
        totalLikes: 96,
        isLikedByCurrentUser: false,
      ),
      Blog(
        blogId: '6',
        userId: '5d7a3b90-e214-4cfa-9b86-41f0d2e9a2c4', 
        name: 'Rarity', 
        imagePath: 'https://i.pinimg.com/736x/e7/48/08/e74808d81ad6ed6c730f3d52cb569d0e.jpg', 
        creatTime: '2025-01-06 12:00:00',
        content: 'This is a sample blog post by Rarity.',
        totalLikes: 125,
        isLikedByCurrentUser: false,
      ),
  ];

  Future<List<Blog>> getBlogs() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockBlogs;
  }
}
