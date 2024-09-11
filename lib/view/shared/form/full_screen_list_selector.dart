import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/helper/keyboard_on.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FullScreenListSelector<T> extends StatefulWidget {
  final List<T> initialItems;
  final List<T> initialSelectedItems;
  final String title;
  final String subtitle;
  final Future<T> Function(String query)? onAddNewItem;
  final String Function(T item)? displayText;
  final Future Function(List<T> selectedItems) onSave;
  final bool multi;

  Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => this,
      ),
    );
  }

  const FullScreenListSelector({
    super.key,
    required this.initialItems,
    this.displayText,
    required this.initialSelectedItems,
    this.multi = true,
    required this.title,
    required this.subtitle,
    this.onAddNewItem,
    required this.onSave,
  }) : assert(multi || initialSelectedItems.length <= 1);

  @override
  State<FullScreenListSelector<T>> createState() =>
      _FullScreenListSelectorState<T>();
}

class _FullScreenListSelectorState<T> extends State<FullScreenListSelector<T>> {
  late List<T> selectedItems = widget.initialSelectedItems.toList();
  late List<T> items = widget.initialItems.toList();
  late final _converter = widget.displayText ?? (T item) => item.toString();
  String query = '';

  bool _loadingNew = false;

  set loadingNew(bool value) {
    setState(() {
      _loadingNew = value;
    });
  }

  late final TextEditingController controller = TextEditingController();

  Widget get createNewItem {
    if (widget.onAddNewItem == null) return const SizedBox.shrink();

    if (_loadingNew) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }
    return AnimatedTapButton(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        loadingNew = true;
        final newItem = await widget.onAddNewItem!(query);
        items.add(newItem);
        loadingNew = false;
        controller.clear();
        query = '';
        setState(() {
          selectedItems.add(newItem);
        });
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            const Spacer(),
            Text(
              'Dodaj novi $query',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white),
            ),
            const Flexible(
                child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.add),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final queriedItems = items
        .where((element) =>
            _converter(element).toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SafeArea(
            top: true,
            child: FirmusCustomAppBar(
              centerTitle: true,
              onPressed: () {
                GoRouter.of(context).pop();
              },
              text: widget.title,
            ),
          ),
          Text(
            widget.subtitle,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ConstrainedBody(
              center: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        fillColor: Colors.white.withOpacity(0.2),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText:
                            'Pretraži${widget.multi ? widget.onAddNewItem == null ? "" : ' ili dodaj' : ''}',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: queriedItems.isEmpty
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              createNewItem,
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: queriedItems.length,
                            itemBuilder: (context, index) {
                              final item = queriedItems[index];
                              return IntrinsicWidth(
                                child: AnimatedTapButton(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (!widget.multi) {
                                      selectedItems.clear();
                                    }

                                    setState(() {
                                      if (selectedItems.contains(item)) {
                                        selectedItems.remove(item);
                                      } else {
                                        selectedItems.add(item);
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        Text(
                                          _converter(item),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: selectedItems
                                                          .contains(item)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                        ),
                                        Flexible(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                              selectedItems.contains(item)
                                                  ? Icons.check
                                                  : null),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              if (ref.isKeyboardOn) return const SizedBox();
              return Column(
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  SaveButton(onTap: () async {
                    try {
                      await widget.onSave(selectedItems);
                    } catch (e) {
                      FirebaseCrashlytics.instance.recordError(
                          e, StackTrace.current,
                          reason: "Error saving ${widget.title} items");

                      //show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Greška prilikom spremanja, pokušajte kasnije."),
                      ));
                    }
                    context.pop();
                  }),
                  const SizedBox(
                    height: 52,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
