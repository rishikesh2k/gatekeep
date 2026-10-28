import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/provider/visitor_list_provider.dart';
import 'package:gatekeep/utils/app_dimensions.dart';
import 'package:gatekeep/view/base_selector.dart';
import 'package:gatekeep/view/base_view.dart';
import 'package:gatekeep/widgets/empty_state_widget.dart';
import 'package:gatekeep/widgets/local_data_banner.dart';
import 'package:gatekeep/widgets/loading_view.dart';
import 'package:gatekeep/widgets/visitor_card.dart';
import 'package:provider/provider.dart';

class VisitorListPage extends StatelessWidget {
  const VisitorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<VisitorListProvider>(
      builder: (context) {
        final provider = context.read<VisitorListProvider>();
        return Scaffold(
          appBar: AppBar(title: const Text('Visitors')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => provider.openForm(),
            tooltip: 'Register Visitor',
            child: const Icon(Icons.person_add_alt_1),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.medium, AppDimensions.small, AppDimensions.medium, 0),
                  child: BaseSelector<VisitorListProvider, String>(
                    selector: (m) => m.searchQuery,
                    builder: (context, searchQuery) => SearchBar(
                      controller: provider.searchController,
                      hintText: 'Search by name or mobile',
                      leading: const Icon(Icons.search),
                      onChanged: provider.setSearchQuery,
                      trailing: [
                        if (searchQuery.isNotEmpty)
                          IconButton(icon: const Icon(Icons.clear), onPressed: provider.clearSearch),
                      ],
                    ),
                  ),
                ),
                const StatusFilterBar(),
                BaseSelector<VisitorListProvider, bool>(
                  selector: (m) => m.isLocalData,
                  builder: (context, isLocalData) => isLocalData
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(AppDimensions.medium, 0, AppDimensions.medium, AppDimensions.small),
                          child: LocalDataBanner(),
                        )
                      : const SizedBox.shrink(),
                ),
                const Expanded(child: VisitorListBody()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<VisitorListProvider>();
    final options = <VisitorStatus?>[null, ...VisitorStatus.values];

    return BaseSelector<VisitorListProvider, VisitorStatus?>(
      selector: (m) => m.statusFilter,
      builder: (context, statusFilter) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium, vertical: AppDimensions.small),
        child: Row(
          children: options.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.small),
              child: ChoiceChip(
                label: Text(status?.label ?? 'All'),
                selected: statusFilter == status,
                onSelected: (selected) => provider.setStatusFilter(status),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class VisitorListBody extends StatelessWidget {
  const VisitorListBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<VisitorListProvider>();

    return BaseSelector<VisitorListProvider, (bool, String?, bool)>(
      selector: (m) => (m.isLoading, m.errorMessage, m.hasVisitors),
      builder: (context, value) {
        final (isLoading, errorMessage, hasVisitors) = value;

        if (isLoading && !hasVisitors) {
          return const LoadingView(message: 'Loading visitors...');
        }
        if (errorMessage != null && !hasVisitors) {
          return EmptyStateWidget(
            icon: Icons.cloud_off,
            title: 'Could not load visitors',
            message: errorMessage,
            buttonText: 'Try Again',
            onPressed: provider.refresh,
          );
        }
        if (!hasVisitors) {
          return EmptyStateWidget(
            icon: Icons.people_outline,
            title: 'No visitors yet',
            message: 'Registered visitors will appear here.',
            buttonText: 'Refresh',
            onPressed: provider.refresh,
          );
        }

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: BaseSelector<VisitorListProvider, List<Visitor>>(
            selector: (m) => m.filteredVisitors,
            builder: (context, list) {
              if (list.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyStateWidget(
                      icon: Icons.search_off,
                      title: 'No matching visitors',
                      message: 'Try a different name, number or filter.',
                    ),
                  ],
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(AppDimensions.medium, 0, AppDimensions.medium, 80),
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.small),
                itemBuilder: (context, index) {
                  final visitor = list[index];
                  return VisitorCard(
                    visitor: visitor,
                    onTap: () => provider.openDetails(visitor),
                    onEdit: () => provider.openForm(visitor),
                    onDelete: () => provider.deleteVisitor(visitor),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
