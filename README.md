# 🧵 TailorHub

> A modern digital measurement and client management platform built specifically for tailors.

TailorHub is a mobile application designed to help tailors move away from traditional paper measurement books and manage their clients, measurements, orders, and style references digitally.

Instead of searching through notebooks for a client's measurements, TailorHub gives tailors a centralized place to store, organize, reuse, and manage everything related to their clients and garments.

---

## ✨ Features

### 👤 Client Management
- Create and manage client profiles
- Store client contact information
- View client history
- Quickly search for clients
- Keep all client information organized in one place

### 📏 Measurements
- Record detailed client measurements
- Organize measurements into easy-to-use categories
- Update measurements when necessary
- View previous measurements
- Reuse existing measurements for new orders
- Copy measurements from one order to another

### 🧵 Order Management
- Create new garment orders
- Associate orders with clients
- Set order names and deadlines
- Track order progress
- Manage order status
- Keep measurements and style references attached to the relevant order

### 🖼️ Style References
- Upload pictures of styles requested by clients
- Attach style images to specific orders
- Keep visual references alongside measurements
- Easily review the requested style while working on an order

### 🔐 Authentication
- Secure user registration
- Email/password login
- Password recovery
- Persistent authentication sessions
- User-specific data isolation

### 👨‍💼 Tailor Profile
- Store tailor's full name
- Store business name
- Personalized dashboard
- User initials avatar

Example:

`Praiseben Olukayode → PO`

---

## 💎 Premium Features

TailorHub will use a freemium model, allowing tailors to use the core functionality for free while offering advanced features through a premium subscription.

Potential premium features include:

- 📊 Advanced business analytics
- ♾️ Unlimited clients
- 📏 Unlimited measurement history
- 🖼️ Increased image storage
- 📄 PDF measurement/order reports
- ☁️ Advanced cloud backup
- 🎨 Custom measurement templates
- 📋 Advanced order management
- 🔔 Smart reminders and notifications
- 🤖 AI-powered style assistance
- 📈 Business performance insights

> Premium functionality is currently under development.

---

# 🛠️ Tech Stack

## Frontend

- **Flutter**
- **Dart**

## Backend & Infrastructure

- **Supabase**
  - PostgreSQL Database
  - Supabase Authentication
  - Supabase Storage
  - Row Level Security (RLS)

## API / Server

- **Python**
- **FastAPI**

FastAPI will be used for server-side operations that require custom business logic, integrations, AI functionality, payments, and other operations that should not be handled directly from the client.

## Development Tools

- Android Studio
- VS Code
- Git
- GitHub

---

# 🏗️ Architecture

TailorHub follows a modular architecture designed to keep the application maintainable as it grows.

```text
                    ┌─────────────────┐
                    │   Flutter App   │
                    └────────┬────────┘
                             │
                ┌────────────┼────────────┐
                │            │            │
                ▼            ▼            ▼
          Supabase Auth   Database     Storage
                │            │            │
                └────────────┼────────────┘
                             │
                          FastAPI
                             │
                ┌────────────┼────────────┐
                │            │            │
                ▼            ▼            ▼
               AI        Payments       Reports