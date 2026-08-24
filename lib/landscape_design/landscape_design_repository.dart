import 'dart:developer' show log;

import 'package:flutter/foundation.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

import 'model/landscape_design_model.dart';

class LandscapeDesignRepository {
  final String _landscapeDesignEndPoint = "api/v1/landscape/with-survey";

  dynamic generateLandscapeDesign({
    LandscapeDesignRequestModel? request,
  }) async {
    if (kDebugMode) {
      await Future.delayed(Duration(seconds: 2));
      var response = {
        "success": true,
        "message": "Landscape generated successfully",
        "data": {
          "originalUrl":
              "https://plain-apac-prod-public.komododecks.com/202605/19/bkBEPfjjIxco70EkQI9i/image.jpg",
          // "https://thumbs.dreamstime.com/b/rohnert-park-california-jan-interior-photos-empty-apartment-rental-white-gray-walls-hardwood-floor-living-spaces-303544810.jpg",
          "gardenUrl":
              // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQawujaS3Jy1KjCRhrF_4cwFzEjnUD76L8CsQ&s",
              "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
          "description":
              "A luxurious modern tropical garden featuring green grass, palm trees, decorative pathways, ambient lighting, wooden seating, colorful flower beds, and a peaceful outdoor atmosphere.",
          "detectedSpace": {
            "spaceType": "balcony",
            "category": "outdoor",
            "confidence": "high",
            "reasoning":
                "The image shows a raised outdoor area with a railing, potted plants, and a view of the surrounding buildings, which is characteristic of a balcony.",
          },
          "recommendedPlants": {
            "region": "onboarding survey",
            "climate": "Dry / Arid",
            "plants": [
              {
                "commonName": "Basil",
                "latinName": "Ocimum basilicum",
                "type": "flowering",
                "sunlight": "partial_shade",
                "waterNeeds": "moderate",
                "notes":
                    "An edible herb suitable for partial sun and weekly watering indoors.",
              },
              {
                "commonName": "Mint",
                "latinName": "Mentha spicata",
                "type": "ground_cover",
                "sunlight": "partial_shade",
                "waterNeeds": "moderate",
                "notes":
                    "A hardy edible ground cover herb that thrives with occasional watering and partial sun.",
              },
              {
                "commonName": "Tomato",
                "latinName": "Solanum lycopersicum",
                "type": "flowering",
                "sunlight": "partial_shade",
                "waterNeeds": "moderate",
                "notes":"A popular edible plant that grows well indoors with partial sun and weekly watering.",
              },
              {
                "commonName": "Chili Pepper",
                "latinName": "Capsicum annuum",
                "type": "flowering",
                "sunlight": "partial_shade",
                "waterNeeds": "moderate",
                "notes":
                    "Edible and flowering plant suitable for indoor partial sun and moderate watering.",
              },
              {
                "commonName": "Lemon Balm",
                "latinName": "Melissa officinalis",
                "type": "shrub",
                "sunlight": "partial_shade",
                "waterNeeds": "low",
                "notes":
                    "A fragrant edible shrub that tolerates dry conditions and partial sun indoors.",
              },
              {
                "commonName": "Sweet Potato Vine",
                "latinName": "Ipomoea batatas",
                "type": "climber",
                "sunlight": "partial_shade",
                "waterNeeds": "low",
                "notes":
                    "A climber with edible tubers that adapts well to indoor partial sun and infrequent watering.",
              },
              {
                "commonName": "Parsley",
                "latinName": "Petroselinum crispum",
                "type": "shrub",
                "sunlight": "partial_shade",
                "waterNeeds": "moderate",
                "notes":
                    "A versatile edible herb that grows well indoors with partial sun and weekly watering.",
              },
            ],
          },
         
          "style": "Mediterranean Edible Courtyard",
        },
      };
      return response;
    }

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
