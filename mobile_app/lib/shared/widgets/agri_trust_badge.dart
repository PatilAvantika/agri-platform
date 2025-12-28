import 'package:flutter/material.dart';

/// TrustBadge - Verification and trust indicators
class TrustBadge extends StatelessWidget {
  final String status;
  final bool showIcon;
  final double? size;

  const TrustBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    switch (status.toLowerCase()) {
      case 'verified':
        badgeColor = const Color(0xFF2E7D32);
        badgeIcon = Icons.verified;
        badgeText = '✅ Verified Farmer';
        break;
      case 'pending':
        badgeColor = Colors.amber;
        badgeIcon = Icons.pending;
        badgeText = '🟡 Verification in Progress';
        break;
      case 'rejected':
        badgeColor = Colors.red;
        badgeIcon = Icons.cancel;
        badgeText = '❌ Verification Failed';
        break;
      default:
        badgeColor = Colors.grey;
        badgeIcon = Icons.help;
        badgeText = '⚪ Verification Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(badgeIcon, size: size ?? 16, color: badgeColor),
            const SizedBox(width: 6),
          ],
          Text(
            badgeText,
            style: TextStyle(
              fontSize: size ?? 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// VerificationItem - Individual verification status item
class VerificationItem extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isPending;
  final VoidCallback? onTap;

  const VerificationItem({
    super.key,
    required this.label,
    required this.isCompleted,
    this.isPending = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              isCompleted 
                  ? Icons.check_circle 
                  : isPending 
                      ? Icons.pending 
                      : Icons.radio_button_unchecked,
              color: isCompleted 
                  ? const Color(0xFF2E7D32)
                  : isPending 
                      ? Colors.amber 
                      : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? Colors.black87 : Colors.grey.shade600,
                  fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isPending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// TrustSignal - Trust indicators for carbon data
class TrustSignal extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? color;

  const TrustSignal({
    super.key,
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFF2E7D32)).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (color ?? const Color(0xFF2E7D32)).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color ?? const Color(0xFF2E7D32),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// ProfileHeader - Standardized profile header component
class ProfileHeader extends StatelessWidget {
  final String name;
  final String location;
  final String? profileImageUrl;
  final String verificationStatus;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.location,
    this.profileImageUrl,
    required this.verificationStatus,
    this.onEditTap,
  });

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
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF2E7D32),
                backgroundImage: profileImageUrl?.isNotEmpty == true
                    ? NetworkImage(profileImageUrl!) as ImageProvider
                    : null,
                child: profileImageUrl?.isEmpty != false
                    ? const Icon(Icons.person, size: 36, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Farmer',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.isNotEmpty 
                          ? '📍 $location'
                          : '📍 Location not set',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TrustBadge(status: verificationStatus),
                  ],
                ),
              ),
              if (onEditTap != null)
                IconButton(
                  onPressed: onEditTap,
                  icon: const Icon(Icons.edit, color: Color(0xFF2E7D32)),
                  tooltip: 'Edit Profile',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
