🏫 School Fee Management System
Flutter + Firebase | Admin & Parent Portals | Real-time Fee Tracking

<div align="center"> <img src="https://img.shields.io/badge/Flutter-3.19.5-blue?logo=flutter" alt="Flutter"> <img src="https://img.shields.io/badge/Firebase-9.22.0-orange?logo=firebase" alt="Firebase"> <img src="https://img.shields.io/badge/GetX-4.6.5-green" alt="GetX"> </div>
🌟 Key Features
Admin Portal
📊 Manage fee structures (courses, amounts, due dates)

📈 Generate payment reports

👥 View all parent transactions



Parent Portal
💳 Submit fees (JazzCash, Cash, Bank Transfer)

📅 View payment history

🔔 Fee due alerts

PDF receipt generation


Core Tech
🔐 Firebase Authentication (Email/Password)

🗃️ Cloud Firestore (Real-time database)

🧠 GetX (State management & navigation)

👔 Role-based access control

🖥️ Screenshots
(Placeholder for actual screenshots)

Admin Dashboard	Parent Dashboard	Fee Submission
Admin	Parent	Fee
🚀 Quick Start
1. Firebase Setup
Enable Email/Password Authentication

Create Firestore collections:

users (fields: name, email, role, createdAt)

fee_structure (fields: course, amount, dueDate, status)

payments (fields: userId, amount, date, status, method)

2. Run the App
bash
flutter pub get
flutter run
🏗️ Project Structure
lib/
├── controllers/       # Business logic
│   ├── AuthService.dart
│   ├── PaymentController.dart
│   └── NotificationService.dart
│
├── models/            # Data models
│   ├── User.dart
│   └── Payment.dart
│
├── screens/           # UI components
│   ├── admin/         # Admin screens
│   ├── parent/        # Parent screens
│   └── auth/          # Authentication
│
└── main.dart          # App entry point
📌 Key Implementation Details
Role-Based Routing

dart
// Automatically redirects users based on role
GetPage(
  name: '/home',
  page: () => auth.userRole.value == 'admin' 
      ? AdminDashboard() 
      : ParentDashboard(),
)
Real-time Payment Tracking

dart
// Firestore payment submission
await _firestore.collection('payments').add({
  'userId': currentUser.uid,
  'amount': amount,
  'date': DateTime.now(),
  'status': 'Success'
});
Clean Architecture

Separation of concerns (Models-Controllers-Screens)

GetX for efficient state management

📅 Future Roadmap


Multi-child support for parents

Advanced analytics dashboard

🤝 How to Contribute
Fork the repository

Create a feature branch (git checkout -b feature/improvement)

Commit changes (git commit -m 'Add new feature')

Push to branch (git push origin feature/improvement)

Open a Pull Request

📜 License
MIT - Open for customization and commercial use
