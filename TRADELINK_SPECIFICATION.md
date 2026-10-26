# TradeLink | Import Export Commission Agent Platform
## Complete Technical Specification & System Architecture Document
**Version:** 1.0.0  
**Target Systems:** Cross-Platform Mobile Application (Flutter iOS/Android) & Responsive Web Portal  
**Database:** PostgreSQL 16 (50 Normalized Relational Tables in 3NF)  

---

## Table of Contents
1. **Section 1: Project Introduction**
   - 1.1 Background
   - 1.2 Problem Statement
   - 1.3 Proposed Solution: TradeLink
2. **Section 2: Objectives, Scope & User Roles**
   - 2.1 Objectives
   - 2.2 Scope
   - 2.3 User Roles & Responsibility Matrix
3. **Section 3: Software Development Life Cycle (SDLC)**
   - 3.1 Agile Scrum Iterative-Incremental Model
   - 3.2 SDLC Phases & Engineering Deliverables
   - 3.3 Six-Sprint Iterative Implementation Schedule
   - 3.4 Technical Risk Management & Mitigation Matrix
4. **Section 4: Software Requirements Specification (SRS)**
   - 4.1 Functional Requirements (FR-01 to FR-50 across All 25 Modules)
   - 4.2 Non-Functional Requirements (NFR-01 to NFR-12)
   - 4.3 Hardware, Software & Web Environment Requirements
5. **Section 5: System Architecture & Web Technologies Stack**
   - 5.1 4-Layer Service-Oriented Architecture
   - 5.2 Microservices & Gateway Topology
6. **Section 6: Complete 25-Module Functional Specifications**
   - Modules 01 to 25 Comprehensive Breakdown
7. **Section 7: Complete Relational Database Design (50 Normalized PostgreSQL Tables)**
   - Tables 01 to 50 Complete Schema DDL & Relationships
8. **Section 8: UI Design Guidelines & Design System**
   - Color Palette, Typography, Layout, Component System
9. **Section 9: Technology Stack & Future Roadmap**
10. **Section 10: Conclusion & Project Summary**

---

## Section 1: Project Introduction
### 1.1 Background
An import export commission agent (also called a trade broker) connects overseas buyers with global manufacturers and suppliers, negotiates contract pricing, arranges shipping paperwork, supervises cargo movement, and collects a commission upon successful contract fulfillment. Operating without a unified platform leads to extreme fragmentation across time zones, currencies, and customs regulatory frameworks.

### 1.2 Problem Statement
Scattered communication across WhatsApp, phone calls, and manual spreadsheets results in missed inquiries, inaccurate price quotations, misplaced bills of lading, delayed payments, and ambiguous commission records. A minor error in an HS code tariff classification or shipping manifest can halt a container at customs for weeks, causing severe penalties.

### 1.3 Proposed Solution: TradeLink
TradeLink delivers a unified digital ecosystem spanning 25 integrated modules backed by a 50-table normalized PostgreSQL relational database. It automates quotations with Incoterms 2020 rules, provides live counter-offer chat negotiation, tracks multimodal container milestones with AIS vessel positioning, streamlines customs checklists, calculates multi-tiered commission payouts, and secures financial settlements through structured escrow and Letters of Credit (LC).

---

## Section 2: Objectives, Scope & User Roles
### 2.1 Objectives
- Digitize the end-to-end import-export commission brokerage life cycle.
- Eliminate pricing and document errors via automated Incoterm calculators and HS code databases.
- Provide real-time visibility into active deals, vessel coordinates, and net commission earnings.
- Comply with Apple Human Interface Guidelines and WCAG 2.1 accessibility standards.
- Provide a robust, modular 25-screen architecture backed by a 50-table 3NF relational schema.

### 2.2 Scope & User Roles
- **Commission Agent (Broker):** Manages buyers/suppliers, drafts quotations, moderates negotiations, monitors containers, audits compliance, and records commission earnings.
- **Importer (Buyer):** Issues RFQs, evaluates quotations, counters price offers in real-time chat, issues Letters of Credit (LC) / Escrow deposits, and tracks delivery.
- **Exporter (Supplier):** Manages product catalog, accepts purchase orders, uploads mandatory shipping docs (B/L, Commercial Invoice, Packing List, COO), and receives milestone disbursements.
- **Platform Admin:** Verifies KYC credentials and trade licenses, oversees escrow disputes, maintains master HS tariffs, and audits immutable platform logs.

