// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DatasetModel _$DatasetModelFromJson(Map<String, dynamic> json) =>
    _DatasetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      sourcePath: json['source_path'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      state:
          $enumDecodeNullable(_$DatasetStateEnumMap, json['state']) ??
          DatasetState.s2Registered,
      adminDecision:
          $enumDecodeNullable(_$AdminDecisionEnumMap, json['admin_decision']) ??
          AdminDecision.pending,
      rejectionReason: json['rejection_reason'] as String?,
      reviewerId: json['reviewer_id'] as String?,
      reviewerName: json['reviewer_name'] as String?,
      reviewStartedAt: json['review_started_at'] == null
          ? null
          : DateTime.parse(json['review_started_at'] as String),
      reviewCompletedAt: json['review_completed_at'] == null
          ? null
          : DateTime.parse(json['review_completed_at'] as String),
      reviewNote: json['review_note'] as String?,
      approverId: json['approver_id'] as String?,
      approverName: json['approver_name'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      publishedPath: json['published_path'] as String?,
      environment:
          $enumDecodeNullable(_$EnvironmentEnumMap, json['environment']) ??
          Environment.production,
      organizationId: json['organization_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DatasetModelToJson(_DatasetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'source_path': instance.sourcePath,
      'metadata': instance.metadata,
      'state': _$DatasetStateEnumMap[instance.state]!,
      'admin_decision': _$AdminDecisionEnumMap[instance.adminDecision]!,
      'rejection_reason': instance.rejectionReason,
      'reviewer_id': instance.reviewerId,
      'reviewer_name': instance.reviewerName,
      'review_started_at': instance.reviewStartedAt?.toIso8601String(),
      'review_completed_at': instance.reviewCompletedAt?.toIso8601String(),
      'review_note': instance.reviewNote,
      'approver_id': instance.approverId,
      'approver_name': instance.approverName,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'published_at': instance.publishedAt?.toIso8601String(),
      'published_path': instance.publishedPath,
      'environment': _$EnvironmentEnumMap[instance.environment]!,
      'organization_id': instance.organizationId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$DatasetStateEnumMap = {
  DatasetState.s2Registered: 's2_registered',
  DatasetState.s3InReview: 's3_in_review',
  DatasetState.s4ReviewDone: 's4_review_done',
  DatasetState.s5AdminDecision: 's5_admin_decision',
  DatasetState.s6Published: 's6_published',
};

const _$AdminDecisionEnumMap = {
  AdminDecision.pending: 'pending',
  AdminDecision.approved: 'approved',
  AdminDecision.rejected: 'rejected',
};

const _$EnvironmentEnumMap = {
  Environment.development: 'development',
  Environment.production: 'production',
};
