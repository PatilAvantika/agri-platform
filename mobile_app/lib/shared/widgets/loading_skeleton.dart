import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// LoadingSkeleton - Better UX during loading states
class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// CardSkeleton - Skeleton for loading card content
class CardSkeleton extends StatelessWidget {
  final int itemCount;
  final double? cardHeight;

  const CardSkeleton({
    super.key,
    this.itemCount = 1,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          LoadingSkeleton(
            width: 120,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          // Subtitle skeleton
          LoadingSkeleton(
            width: 200,
            height: 12,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          // Content skeletons
          ...List.generate(itemCount, (index) {
            return [
              LoadingSkeleton(
                width: double.infinity,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
            ];
          }).expand((x) => x),
        ],
      ),
    );
  }
}

/// ProfileHeaderSkeleton - Skeleton for profile header
class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E8), Color(0xFFF0F8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Avatar skeleton
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name skeleton
                LoadingSkeleton(
                  width: 120,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                // Location skeleton
                LoadingSkeleton(
                  width: 160,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                // Badge skeleton
                LoadingSkeleton(
                  width: 140,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// MetricCardSkeleton - Skeleton for carbon metric cards
class MetricCardSkeleton extends StatelessWidget {
  const MetricCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon skeleton
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingSkeleton(
                  width: 80,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                LoadingSkeleton(
                  width: 60,
                  height: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                LoadingSkeleton(
                  width: 100,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ListSkeleton - Skeleton for list items
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final bool showIcons;

  const ListSkeleton({
    super.key,
    this.itemCount = 3,
    this.showIcons = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                if (showIcons) ...[
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: LoadingSkeleton(
                    width: double.infinity,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          if (index < itemCount - 1) const Divider(height: 1),
        ];
      }).expand((x) => x).toList(),
    );
  }
}

/// ButtonSkeleton - Skeleton for buttons
class ButtonSkeleton extends StatelessWidget {
  final double? width;
  final double height;

  const ButtonSkeleton({
    super.key,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