---

## Section 3: SDLC (Agile Scrum) & Risk Management
TradeLink follows an Agile Scrum iterative-incremental SDLC organized across 6 two-week sprints:
- **Sprint 1 (Weeks 7-8):** Access & Onboarding (Modules 01-03, 25; Tables 01-07, 50)
- **Sprint 2 (Weeks 9-10):** Core Business Directory (Modules 04-08; Tables 08-19)
- **Sprint 3 (Weeks 11-12):** Deal Cycle & Negotiation (Modules 09-13; Tables 20-30)
- **Sprint 4 (Weeks 13-14):** Logistics & Compliance (Modules 14-16; Tables 31-38)
- **Sprint 5 (Weeks 15-16):** Finance, Escrow & FX (Modules 17-21; Tables 39-47)
- **Sprint 6 (Weeks 17-18):** Insights, Utilities & QA (Modules 22-24; Tables 48-49)

---

## Section 6: Complete 25-Module Functional Specifications (Modules 01 - 25)

### Functional Area Breakdown
- **Access & Onboarding:** 01 Splash Screen • 02 Login • 03 Registration
- **Core Business:** 04 Dashboard • 05 Client Management • 06 Client Profile • 07 Supplier Directory • 08 Product Catalog
- **Deal Cycle:** 09 Inquiries / RFQ • 10 Quotation Builder • 11 Negotiation Chat • 12 Orders • 13 Order Details
- **Logistics & Compliance:** 14 Shipment Tracking • 15 Documents • 16 Customs & HS Code
- **Finance & Ledger:** 17 Commission Calculator • 18 Earnings Ledger • 19 Invoices • 20 Payments • 21 Currency Rates
- **Insights & Utilities:** 22 Reports & Analytics • 23 Notifications • 24 Calendar & Tasks • 25 Settings & Profile

---

#### MODULE 01 — 01. Splash Screen
- **Description:** Entry point displaying branded TradeLink insignia, verifying JWT credentials, server health check, and routing to Dashboard or Login within 1.5s.
- **Key Features:** Animated brand logo; session & token validation; secure health ping; automatic role-based redirect.
- **Web/API Route:** `GET /` | `GET /api/v1/auth/session-verify`
- **Mapped Tables:** `users`, `user_sessions`, `user_preferences_and_audit_logs`

#### MODULE 02 — 02. Login
- **Description:** Authenticates Importers, Exporters, Commission Agents, and Admins via email/password, Face ID / biometrics, and Google OAuth.
- **Key Features:** Bcrypt password verification; account lockout after 5 failed attempts; Face ID / WebAuthn; password reset workflow.
- **Web/API Route:** `GET /login` | `POST /api/v1/auth/login`, `POST /api/v1/auth/biometric`
- **Mapped Tables:** `users`, `user_sessions`, `auth_login_attempts`, `password_reset_tokens`, `biometric_oauth_credentials`

#### MODULE 03 — 03. Registration
- **Description:** Onboarding flow capturing user and company profiles with role-based access assignment (Importer, Exporter, Agent).
- **Key Features:** Form validation; role selection; password strength meter; Terms & Privacy consent; welcome email.
- **Web/API Route:** `GET /register` | `POST /api/v1/auth/register`
- **Mapped Tables:** `users`, `roles`, `role_permissions`, `companies`, `user_preferences_and_audit_logs`

#### MODULE 04 — 04. Dashboard
- **Description:** High-level executive command center displaying 4 live KPI cards (Active Deals, Commission Earned $, Shipments in Transit, Pending Docs), monthly 6-month earnings bar chart, and recent activity feed.
- **Key Features:** Dynamic KPI cards; interactive 6-month earnings visualization; real-time activity stream; quick deal action triggers.
- **Web/API Route:** `GET /dashboard` | `GET /api/v1/dashboard/summary`, `GET /api/v1/dashboard/activity-feed`
- **Mapped Tables:** `analytics_snapshots`, `orders`, `shipments`, `trade_documents`, `earnings_ledger`, `notifications_and_tasks`

