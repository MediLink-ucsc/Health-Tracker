// import 'package:flutter/material.dart';
// import 'package:health_tracker/Components/logout.dart';
// import '../../Components/custom_bottom_nav.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF0D9488);
//     const accentColor = Color(0xFFF1BE26);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Health Tracker'),
//         backgroundColor: primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Logout'),
//                   content: const Text('Are you sure you want to log out?'),
//                   actions: [
//                     TextButton(
//                       child: const Text('Cancel'),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     TextButton(
//                       child: const Text('Logout'),
//                       onPressed: () {
//                         Navigator.pop(context);
//                         appLogout(context);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Greeting & Profile
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: primaryColor,
//                     backgroundImage: AssetImage('assets/icon/user_2.png'),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           'Hello Anjula',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           'Welcome back to Health Tracker!',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.notifications_none),
//                     color: primaryColor,
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               // Spotlight Section
//               const SpotlightSection(),
//               const SizedBox(height: 24),
//
//               // Last Recorded Activity
//
//               // Quick Access Section
//               const Text(
//                 'Quick Access',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               GridView.count(
//                 crossAxisCount: 3,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 childAspectRatio: 0.9,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 children: [
//                   _QuickAccessItem(
//                     label: 'Lab Reports',
//                     iconAsset: 'assets/icon/lab_report_2.png',
//                   ),
//                   _QuickAccessItem(
//                     label: 'Clinics',
//                     iconAsset: 'assets/icon/clinic_2.png',
//                   ),
//                   _QuickAccessItem(
//                     label: 'My Profile',
//                     iconAsset: 'assets/icon/profile_2.png',
//                   ),
//                   _QuickAccessItem(
//                     label: 'Stats View',
//                     iconAsset: 'assets/icon/stats_2.png',
//                   ),
//                   _QuickAccessItem(
//                     label: 'Input Metrics',
//                     iconAsset: 'assets/icon/input_2.png',
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               Card(
//                 color: const Color(0xFFE0F2F1),
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.analytics, color: accentColor),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               'Last Recorded Activity',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'Blood Sugar: 120 mg/dL',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                             SizedBox(height: 2),
//                             Text(
//                               'Date: 2025-07-07',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Quick Access Item Widget
// class _QuickAccessItem extends StatelessWidget {
//   final String label;
//   final String iconAsset;
//
//   const _QuickAccessItem({required this.label, required this.iconAsset});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color(0xFFF9F9F9),
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {},
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(iconAsset, height: 50, width: 50),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 13),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Spotlight Section Widget
// class SpotlightSection extends StatefulWidget {
//   const SpotlightSection({super.key});
//
//   @override
//   State<SpotlightSection> createState() => _SpotlightSectionState();
// }
//
// class _SpotlightSectionState extends State<SpotlightSection> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   final List<String> _images = [
//     'assets/notice1.jpg',
//     'assets/ad1.jpeg',
//     'assets/drink.jpg',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF0D9488);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Spotlight',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 250,
//           child: Stack(
//             children: [
//               PageView.builder(
//                 controller: _pageController,
//                 itemCount: _images.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       image: DecorationImage(
//                         image: AssetImage(_images[index]),
//                         fit: BoxFit.cover,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.25),
//                           blurRadius: 10,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               // Dots Indicator
//               Positioned(
//                 bottom: 8,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     _images.length,
//                     (index) => Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       width: 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _currentPage == index
//                             ? primaryColor
//                             : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:health_tracker/Components/logout.dart';
import 'package:health_tracker/screens/Prescrption/view_prescription_screen.dart';
import 'package:health_tracker/screens/Visit%20Plans/view_lab_test_screen.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../services/auth_service.dart';
import '../Care Plans/care_plans_screen.dart';
import '../Clinic/clinic_screen.dart';
import '../Newsfeed/newsfeed_screen.dart';
import '../Metrics/metrices_summary_section.dart';
import '../Metrics/record_metrices_section.dart';
import '../Prescrption/prescriptions_screen.dart';
import '../Profile/profile_screen.dart';
import '../Reports/lab_reports_screen.dart';
import '../Visit Plans/lab_tests_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFF1BE26);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        Navigator.pop(context);
                        appLogout(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Profile
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: primaryColor,
                    backgroundImage: const AssetImage('assets/icon/user_2.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hello Anjula',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Welcome back to Health Tracker!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    color: primaryColor,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Spotlight',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // Spotlight Section
              const SpotlightSection(),
              const SizedBox(height: 24),

              // Quick Access Section
              const Text(
                'Feature Tiles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.9,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  // InkWell(
                  //   onTap: () async {
                  //     final patientId = await AuthService.getUserId();
                  //     if (patientId != null) {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => PrescriptionListScreen(
                  //             patientId: patientId ?? '',
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content: Text('Failed to get patient ID'),
                  //         ),
                  //       );
                  //     }
                  //   },
                  //   child: const _QuickAccessItem(
                  //     label: 'Prescriptions',
                  //     iconAsset: 'assets/icon/stats_2.png',
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrescriptionListScreen(),
                        ),
                      );
                    },
                    child: const _QuickAccessItem(
                      label: 'Prescriptions',
                      iconAsset: 'assets/icon/stats_2.png',
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LabReportsScreen(),
                        ),
                      );
                    },
                    child: const _QuickAccessItem(
                      label: 'Lab Reports',
                      iconAsset: 'assets/icon/lab_report_2.png',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ClinicVisitDetailsScreen(),
                        ),
                      );
                    },
                    child: const _QuickAccessItem(
                      label: 'Clinics',
                      iconAsset: 'assets/icon/clinic_2.png',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsFeedScreen(),
                        ),
                      );
                    },
                    child: const _QuickAccessItem(
                      label: 'Feed News',
                      iconAsset: 'assets/icon/feed2.png',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarePlanListScreen(),
                        ),
                      );
                    },
                    child: const _QuickAccessItem(
                      label: 'Care Plans',
                      iconAsset: 'assets/icon/input_2.png',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LabTestListScreen(),
                        ),
                      );
                    },
                    child: const _QuickAccessItem(
                      label: 'Lab Orders',
                      iconAsset: 'assets/icon/profile_2.png',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Last Recorded Activity
              // Card(
              //   color: const Color(0xFFE0F2F1),
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Icon(Icons.analytics, color: accentColor),
              //         const SizedBox(width: 12),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: const [
              //               Text(
              //                 'Last Recorded Activity',
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               SizedBox(height: 4),
              //               Text(
              //                 'Blood Sugar: 120 mg/dL',
              //                 style: TextStyle(fontSize: 14),
              //               ),
              //               SizedBox(height: 2),
              //               Text(
              //                 'Date: 2025-07-07',
              //                 style: TextStyle(
              //                   fontSize: 12,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 24),
              const Text(
                'Metrics Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 24),

              // Metrics Summary
              const MetricsSummaryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

// Quick Access Item Widget
class _QuickAccessItem extends StatelessWidget {
  final String label;
  final String iconAsset;

  const _QuickAccessItem({required this.label, required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9F9F9),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconAsset, height: 50, width: 50),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// Spotlight Section Widget
class SpotlightSection extends StatefulWidget {
  const SpotlightSection({super.key});

  @override
  State<SpotlightSection> createState() => _SpotlightSectionState();
}

class _SpotlightSectionState extends State<SpotlightSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'assets/notice1.jpg',
    'assets/ad1.jpeg',
    'assets/drink.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              // Dots Indicator
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}