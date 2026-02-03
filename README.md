# 🅿️ Parking Lot Management System (MySQL)

A database-driven parking lot management system designed for **real-time slot tracking** and **payment/billing automation** using **MySQL**.

> Repo includes:
> - `Parking_Management.sql` (schema + queries)
> - `ER_diagram.png` (data model)
> - Project report PDF

---

## 📌 Overview
This project models the core workflow of a parking facility:
- Register vehicles entering/exiting
- Track parking slot availability
- Calculate parking fees and record payments
- Maintain clean, consistent records using a relational database design

---

## 🎯 Key Features
- Relational database design for parking operations (see ER diagram)
- SQL script to create schema + constraints and run core operations
- Supports operational queries for:
  - availability/occupancy tracking
  - vehicle/session history
  - billing/payment records

---

## 🛠 Tech Stack
- **MySQL**
- **SQL (DDL + DML + queries)**
- ER modeling (schema design)

---

## 📂 Files
- `Parking_Management.sql` — database schema + core queries
- `ER_diagram.png` — entity-relationship model of the system
- `BUAN 6320 Group project.pdf` — project documentation/report

---

## ▶️ How to Run (Local)
1. Create a database in MySQL:
   ```sql
   CREATE DATABASE parking_management;
   USE parking_management;