#### MODULE 05 — 05. Client Management
- **Description:** Searchable, filterable client roster detailing buyers and sellers with status badges, country tags, and quick onboarding.
- **Key Features:** Multi-attribute search (company, contact, country); filter chips (All, Importers, Exporters, Active); Quick Add Client modal.
- **Web/API Route:** `GET /clients` | `GET /api/v1/clients`, `POST /api/v1/clients`
- **Mapped Tables:** `clients`, `companies`, `client_contacts`, `countries_master`

#### MODULE 06 — 06. Client Profile
- **Description:** Granular 360-degree overview of a client organization showing trade volume ($), rating, active deals, compliance documents, and direct call/message/deal actions.
- **Key Features:** Deal count & cumulative GMV; star rating; sub-tabs (Details, Deals, Documents, Notes); quick call & email shortcuts.
- **Web/API Route:** `GET /clients/:clientId` | `GET /api/v1/clients/{id}`, `POST /api/v1/clients/{id}/notes`
- **Mapped Tables:** `clients`, `companies`, `client_contacts`, `client_notes`, `supplier_reviews`, `orders`, `trade_documents`

#### MODULE 07 — 07. Supplier Directory
- **Description:** Verified manufacturers and global exporters categorized by industry with trust badges (Gold, Verified), review scores, and geolocation map.
- **Key Features:** Category filters (Electronics, Textiles, Food, Steel); verified tier badges; rating & review metrics; map view plotting supplier headquarters.
- **Web/API Route:** `GET /suppliers` | `GET /api/v1/suppliers`, `GET /api/v1/suppliers/map`
- **Mapped Tables:** `suppliers`, `supplier_verifications`, `supplier_locations`, `product_categories`, `supplier_reviews`

#### MODULE 08 — 08. Product Catalog
- **Description:** Visual trade commodity database indexing products with 6-to-8 digit HS codes, specifications, packaging, indicative prices, and one-tap "+ Add to Quotation".
- **Key Features:** High-resolution product gallery; HS code classification; keyword search; category filtering; quick quotation attachment.
- **Web/API Route:** `GET /products` | `GET /api/v1/products`, `POST /api/v1/products`
- **Mapped Tables:** `products`, `product_categories`, `product_media`, `hs_codes_tariff`, `suppliers`

#### MODULE 09 — 09. Inquiries / RFQ
- **Description:** Manages inbound buyer requests for quotation (RFQs) with quantity targets, deadlines, urgency indicators, and conversion pipelines.
- **Key Features:** Pipeline summary banner (Open, Quoted, Won); status filters; countdown deadline alerts; one-tap "Respond with Quote".
- **Web/API Route:** `GET /rfqs` | `GET /api/v1/rfqs`, `POST /api/v1/rfqs`, `PATCH /api/v1/rfqs/{id}/status`
- **Mapped Tables:** `rfq_inquiries`, `rfq_line_items`, `clients`, `products`

#### MODULE 10 — 10. Quotation Builder
- **Description:** Interactive multi-currency proforma quotation generator supporting Incoterms 2020 (FOB, CIF, CFR, EXW, DDP), dynamic line items, freight calculation, agent commission computation, and PDF export.
- **Key Features:** Real-time formula engine (Subtotal + Freight + Insurance + Commission = Grand Total); Incoterms selector; PDF preview and dispatch.
- **Web/API Route:** `GET /quotations/builder` | `POST /api/v1/quotations`, `GET /api/v1/quotations/{id}/pdf`
- **Mapped Tables:** `quotations`, `quotation_line_items`, `incoterms_master`, `rfq_inquiries`, `clients`

#### MODULE 11 — 11. Negotiation Chat
- **Description:** Real-time negotiation workspace between agent, buyer, and seller featuring interactive Counter-Offer cards with quantity, price, and instant Accept/Counter actions.
- **Key Features:** WebSocket duplex messaging; embedded Counter-Offer widgets; audit logging; quotation auto-updating upon mutual agreement.
- **Web/API Route:** `GET /negotiations/:threadId` | `WS /ws/chat/{threadId}`, `POST /api/v1/negotiations/counter-offer`
- **Mapped Tables:** `negotiation_threads`, `negotiation_messages`, `counter_offers`, `quotations`, `rfq_inquiries`

