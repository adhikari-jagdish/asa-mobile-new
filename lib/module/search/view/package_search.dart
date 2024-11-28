import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/clickable_extension.dart';
import '../../../common_utils/view_utils/no_data_available_widget.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_style.dart';
import '../../packages/bloc/package_search_cubit.dart';
import '../../packages/model/package_model.dart';
import '../../packages/widget/package_listing_individual_design.dart';
import '../bloc/search_cubit.dart';

class PackageSearch extends StatefulWidget {
  PackageSearch({Key? key, required this.packagesList}) : super(key: key);

  List<PackageModel> packagesList;

  @override
  State<PackageSearch> createState() => _PackageSearchState();
}

class _PackageSearchState extends State<PackageSearch> {
  final ScrollController scrollController = ScrollController();
  List<PackageModel> packages = [];
  final textFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packages = widget.packagesList;
    textFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        context.read<SearchCubit>().emit(SearchInitial());
        if (textFocus.hasFocus) {
          textFocus.unfocus();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ).clickable(() {
            Navigator.pop(context);
            context.read<SearchCubit>().emit(SearchInitial());
            if (textFocus.hasFocus) {
              textFocus.unfocus();
            }
          }),
          title: TextFormField(
            focusNode: textFocus,
            onFieldSubmitted: (val) {
              if (val.isNotEmpty) {
                print('Value $val');
                context.read<SearchCubit>().searchPackages(searchText: val);
              }
            },
            decoration: InputDecoration(
              hintText: CommonStrings.destinationThemeMore,
              hintMaxLines: 1,
              hintStyle: CustomStyle.blackTextMedium.copyWith(
                fontSize: 12.sp,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(4),
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, searchState) {
                if (searchState is SearchSuccess) {
                  packages = searchState.packages;
                } else if (searchState is SearchLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          child: Text("index: $index"),
                        );
                      },
                    ),
                  );
                } else if (searchState is SearchError) {
                  if (packages.isNotEmpty) packages.clear();
                }
                return packages.isNotEmpty
                    ? LayoutGrid(
                        columnGap: 4,
                        rowGap: 4,
                        columnSizes: [1.fr, 1.fr],
                        rowSizes: List<IntrinsicContentTrackSize>.generate((packages.length / 2).round(), (int index) => auto),
                        children: List<Widget>.generate(
                          packages.length,
                          (int index) => PackageListingIndividualDesign(
                            packageModel: packages[index],
                          ).clickable(() {
                            Navigator.pushNamed(context, RouteConstants.routePackageDetails, arguments: packages[index]);
                          }),
                        ),
                      )
                    : SizedBox(
                        height: context.heightPx / 1.5,
                        child: const Center(
                          child: NoDataAvailableWidget(
                            title: 'Packages',
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
