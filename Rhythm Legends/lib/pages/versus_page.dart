import 'dart:io';

import 'package:flutter/material.dart';

import 'versus_game_page.dart';

class VersusPage extends StatefulWidget {
  const VersusPage({super.key});

  @override
  State<VersusPage> createState() =>
      _VersusPageState();
}

class _VersusPageState
    extends State<VersusPage> {
  final TextEditingController ipController =
      TextEditingController();

  ServerSocket? server;

  Socket? socket;

  String hostIp = '';

  bool hosting = false;

  bool loading = false;

  // =========================
  // HOST
  // =========================

  Future<void> hostGame() async {
    try {
      setState(() {
        loading = true;
      });

      server = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        4040,
      );

      final interfaces =
          await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );

      for (final interface
          in interfaces) {
        for (final addr
            in interface.addresses) {
          if (!addr.isLoopback) {
            hostIp = addr.address;
          }
        }
      }

      hosting = true;

      loading = false;

      setState(() {});

      server!.listen((client) {
        socket = client;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                VersusGamePage(
              socket: socket!,
              isHost: true,
            ),
          ),
        );
      });
    } catch (e) {
      loading = false;

      setState(() {});

      debugPrint(
        'HOST ERROR: $e',
      );
    }
  }

  // =========================
  // JOIN
  // =========================

  Future<void> joinGame() async {
    try {
      socket = await Socket.connect(
        ipController.text.trim(),
        4040,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VersusGamePage(
            socket: socket!,
            isHost: false,
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'JOIN ERROR: $e',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Connection failed',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    ipController.dispose();

    server?.close();

    socket?.destroy();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              // =====================
              // TOP BAR
              // =====================

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color:
                          Colors.white,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'VERSUS MODE',
                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),
                ],
              ),

              const SizedBox(
                height: 50,
              ),

              // =====================
              // HOST BUTTON
              // =====================

              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors
                            .cyanAccent,
                    foregroundColor:
                        Colors.black,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  onPressed:
                      loading
                          ? null
                          : hostGame,
                  child: const Text(
                    'HOST',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // =====================
              // HOST IP BOX
              // =====================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                  22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(
                    0.05,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                  border: Border.all(
                    color: Colors
                        .cyanAccent
                        .withOpacity(
                      0.5,
                    ),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'HOST IP',
                      style: TextStyle(
                        color:
                            Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      hostIp.isEmpty
                          ? 'NOT STARTED'
                          : hostIp,
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        color:
                            Colors.cyanAccent,
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              // =====================
              // JOIN INPUT
              // =====================

              TextField(
                controller:
                    ipController,
                style:
                    const TextStyle(
                  color: Colors.white,
                ),
                decoration:
                    InputDecoration(
                  hintText:
                      'ENTER HOST IP',
                  hintStyle:
                      const TextStyle(
                    color:
                        Colors.white54,
                  ),
                  filled: true,
                  fillColor:
                      Colors.white
                          .withOpacity(
                    0.06,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =====================
              // JOIN BUTTON
              // =====================

              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors
                            .deepPurpleAccent,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  onPressed: joinGame,
                  child: const Text(
                    'JOIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 35,
              ),

              if (hosting)
                const Text(
                  'WAITING FOR PLAYER...',
                  style: TextStyle(
                    color:
                        Colors.cyanAccent,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}