#### MODULE 12 — 12. Orders
- **Description:** Centralized view of confirmed international purchase contracts with order tracking IDs, values, buyer/supplier parties, and progress indicators.
- **Key Features:** Status categorization (All, Processing, Shipped, Delivered); progress meters; monetary metrics; direct drill-down into execution details.
- **Web/API Route:** `GET /orders` | `GET /api/v1/orders`, `POST /api/v1/orders`
- **Mapped Tables:** `orders`, `order_line_items`, `clients`, `suppliers`, `quotations`

#### MODULE 13 — 13. Order Details
- **Description:** Execution cockpit for a specific order displaying contractual terms, commission breakdown, buyer/seller contacts, and a 6-stage milestone tracker.
- **Key Features:** 6-Stage Timeline (Order Confirmed → Advance Payment Received → Production/Packing → Shipped from Port → Customs Clearance → Delivered); status update actions; quick link to live vessel tracking.
- **Web/API Route:** `GET /orders/:orderId` | `GET /api/v1/orders/{id}`, `PATCH /api/v1/orders/{id}/milestone`
- **Mapped Tables:** `orders`, `order_milestones`, `order_line_items`, `clients`, `suppliers`, `trade_documents`

#### MODULE 14 — 14. Shipment Tracking
- **Description:** Real-time maritime and multimodal container logistics viewer with route maps, port coordinates, live vessel AIS position, and container milestone statuses.
- **Key Features:** Container ID / B/L search (e.g. MSKU-7781452); departure/arrival port milestones (Departed, At Sea, Port Arrival, Custom Clearance, Delivered); GPS coordinates; ETA countdown.
- **Web/API Route:** `GET /shipments` | `GET /api/v1/shipments/{containerId}`, `GET /api/v1/shipments/live-map`
- **Mapped Tables:** `ports_master`, `shipments`, `containers`, `shipment_tracking_events`

#### MODULE 15 — 15. Documents Vault & Compliance
- **Description:** Secure document vault organizing mandatory international trade paperwork (Commercial Invoice, Bill of Lading, Packing List, Certificate of Origin, Letter of Credit, Inspection Certificate) with multi-stage verification.
- **Key Features:** Document categorization; status indicators (Approved, Pending, Rejected); PDF/Image preview; digital upload & camera scan; SHA-256 integrity checksums.
- **Web/API Route:** `GET /documents` | `GET /api/v1/documents`, `POST /api/v1/documents/upload`, `PATCH /api/v1/documents/{id}/verify`
- **Mapped Tables:** `trade_documents`, `document_approvals`, `orders`

#### MODULE 16 — 16. Customs & HS Code Tariff Calculator
- **Description:** Global customs tariff classification and calculation engine synced with Pakistan Single Window (PSW) and WCO HS codes. Automatically computes Customs Duty, Sales Tax, Additional Customs Duty (ACD), and Withholding Tax (WHT).
- **Key Features:** 6-to-8 digit HS search; granular duty breakdown; pre-shipment compliance checklist (IEC/NTN, COO, Commercial Invoice, PSI Inspection); exportable compliance report.
- **Web/API Route:** `GET /customs` | `GET /api/v1/customs/tariff-lookup`, `POST /api/v1/customs/calculate-duty`
- **Mapped Tables:** `hs_codes_tariff`, `customs_checklists`, `countries_master`

#### MODULE 17 — 17. Commission Calculator
- **Description:** Financial estimation tool calculating agent gross earnings, platform fees (10%), tax withholdings, and net payout across Fixed, Percentage, and Tiered models.
- **Key Features:** Interactive percentage slider (1% - 10%); quick presets (1%, 2%, 3%, 5%, 7.5%); visual donut chart breakdown; direct "Save to Quotation" button.
- **Web/API Route:** `GET /finance/commission-calculator` | `POST /api/v1/finance/calculate-commission`
- **Mapped Tables:** `commission_tiers`, `commission_calculations`, `quotations`

#### MODULE 18 — 18. Earnings Ledger
- **Description:** Double-entry ledger recording all agent commission receivables, historical disbursements, pending settlements, and MoM financial growth metrics.
- **Key Features:** Gross earnings summary ($); pending vs received balances; itemized transaction table with order references and payment methods; Excel/PDF export.
- **Web/API Route:** `GET /finance/ledger` | `GET /api/v1/finance/ledger`, `GET /api/v1/finance/ledger/export`
- **Mapped Tables:** `earnings_ledger`, `orders`, `invoices`, `payments`

