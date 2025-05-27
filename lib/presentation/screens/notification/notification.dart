part of 'notification_imports.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(NotificationInitialFetchDataEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<NotificationBloc>().add(NotificationLoadMoreDataEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listenWhen: (previous, current) => current is NotificationActionState,
      buildWhen: (previous, current) => current is! NotificationActionState,
      listener: (context, state) {
        if (state is NotificationErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is NotificationAcceptShareNoteSuccessActionState) {
          AutoRouter.of(context).push(NoteShareScreenRoute());
          TLoaders.successSnackBar(context,
              title: 'Success', message: 'Accept shared note successfully');
        } else if (state is NotificationAcceptShareNoteErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NotificationLoadingState:
            return Scaffold(
              appBar: AppBar(
                title: Text('Notifications'),
                automaticallyImplyLeading: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                centerTitle: true,
              ),
              body: const Center(child: TLoadingSpinkit.loadingPage),
            );
          case NotificationSuccessState:
            final notifications = state as NotificationSuccessState;
            return Scaffold(
              appBar: AppBar(
                title: Text('Notifications'),
                automaticallyImplyLeading: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                centerTitle: true,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<NotificationBloc>()
                      .add(NotificationInitialFetchDataEvent());
                },
                child: notifications.notificationModel.data?.isEmpty ?? true
                    ? Center(
                        child: TEmptyWidget(
                          subTitle: 'No notifications yet',
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(TSizes.defaultSpace),
                        itemCount: notifications.notificationModel.data!.length,
                        itemBuilder: (context, index) {
                          final notification =
                              notifications.notificationModel.data![index];
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: TColors.grey, width: 1),
                                  color: TColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: TColors.primary.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]),
                              padding: EdgeInsets.all(TSizes.spaceBtwItems),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.notiContent ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  SizedBox(height: TSizes.sm),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Utils.getTimeAgo(
                                            notification.createdAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      if (notification.notiOptions != null)
                                        GestureDetector(
                                          onTap: () {
                                            final options = jsonDecode(
                                                notification.notiOptions!);
                                            context
                                                .read<NotificationBloc>()
                                                .add(
                                                  NotificationAcceptShareNoteEvent(
                                                    tokenId: options[
                                                        'tokenShareLink'],
                                                  ),
                                                );
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Iconsax.send_2,
                                                color: TColors.primary,
                                              ),
                                              SizedBox(width: TSizes.sm),
                                              Text(
                                                'Accept',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                        color: TColors.primary),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          case NotificationErrorState:
            return Scaffold(
              appBar: AppBar(
                title: Text('Notifications'),
                automaticallyImplyLeading: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              ),
              body: Center(
                child: TEmptyWidget(
                  subTitle: 'Failed to load notifications',
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
