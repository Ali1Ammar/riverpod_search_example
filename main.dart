import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchEnable = StateProvider((ref) => false);
final foucseNodeSearch = Provider((ref) => FocusNode());

final textControllerSearch =
    ChangeNotifierProvider((ref) => TextEditingController());

class SearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          final node = context.read(foucseNodeSearch);
          node.unfocus();
          final search = context.read(searchEnable);
          search.state = !search.state;
          if (search.state) {
            node.requestFocus();
          } else {
            node.unfocus();
          }
        });
  }
}

class TextFieldSearch extends ConsumerWidget {
  final void Function(String)? onChange;

  TextFieldSearch([this.onChange]);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final node = context.read(foucseNodeSearch);
    final textController = context.read(textControllerSearch);
    final search = watch(searchEnable);
    return MyFade(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildTextField(context, node, textController),
      ),
      visible: search.state,
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget buildTextField(
    BuildContext context,
    FocusNode node,
    TextEditingController cont,
  ) {
    final outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
        ));
    return TextField(
      maxLines: 1,
      focusNode: node,
      controller: cont,
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                style: BorderStyle.solid)),
        prefixIcon: IconButton(
          onPressed: () {
            node.unfocus();
            final s = context.read(searchEnable);
            s.state = !s.state;
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            cont.clear();
            // node.unfocus();
            // final s = context.read(searchEnable);
            // s.state = !s.state;
          },
          icon: Icon(
            Icons.cancel,
          ),
        ),
      ),
    );
  }
}
