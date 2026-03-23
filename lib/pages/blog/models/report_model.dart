import 'package:fe/pages/blog/enum/report_type.dart';

class Report {
  final String blogId;
  final ReportType reason;

  Report({required this.blogId, required this.reason});

  Map<String, dynamic> toJson() {
    return {
      'blog_id': blogId,
      'reason': reason.name,
    };
  }
}