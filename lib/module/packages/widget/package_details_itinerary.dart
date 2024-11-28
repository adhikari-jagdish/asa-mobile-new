import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/theme/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines/timelines.dart';

import '../../../common_utils/common_strings.dart';
import '../../../theme/custom_style.dart';
import '../model/itinerary_model.dart';
import '../view/package_details_view_more_screen.dart';

class PackageDetailsItinerary extends StatelessWidget {
  const PackageDetailsItinerary({Key? key, required this.itineraries}) : super(key: key);

  final List<ItineraryModel> itineraries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            CommonStrings.itinerary,
            style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
          ),
        ),
        //sboxH10,
        ItineraryTitles(
          itineraries: itineraries,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Read More ",
                  style: CustomStyle.blackTextSemiBold.copyWith(color: CustomColor.color2a8dc8, fontSize: 12.sp),
                ),
                const WidgetSpan(
                  child: Icon(Icons.arrow_drop_down_outlined, size: 14),
                ),
              ],
            ),
          ).clickable(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PackageDetailsViewMoreScreen(
                  title: CommonStrings.itinerary,
                  itineraries: itineraries,
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}

class ItineraryTitles extends StatelessWidget {
  const ItineraryTitles({
    Key? key,
    required this.itineraries,
    this.shouldShowAll = false,
  }) : super(key: key);

  final List<ItineraryModel> itineraries;
  final bool shouldShowAll;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: const Color(0xff9b9b9b),
        fontSize: 12.5.sp,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: const Color(0xff989898),
            indicatorTheme: const IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: const ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: shouldShowAll
                ? itineraries.length
                : itineraries.length <= 3
                    ? itineraries.length
                    : 3,
            contentsBuilder: (_, index) {
              if (index == itineraries.length - 1) return null;

              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      itineraries[index].dayAndTitle!,
                      style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 15.sp),
                    ),
                    _ItineraryInnerTimeline(details: itineraries[index].details!),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (index.floor().isEven) {
                return const OutlinedDotIndicator(
                  borderWidth: 2.5,
                  backgroundColor: CustomColor.colorF58420,
                );
              }
              return const OutlinedDotIndicator(
                borderWidth: 2.5,
                backgroundColor: CustomColor.color2a8dc8,
              );
            },
            connectorBuilder: (_, index, ___) => const SolidLineConnector(
              color: null,
            ),
          ),
        ),
      ),
    );
  }
}

class _ItineraryInnerTimeline extends StatelessWidget {
  final List<String> details;

  const _ItineraryInnerTimeline({required this.details});

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == details.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) => !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                details[index - 1],
                style: CustomStyle.blackTextMedium.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            );
          },
          //itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 60.0,
          nodeItemOverlapBuilder: (_, index) => isEdgeIndex(index) ? true : null,
          itemCount: details.length + 2,
        ),
      ),
    );
  }
}
