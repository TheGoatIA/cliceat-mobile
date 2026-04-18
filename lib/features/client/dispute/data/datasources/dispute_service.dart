import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;

part 'dispute_service.chopper.dart';

@ChopperApi(baseUrl: '/disputes')
abstract class DisputeService extends ChopperService {
  static DisputeService create([ChopperClient? client]) => _$DisputeService(client);

  @POST()
  @multipart
  Future<Response<Map<String, dynamic>>> createDispute({
    @Part('orderId') required String orderId,
    @Part('reason') required String reason,
    @Part('description') required String description,
    @PartFile('images') List<MultipartFile>? images,
  });

  @GET(path: '/me')
  Future<Response<Map<String, dynamic>>> getMyDisputes();
}
