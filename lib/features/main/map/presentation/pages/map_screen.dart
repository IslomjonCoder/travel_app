import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/core/helpers/location.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/presentation/manager/place/place_cubit.dart';
import 'package:travel_app/features/main/home/presentation/pages/place_detail.dart';
import 'package:travel_app/generated/l10n.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late ClusterManager _manager;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _iconCache = {};

  final CameraPosition _parisCameraPosition = const CameraPosition(
    target: LatLng(41.318298289357465, 69.26975805312395),
    zoom: 10,
  );

  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager([List<PlaceModel> places = const []]) {
    return ClusterManager<PlaceMarKerModel>(
      places.map(
        (e) => PlaceMarKerModel(
          name: e.name,
          latLng: LocationHelper.convertWkb(e.location),
          category: e.category,
          place: e,
        ),
      ),
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 12, 13, 14.5, 15, 16.0, 16.5, 20.0],
      extraPercent: 0.2,
      stopClusteringZoom: 20.0,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  Future<Marker> Function(Cluster<PlaceMarKerModel>) get _markerBuilder => (cluster) async {
        final icon = cluster.isMultiple
            ? await _getClusterIcon(cluster.count)
            : await _getCategoryIcon(cluster.items.first.place.images.isEmpty ? cluster.items.first.category.image : cluster.items.first.place.images.first);
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          infoWindow: InfoWindow(
            title: cluster.isMultiple ? 'Cluster' : cluster.items.first.name,
            snippet: cluster.isMultiple
                ? 'Contains ${cluster.count} items'
                : 'Category: ${cluster.items.first.category.name}',
          ),
          onTap: () {
            if (!cluster.isMultiple) {
              _onMarkerTap(cluster.items.first);
            }
          },
          icon: icon,
        );
      };

  Future<BitmapDescriptor> _getCategoryIcon(String imageUrl) async {
    if (_iconCache.containsKey(imageUrl)) {
      return _iconCache[imageUrl]!;
    }
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: 75);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List imageData = byteData!.buffer.asUint8List();

      // Draw circular image
      final PictureRecorder pictureRecorder = PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      final Paint paint = Paint();

      const double size = 75.0;

      // Draw circular background
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);
      // canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
      // Draw image
      paint.imageFilter = ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0);
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: const Offset(size / 2, size / 2), radius: size / 2)));

      canvas.drawImage(frameInfo.image, Offset.zero, paint);

      final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
      final imgData = await img.toByteData(format: ui.ImageByteFormat.png);
      final circleImageData = imgData!.buffer.asUint8List();

      final BitmapDescriptor icon = BitmapDescriptor.fromBytes(circleImageData);
      _iconCache[imageUrl] = icon;
      return icon;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<BitmapDescriptor> _getClusterIcon(int count) async {
    const size = 125;
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.8, paint1);

    final text = count.toString();
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: const TextStyle(fontSize: size / 3, color: Colors.white, fontWeight: FontWeight.normal),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void _onMarkerTap(PlaceMarKerModel placeMarker) {
    // Handle marker tap
    // For example, navigate to detail screen or show more info
    context.push(PlaceDetail(place: placeMarker.place));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).map)),
      body: BlocListener<PlaceCubit, PlaceState>(
        listener: (context, state) {
          _manager = _initClusterManager(state.places);
          if (_controller != null) _manager.setMapId(_controller!.mapId);
          setState(() {});
        },
        child: GoogleMap(

          initialCameraPosition: _parisCameraPosition,
          onMapCreated: (controller) {
            _controller = controller;
            _manager.setMapId(controller.mapId);
          },
          markers: _markers,
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap,
        ),
      ),
    );
  }
}

class PlaceMarKerModel with ClusterItem {
  final String name;
  final LatLng latLng;
  final bool? isClosed;
  final CategoryModel category;
  final PlaceModel place;

  PlaceMarKerModel({
    required this.name,
    required this.latLng,
    this.isClosed,
    required this.category,
    required this.place,
  });

  @override
  LatLng get location => latLng;
}
