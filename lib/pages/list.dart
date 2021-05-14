import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/search/models.dart';
import 'package:dnew/logic/settings/models.dart';
import 'package:dnew/logic/settings/controllers.dart';
import 'package:dnew/routes.dart';
import 'package:dnew/widgets/loading.dart';
import 'package:dnew/widgets/search_appbar.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:dnew/widgets/list.dart';
import 'package:dnew/widgets/web_padding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var searchQuery =
        (ModalRoute.of(context)!.settings.arguments as SearchQuery?) ??
            SearchQuery.text();

    var pagingController = useMemoized(
      () => PagingController<int, DiaryRecord>(firstPageKey: 0),
    );
    useEffect(
      () {
        Future<void> fetchPage(int pageKey) async {
          try {
            final items = await context
                .read(diaryRecordControllerProvider.notifier)
                .getPage(from: pageKey, limit: 10);
            var isLastPage = items.length < 10;
            var nextPageKey = pageKey + 10;

            if (isLastPage) {
              pagingController.appendLastPage(items);
            } else {
              pagingController.appendPage(items, nextPageKey);
            }
          } catch (error) {
            pagingController.error = error;
          }
        }

        pagingController.addPageRequestListener(fetchPage);
        return pagingController.dispose;
      },
      [],
    );

    return WebPadding(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read(diaryRecordControllerProvider.notifier).resetState();
            pagingController.refresh();
          },
          child: CustomScrollView(
            slivers: [
              SearchAppBar(searchQuery: searchQuery),
              DiaryRecordList(controller: pagingController),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            var loadingOverlay = showLoadingOverlay(context);

            var record = DiaryRecord.blank(
              userId: FirebaseAuth.instance.currentUser!.uid,
            );
            record = record.copyWith(
              id: await context
                  .read(diaryRecordControllerProvider.notifier)
                  .create(record),
            );
            context.read(editableRecordProvider).state = record;

            loadingOverlay.remove();

            await Navigator.pushNamed(context, Routes.form);

            pagingController.refresh();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: MyBottomNav(),
      ),
    );
  }
}
