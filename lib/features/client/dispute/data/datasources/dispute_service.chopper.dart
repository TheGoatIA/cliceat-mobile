// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'dispute_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DisputeService extends DisputeService {
  _$DisputeService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DisputeService;

  @override
  Future<Response<Map<String, dynamic>>> createDispute({
    required String orderId,
    required String reason,
    required String description,
    List<MultipartFile>? images,
  }) {
    final Uri $url = Uri.parse('/disputes');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('orderId', orderId),
      PartValue<String>('reason', reason),
      PartValue<String>('description', description),
      PartValueFile<List<MultipartFile>?>('images', images),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getMyDisputes() {
    final Uri $url = Uri.parse('/disputes/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
