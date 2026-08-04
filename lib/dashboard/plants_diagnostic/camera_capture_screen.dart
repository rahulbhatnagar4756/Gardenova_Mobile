import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/base/widgets/base_text.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('Camera initialization error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Captured Image
          if (_capturedImage != null)
            Positioned.fill(
              child: Center(
                child: Image.file(
                  width: double.infinity,
                  height: Get.height * .6,
                  File(_capturedImage!.path),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            )
          else if (_isInitialized)
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: Get.height * .6,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: AppColors.greenColor),
            ),

          // Overlay (Viewfinder)
          if (_capturedImage == null && _isInitialized)
            _buildViewfinderOverlay(),

          // Top Bar (Back Button)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildViewfinderOverlay() {
    return Stack(
      children: [
        // Darkened background outside the viewfinder
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: .5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Viewfinder Border
        Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greenColor, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        // Hint Text
        Positioned(
          top: MediaQuery.of(context).size.height * 0.5 + 170,
          left: 0,
          right: 0,
          child: Center(
            child: BaseText(
              text: 'Place the plant inside the box',
              textColor: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    if (_capturedImage != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.refresh,
            label: 'Retake',
            onTap: () {
              setState(() {
                _capturedImage = null;
              });
            },
          ),
          _buildActionButton(
            icon: Icons.check_circle,
            label: 'Done',
            isPrimary: true,
            onTap: () {
              Get.back(result: _capturedImage);
            },
          ),
        ],
      );
    }

    return Center(
      child: GestureDetector(
        onTap: _takePicture,
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5),
          ),
          child: Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.greenColor : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          BaseText(text: label, textColor: Colors.white, fontSize: 14),
        ],
      ),
    );
  }
}
