import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/ticket_report_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/bloc/ticket_report/ticket_report_cubit.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/report_page.dart'
    show reportTitleByType, AppDetailsReportPage;
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';

import '../../../../data/models/tickets/get_ticket_response_model.dart';

// --- FILTER ---
enum ReportFilter { all, manager, executor }

extension ReportFilterX on ReportFilter {
  String get label {
    switch (this) {
      case ReportFilter.all:
        return 'Все отчеты';
      case ReportFilter.manager:
        return 'От руководителя';
      case ReportFilter.executor:
        return 'От исполнителя';
    }
  }

  String? get type {
    switch (this) {
      case ReportFilter.all:
        return null;
      case ReportFilter.manager:
        return 'responsible';
      case ReportFilter.executor:
        return 'executor';
    }
  }
}

// --- PAGE / SECTION ---
class ReportsTabSection extends StatefulWidget {
  const ReportsTabSection({
    super.key,
    required this.ticketId,
    this.onAddReport,
    required this.ticketData,
  });

  final int ticketId;
  final Data? ticketData;

  final VoidCallback? onAddReport;

  @override
  State<ReportsTabSection> createState() => _ReportsTabSectionState();
}

class _ReportsTabSectionState extends State<ReportsTabSection> {
  ReportFilter _filter = ReportFilter.all;

  @override
  void initState() {
    super.initState();
    locator<ReportsCubit>().load(ticketId: widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chips
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: _FilterChips(
            value: _filter,
            onChanged: (v) => setState(() => _filter = v),
          ),
        ),

        // List
        Expanded(
          child: BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              if (state.status == ReportsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == ReportsStatus.failure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      state.error ?? 'Ошибка загрузки',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
                );
              }

              final items = _filter.type == null
                  ? state.items
                  : state.items.where((e) => e.type == _filter.type).toList();

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Нет отчетов',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 96),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => ReportCardV2(
                  report: items[i],
                  rawPhotos: widget.ticketData?.photos,
                  ticketId:  widget.ticketId,
                  ticketData: widget.ticketData,
                  // If you need approve/reject only for executor report:
                  showActions: items[i].type == 'executor',
                  onReject: () {
                    // TODO: your action (dialog -> API)
                    context.read<ApplicationDetailsBloc>().add(
                      RejectTicketEvent(widget.ticketId, rejectReason: 'Отклененно'),
                    );
                  },
                  onApprove: () {
                    // TODO: your action (dialog -> API)
                    context.read<ApplicationDetailsBloc>().add(AcceptTicketEvent(widget.ticketId));

                  },
                ),
              );
            },
          ),
        ),

        // Bottom button (Добавить отчет)
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: SizedBox(
            height: 46,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onAddReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F2937), // dark
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Добавить отчет'),
            ),
          ),
        ),
      ],
    );
  }
}

// --- CHIPS WIDGET ---
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.value, required this.onChanged});

  final ReportFilter value;
  final ValueChanged<ReportFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(ReportFilter v) {
      final selected = v == value;
      return ChoiceChip(
        label: Text(v.label),
        selected: selected,
        onSelected: (_) => onChanged(v),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF111827),
        ),
        backgroundColor: const Color(0xFFF3F4F6),
        selectedColor: const Color(0xFF111827),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(ReportFilter.all),
          const SizedBox(width: 8),
          chip(ReportFilter.manager),
          const SizedBox(width: 8),
          chip(ReportFilter.executor),
        ],
      ),
    );
  }
}

// --- CARD (matches screenshot style) ---
class ReportCardV2 extends StatelessWidget {
  const ReportCardV2({
    super.key,
    required this.report,
    this.rawPhotos,
    this.showActions = false,
    this.onReject,
    this.onApprove, this.ticketData, this.ticketId,
  });

  final TicketReport report;
  final Data? ticketData;

  final dynamic rawPhotos; // <-- важно
  final bool showActions;
  final int? ticketId;

  final VoidCallback? onReject;
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final title = reportTitleByType(report.type);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AppDetailsReportPage(
                    ticketData: ticketData,
                    ticketId: ticketId,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      report.createdAt,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  report.comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(report.createdBy.fullName),
            ),
            const SizedBox(height: 10),
            buildMiniPhotos(rawPhotos), // <-- фото как в твоем методе

            if (showActions) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionPill(
                      color: const Color(0xFFEF4444),
                      icon: Icons.close,
                      onTap: onReject,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionPill(
                      color: const Color(0xFF22C55E),
                      icon: Icons.check,
                      onTap: onApprove,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildMiniPhotos(dynamic rawPhotos) {
    final urls = parsePhotoUrls(rawPhotos);

    if (urls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ImageWithShimmer(imageUrl: urls[i], width: 46, height: 46),
        ),
      ),
    );
  }

  List<String> parsePhotoUrls(dynamic photos) {
    final List<String> photoUrls = [];

    if (photos != null && photos is List) {
      for (final photo in photos) {
        String? url;
        if (photo is String) {
          url = photo;
        } else if (photo is Map) {
          url =
              photo['link'] ??
              photo['url'] ??
              photo['path'] ??
              photo['image_url'] ??
              photo['photo_url'] ??
              photo['src'];
        }
        if (url != null && url.isNotEmpty) photoUrls.add(url);
      }
    }

    return photoUrls;
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: 0,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
