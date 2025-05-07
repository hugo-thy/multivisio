import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'api_service.dart';
import 'websocket_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService = ApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<Map<String, dynamic>> _alerts = [];
  List<Map<String, dynamic>> _validatedAlerts = [];
  List<dynamic> cctvFeeds = [];
  bool isLoading = true;
  bool _showValidated = false;


@override
void initState() {
  super.initState();
  loadData();

  _webSocketService.alertsStream.listen((alert) async {
    setState(() {
      _alerts.insert(0, alert);
    });

    
    

  });
}

  void loadData() async {
    try {
      final alertsData = await apiService.fetchAlerts();
      final cctvFeedsData = await apiService.fetchCCTVFeeds();
      setState(() {
        if (_alerts.isEmpty) {
          _alerts = List<Map<String, dynamic>>.from(alertsData);
        }
        cctvFeeds = cctvFeedsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  void _showVideoDialog(BuildContext context, String feedUrl) {
    final dialogWidth = MediaQuery.of(context).size.width * 0.8;
    final fixedHeight = dialogWidth * (9 / 16);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            height: fixedHeight + 60,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Color(0xFF222B31), borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Center(child: VideoPlayerWidget(videoUrl: feedUrl)),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, size: 30, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context, Map<String, dynamic> alert, {bool isValidated = false}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(alert['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close, color: Color(0xFFE22227)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📝 ${alert['details'] ?? 'Pas de détails'}"),
              SizedBox(height: 8),
              Text("📅 Date : ${alert['date'] ?? 'N/A'}"),
              Text("⏰ Heure : ${alert['time'] ?? 'N/A'}"),
              Text("🧍 ID Personne : ${alert['person_id'] ?? 'N/A'}"),
              Text("🎒 ID Bagage : ${alert['baggage_id'] ?? 'N/A'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (isValidated) {
                    _alerts.add(alert);
                    _validatedAlerts.remove(alert);
                  } else {
                    _validatedAlerts.add(alert);
                    _alerts.remove(alert);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(isValidated ? "Annuler validation" : "Valider", style: TextStyle(color: isValidated ? Colors.red : Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222B31),
      appBar: AppBar(
        title: Text("CCTV Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF222B31),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFE22227)))
          : Row(
              children: [
                Container(
                  width: 180,
                  color: Color(0xFF55666E),
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cameras", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 10),
                      ...cctvFeeds.map((feed) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF222B31),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () => _showVideoDialog(context, feed['feed_url']),
                            child: Text("Cam ${feed['id']}", style: TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                Container(width: 1, color: Color(0xFF6C0102)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    color: Color(0xFFF5F5F5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_showValidated ? "Alertes validées" : "Alertes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF222B31))),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFFE22227),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Color(0xFFE22227)),
                                ),
                              ),
                              onPressed: () => setState(() => _showValidated = !_showValidated),
                              child: Text(_showValidated ? "⬅ Voir les alertes" : "✅ Voir validées"),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: (_showValidated ? _validatedAlerts : _alerts).length,
                              itemBuilder: (context, index) {
                                final alert = (_showValidated ? _validatedAlerts : _alerts)[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 12.0),
                                  elevation: 3,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Icon(Icons.warning, color: _showValidated ? Colors.green : Color(0xFFC7080C), size: 30),
                                    title: Text(alert['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC7080C))),
                                    subtitle: Text(alert['details'] ?? ''),
                                    onTap: () => _showAlertDialog(context, alert, isValidated: _showValidated),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayer(_controller),
        ),
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
              _isPlaying = !_isPlaying;
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


