import 'dart:developer' show log;

import 'package:flutter/foundation.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

import 'model/landscape_design_model.dart';

class LandscapeDesignRepository {
  final String _landscapeDesignEndPoint = "api/v1/landscape/with-survey";

  dynamic generateLandscapeDesign({LandscapeDesignRequestModel? request}) async {
    // if (kDebugMode) {
    //   await Future.delayed(Duration(seconds: 2));
    //   var response = {
    //     "success": true,
    //     "message": "Landscape generated successfully",
    //     "data": {
    //       "originalUrl":
    //           "https://plain-apac-prod-public.komododecks.com/202605/19/bkBEPfjjIxco70EkQI9i/image.jpg",
    //       // "https://thumbs.dreamstime.com/b/rohnert-park-california-jan-interior-photos-empty-apartment-rental-white-gray-walls-hardwood-floor-living-spaces-303544810.jpg",
    //       "gardenUrl":
    //           // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQawujaS3Jy1KjCRhrF_4cwFzEjnUD76L8CsQ&s",
    //           "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
    //       "description":
    //           "A luxurious modern tropical garden featuring green grass, palm trees, decorative pathways, ambient lighting, wooden seating, colorful flower beds, and a peaceful outdoor atmosphere.",
    //       "detectedSpace": {
    //         "spaceType": "balcony",
    //         "category": "outdoor",
    //         "confidence": "high",
    //         "reasoning":
    //             "The image shows a raised outdoor area with a railing, potted plants, and a view of the surrounding buildings, which is characteristic of a balcony.",
    //       },  
    //     },
    //   };
    //   return response;
    // }

    log("body is ${request?.toJson()}");
    var responsee = await ApiRepository.instance.post(
      _landscapeDesignEndPoint,
      body: request,
      showDefaultLoader: false,
      showRunTimeError: false,
      rethrowExceptions: true,
    );
    return responsee;
  }
}
