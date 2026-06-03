import 'package:chopper/chopper.dart';

/// A custom JSON converter that avoids overriding the Content-Type header
/// for multipart requests in Chopper, preserving the correct multipart boundary headers.
class SafeJsonConverter extends JsonConverter {
  const SafeJsonConverter();

  @override
  Request convertRequest(Request request) {
    if (request.multipart) {
      // Do not force content-type to application/json for multipart requests
      return request;
    }
    return super.convertRequest(request);
  }
}