#### MODULE 19 — 19. Invoices
- **Description:** Billing module generating compliant trade proforma and commission invoices with due dates, payment terms, status filters, and overdue reminder triggers.
- **Key Features:** KPI summary (Total Invoiced, Paid, Pending, Overdue); status filtering (Paid, Unpaid, Overdue); one-click PDF generation and client dispatch.
- **Web/API Route:** `GET /finance/invoices` | `GET /api/v1/invoices`, `POST /api/v1/invoices`, `GET /api/v1/invoices/{id}/pdf`
- **Mapped Tables:** `invoices`, `invoice_line_items`, `orders`, `clients`

#### MODULE 20 — 20. Payments & Escrow Settlement
- **Description:** Cross-border payment management module supporting Letters of Credit (LC at sight), Telegraphic Transfers (TT 30/70), and multi-stage Escrow milestone settlements.
- **Key Features:** Escrow balance tracker (50% deposit released upon B/L verification vs 50% retained until delivery); bank reference logging; 256-bit encryption; milestone release approvals.
- **Web/API Route:** `GET /finance/payments` | `GET /api/v1/payments`, `POST /api/v1/payments/escrow/release`
- **Mapped Tables:** `payments`, `escrow_accounts`, `letters_of_credit`, `orders`

#### MODULE 21 — 21. Currency Rates & Converter
- **Description:** Live foreign exchange converter and rate board tracking major global trade currencies against USD (PKR, AED, EUR, GBP, CNY, SAR) with historical 24-hour trends.
- **Key Features:** Real-time multi-currency calculator; live FX ticker with daily % delta indicators; 7-day mini sparklines; Redis-cached rate locking.
- **Web/API Route:** `GET /finance/currency-rates` | `GET /api/v1/finance/rates/live`, `POST /api/v1/finance/convert`
- **Mapped Tables:** `currency_exchange_rates`, `quotations`

#### MODULE 22 — 22. Reports & Analytics
- **Description:** Business intelligence dashboard delivering trade insights across time intervals (Week, Month, Quarter, Year), monthly deal volume bar charts, country distribution donuts, and conversion metrics.
- **Key Features:** RFQ-to-Order Conversion %; Average Commission %; Top Clients by GMV; PDF & CSV export engine.
- **Web/API Route:** `GET /reports` | `GET /api/v1/analytics/overview`, `GET /api/v1/analytics/export`
- **Mapped Tables:** `analytics_snapshots`, `orders`, `clients`, `countries_master`

#### MODULE 23 — 23. Notifications & Alert Center
- **Description:** High-priority notification hub alerting agents of quotation acceptances, LC milestones, vessel arrivals, payment releases, and pending compliance documents.
- **Key Features:** Chronological groups (Today, Earlier); category filter chips (All, Orders, Payments, Logistics, System); Mark All as Read; deep-linking.
- **Web/API Route:** `GET /notifications` | `GET /api/v1/notifications`, `PATCH /api/v1/notifications/mark-read`
- **Mapped Tables:** `notifications_and_tasks`, `users`

#### MODULE 24 — 24. Calendar & Tasks
- **Description:** Operational schedule coordinator plotting container arrival ETAs, LC expiration dates, and payment deadlines alongside a daily checklist.
- **Key Features:** Interactive monthly calendar with color-coded event dots; daily agenda list; priority indicators (Urgent, High, Normal); task completion toggles.
- **Web/API Route:** `GET /calendar` | `GET /api/v1/tasks`, `POST /api/v1/tasks`, `PATCH /api/v1/tasks/{id}/toggle`
- **Mapped Tables:** `notifications_and_tasks`, `orders`, `shipments`

#### MODULE 25 — 25. Settings & Profile
- **Description:** Comprehensive user management and configuration center for personal profile, company details, biometric security toggles, notification preferences, dark mode, and secure logout.
- **Key Features:** Avatar upload; Face ID / Biometrics switch; Push notification preferences; default currency (USD, PKR, EUR) and language; Terms & Support; token revocation logout.
- **Web/API Route:** `GET /settings` | `GET /api/v1/user/profile`, `PUT /api/v1/user/profile`, `POST /api/v1/auth/logout`
- **Mapped Tables:** `users`, `companies`, `user_preferences_and_audit_logs`, `user_sessions`

