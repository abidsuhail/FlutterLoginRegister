import 'package:login_application_1/model/post.dart';

class PostsList
{
  final List<Post> posts;
  PostsList({this.posts});
  factory PostsList.fromJson(List<dynamic> parsedJson) {

    List<Post> posts = parsedJson.map((i)=>Post.fromJson(i)).toList();
    return new PostsList(
      posts: posts,
    );
  }
}