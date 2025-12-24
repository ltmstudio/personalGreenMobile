import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/data/models/contacts_model.dart';
import 'package:hub_dom/presentation/bloc/contacts/contacts_cubit.dart';
import 'widgets/support_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContactsCubit>().loadContacts();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll('-', '').replaceAll(' ', '');

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanedNumber,
    );

    try {
      await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось совершить звонок')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.contacts)),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ContactsError) {
            return Center(child: Text(state.message));
          }

          final items = state is ContactsLoaded
              ? state.contacts
              : <ContactsModel>[];

          if (items.isEmpty) {
            return const Center(child: Text('Нет контактов'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return SupportItemWidget(
                title: item.title,
                icon: IconAssets.call,
                color: AppColors.green,
                subTitle: item.number,
                onTap: () => _makePhoneCall(item.number),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          );
        },
      ),
    );
  }
}