---

## Section 7: Complete Relational Database Design (50 Normalized PostgreSQL Tables)
The complete DDL for all 50 tables is specified in `C:\Users\TechSOL\.gemini\antigravity-ide\brain\b02acd76-b776-4e06-81d7-9f7dbeee25a4\tradelink_complete_specification.md` and in the project architecture.

### Summary of 50 PostgreSQL Tables:
1. `roles` (User RBAC roles: Agent, Importer, Exporter, Admin)
2. `permissions` (Granular permission master keys)
3. `role_permissions` (Join table for role entitlements)
4. `users` (Core accounts with bcrypt password hashes)
5. `user_sessions` (Active tokens & device fingerprints)
6. `auth_login_attempts` (Rate limiting & brute force audit)
7. `password_reset_tokens` (Secure expirable tokens)
8. `countries_master` (ISO country codes, dialing, flags)
9. `companies` (Corporate entity profiles & trade licenses)
10. `clients` (Agent-client relationships, terms & ratings)
11. `client_contacts` (Company point of contact details)
12. `client_notes` (Agent CRM interaction notes)
13. `suppliers` (Verified manufacturers and tiers)
14. `supplier_verifications` (Audit logs and verification badges)
15. `supplier_locations` (Warehouses, factories, GPS lat/lng)
16. `supplier_reviews` (Client feedback and 1-5 ratings)
17. `product_categories` (Electronics, Textiles, Agri, Steel)
18. `products` (Commodities, HS codes, unit pricing, MOQs)
19. `product_media` (Gallery images and spec sheets)
20. `rfq_inquiries` (Buyer RFQs, urgency & deadlines)
21. `rfq_line_items` (Individual requested items in an RFQ)
22. `incoterms_master` (FOB, CIF, CFR, EXW, DDP definitions)
23. `quotations` (Proforma offers, freight, commission)
24. `quotation_line_items` (Items, quantities, unit prices)
25. `negotiation_threads` (Message channels per RFQ/quote)
26. `negotiation_messages` (Chat messages & attachments)
27. `counter_offers` (Structured negotiation cards)
28. `orders` (Confirmed international trade contracts)
29. `order_line_items` (Contracted line items)
30. `order_milestones` (6-stage execution milestones)
31. `ports_master` (Global seaport codes & GPS)
32. `shipments` (B/L numbers, vessel AIS names, ETAs)
33. `containers` (Container IDs, seal numbers, 40ft HC)
34. `shipment_tracking_events` (Historical GPS tracking steps)
35. `trade_documents` (B/L, Invoices, COO, SHA-256 hashes)
36. `document_approvals` (Verification audit workflow)
37. `hs_codes_tariff` (PSW tariff rates: Duty, Sales, WHT)
38. `customs_checklists` (Pre-clearance compliance tasks)
39. `commission_tiers` (Volume-based commission percentages)
40. `commission_calculations` (Gross, platform fee, net earnings)
41. `earnings_ledger` (Double-entry receivable ledger)
42. `invoices` (Proforma and commission invoices)
43. `invoice_line_items` (Billed invoice lines)
44. `payments` (TT, LC, and Escrow payment logs)
45. `escrow_accounts` (Staged deposit & release controls)
46. `letters_of_credit` (LC numbers, issuing banks, tenors)
47. `currency_exchange_rates` (USD base live FX rates)
48. `analytics_snapshots` (Historical BI performance snapshots)
49. `notifications_and_tasks` (Unified alerts & calendar agenda)
50. `user_preferences_and_audit_logs` (Immutable compliance log)

---

## Section 8: UI Design Guidelines
- **Deep Navy:** `#0B2545` (Primary brand tone, navigation)
- **Trade Teal:** `#13A89E` (Action buttons, progress, highlights)
- **Trade Gold:** `#F2A541` (Badges, warnings, pending statuses)
- **Success Green:** `#2EAA64` (Settled payments, approved documents)
- **Alert Red:** `#E25555` (Critical alerts, overdue invoices)
- **Canvas Light:** `#F8F9FC` | **Card Light:** `#FFFFFF`
- **Canvas Dark:** `#0F172A` | **Card Dark:** `#1E293B`
