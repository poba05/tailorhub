import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/clients_category.dart';
import 'package:tailorhub/utils/name_utils.dart';

class ClientContainer extends StatelessWidget {
  final Clients client;
  final VoidCallback? onTap;

  const ClientContainer({super.key, required this.client, this.onTap});

  Color _categoryColor(ClientsCategory category) {
    switch (category) {
      case ClientsCategory.vipClient:
        return AppColor.warning;
      case ClientsCategory.regularClient:
        return AppColor.first;
      case ClientsCategory.dormantCLient:
        return AppColor.grey;
      case ClientsCategory.newClient:
        return AppColor.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFF9F5FF), AppColor.plainWhite],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 1,
              color: AppColor.grey.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.first.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: .start,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  gradient: AppGradient.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    getInitials(client.name),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'DMSANS',
                          fontVariations: [FontVariation('wght', 700)],
                          color: AppColor.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _categoryColor(
                            client.category,
                          ).withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          client.category.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'DMSANS',
                            fontVariations: [FontVariation('wght', 700)],
                            color: _categoryColor(client.category),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    client.phone ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 400)],
                      color: AppColor.grey,
                    ),
                  ),
                  Text(
                    client.email ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 400)],
                      color: AppColor.grey,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColor.grey.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
