🏫 School Fee Management System
Flutter + Firebase | Admin & Parent Portals | Real-time Fee Tracking

<div align="center"> <img src="https://img.shields.io/badge/Flutter-3.19.5-blue?logo=flutter" alt="Flutter"> <img src="https://img.shields.io/badge/Firebase-9.22.0-orange?logo=firebase" alt="Firebase"> <img src="https://img.shields.io/badge/GetX-4.6.5-green" alt="GetX"> </div>
🌟 Key Features
Admin Portal
To get the login admin dashboard please use admin@school.com and pass: 123456 

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

SIGN UP SCREEN:
![image](https://github.com/user-attachments/assets/a80fb6b0-e12b-4739-b01a-793208c38ff7)

ADMIN LOGIN SCREEN:
![image](https://github.com/user-attachments/assets/e3dec7c9-26ca-4437-bf23-836cca239a30)
ADMIN DASHBOARD:
![image](https://github.com/user-attachments/assets/76471f5e-2b21-4bd1-839d-e65d42a5cdd3)
GENERATED REPORTS:
![image](https://github.com/user-attachments/assets/7fc6e128-20c7-4576-a2dc-f39b1290c63d)
FILTER REPORTS:
![image](https://github.com/user-attachments/assets/80a88e39-f806-4cfd-b74e-3427f456c2ce)

PARENT DASHBOARD:
LOGIN SCREEN:
![image](https://github.com/user-attachments/assets/12bd5d65-9b0e-4a4b-bb57-7d292d3420d1)

DASHBOARD:
![image](https://github.com/user-attachments/assets/8445ad16-5d8b-4eef-8bae-7791cbcb350b)

SUBMIT FEES:
![image](https://github.com/user-attachments/assets/5bc7f8a2-920a-4af3-9f7c-7c38a39e2309)

VIEW PAYMENT HISTORY:
![image](https://github.com/user-attachments/assets/91360484-d13f-4e4e-bd8a-932b9f1c60b5)








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
