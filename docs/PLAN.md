# HotelOS — Future Development Plan

> This document serves as the master roadmap for HotelOS. It captures architectural decisions, scaling plans, feature roadmap, and development priorities. Update it as progress is made.

**Last Updated:** April 2026

---

## Table of Contents

1. [Current State](#1-current-state)
2. [Known Issues & Debt](#2-known-issues--debt)
3. [Phase 1: Stabilize & Ship MVP](#3-phase-1-stabilize--ship-mvp)
4. [Phase 2: Core PMS Features](#4-phase-2-core-pms-features)
5. [Phase 3: Multi-Tenant & Scale](#5-phase-3-multi-tenant--scale)
6. [Phase 4: Integrations](#6-phase-4-integrations)
7. [Phase 5: Enterprise](#7-phase-5-enterprise)
8. [Database Migration: SQLite → Supabase](#8-database-migration-sqlite--supabase)
9. [Architecture Decisions](#9-architecture-decisions)
10. [Performance Targets](#10-performance-targets)
11. [Security Checklist](#11-security-checklist)
12. [Open Questions](#12-open-questions)

---

## 1. Current State

### What Exists Today

| Component | Technology | Status |
|---|---|---|
| Framework | Next.js 15 (App Router) + React 19 | ✅ Running |
| Language | TypeScript (strict mode) | ✅ Running |
| UI | shadcn/ui + Radix UI + Tailwind CSS | ✅ Running |
| Auth | Better Auth (email/password + passkeys) | ✅ Working (fixed) |
| Database | SQLite (file-based) + Drizzle ORM | ✅ Working |
| State | Zustand + React Context | ✅ Running |
| Package Manager | Bun | ✅ Running |
| Containerization | Docker + Docker Compose | ✅ Configured |
| Landing Page | Static page with auth links | ✅ Running |
| Auth Pages | Login, Signup, Error, Verify | ✅ Running |
| Dashboard Shell | Sidebar, header, layout | ⚠️ Basic shell only |
| Settings Page | Settings UI | ⚠️ Basic only |

### Database Tables (All Defined in `db/schema.ts`)

| Table | Columns | Purpose |
|---|---|---|
| `user` | id, name, email, emailVerified, image, createdAt, updatedAt | User accounts (Better Auth) |
| `session` | id, expiresAt, token, createdAt, updatedAt, ipAddress, userAgent, userId | Active sessions |
| `account` | id, accountId, providerId, userId, accessToken, refreshToken, idToken, password, etc. | OAuth/social accounts |
| `verification` | id, identifier, value, expiresAt, createdAt, updatedAt | Email verification tokens |
| `passkey` | id, name, publicKey, userId, credentialID, counter, deviceType, backedUp, etc. | Passkey credentials |
| `properties` | id, userId, name, type, address, city, state, country, zipCode, phone, email, website, description, createdAt, updatedAt | Hotel/homestay properties |
| `rooms` | id, propertyId, name, type, capacity, rate, description, amenities, status, createdAt, updatedAt | Rooms/units |
| `guests` | id, userId, name, email, phone, address, city, state, country, zipCode, idType, idNumber, notes, createdAt, updatedAt | Guest profiles |
| `bookings` | id, propertyId, roomId, guestId, checkIn, checkOut, adults, children, totalAmount, paymentStatus, bookingStatus, notes, createdAt, updatedAt | Reservations |
| `payments` | id, bookingId, amount, method, status, transactionId, notes, createdAt, updatedAt | Payment records |

### What's Missing

- ❌ No actual booking CRUD (schema exists, no UI/API)
- ❌ No property CRUD (schema exists, no UI/API)
- ❌ No room management UI
- ❌ No guest management UI
- ❌ No booking calendar
- ❌ No reports/analytics
- ❌ No housekeeping module
- ❌ No maintenance tracking
- ❌ No invoicing
- ❌ No staff/roles management
- ❌ No multi-tenant isolation (single DB, no tenant scoping)
- ❌ No API documentation
- ❌ No tests
- ❌ No CI/CD pipeline

---

## 2. Known Issues & Debt

### Technical Debt

| Issue | Severity | Description |
|---|---|---|
| No form validation | Medium | Signup/login forms lack client-side validation (Zod schemas exist but aren't applied) |
| No error boundaries | Medium | React error boundaries not implemented — crashes show blank screens |
| Hardcoded mock data | Low | `app-sidebar.tsx` has hardcoded user/property data |
| No pagination | Medium | List pages will break with 100+ items |
| No loading skeletons | Low | Uses basic spinners, no skeleton UI |
| No rate limiting | High | Auth endpoints have no brute-force protection |
| No email service | Medium | Email verification won't work without SMTP config |
| SQLite in production | High | File-based DB doesn't scale, no concurrent connections, no read replicas |
| No health monitoring | Low | No uptime monitoring, no error tracking (Sentry, etc.) |
| `auth-schema.ts` duplicate | Low | Duplicate schema file — `db/schema.ts` is the source of truth, `auth-schema.ts` is redundant |

### Schema Issues

- `name` field on `user` table was changed from `notNull()` to nullable (migration `0002`) to fix Better Auth signup — this is correct and should stay
- `createdAt`/`updatedAt` use integer timestamps (Unix ms) — consistent, but consider ISO strings for API responses

---

## 3. Phase 1: Stabilize & Ship MVP

**Goal:** A working PMS that a single hotel can use to manage bookings.

### 3.1 Authentication Hardening

- [ ] Add Zod validation to signup/login forms
- [ ] Add password strength requirements (min length, special chars)
- [ ] Add rate limiting on auth endpoints (use `@upstash/ratelimit` or similar)
- [ ] Implement email verification flow (needs SMTP provider)
- [ ] Implement forgot password + reset flow
- [ ] Add session management page (view active sessions, revoke)
- [ ] Add "remember me" checkbox
- [ ] Add login attempt lockout after N failures

### 3.2 Property Management

- [ ] Property listing page (table view)
- [ ] Create property form (name, type, address, contact info)
- [ ] Edit property form
- [ ] Delete property (with confirmation + cascade check)
- [ ] Property detail page with stats (total rooms, occupancy rate, active bookings)

### 3.3 Room Management

- [ ] Room listing page (grouped by property)
- [ ] Create room form (name, type, capacity, rate, amenities)
- [ ] Edit room form
- [ ] Room status management (available, occupied, maintenance, blocked)
- [ ] Bulk operations (set status for multiple rooms)

### 3.4 Booking Management

- [ ] Booking list page (filterable by date, property, status)
- [ ] Create booking form (select property → room → guest → dates)
- [ ] Booking detail page
- [ ] Edit booking (change dates, room, status)
- [ ] Cancel booking (with reason + refund tracking)
- [ ] Check-in / Check-out buttons
- [ ] Prevent double-booking at application level (UI + API validation)

### 3.5 Guest Management

- [ ] Guest list page (searchable, filterable)
- [ ] Create guest form (name, email, phone, address, ID info)
- [ ] Guest detail page (booking history, notes)
- [ ] Edit guest form
- [ ] Merge duplicate guests

### 3.6 Dashboard Improvements

- [ ] Real occupancy rate calculation (from DB, not hardcoded)
- [ ] Revenue totals (current month, last month, year-to-date)
- [ ] Upcoming check-ins / check-outs (next 7 days)
- [ ] Recent activity feed
- [ ] Charts: occupancy over time, revenue by month, bookings by status

### 3.7 UI/UX Polish

- [ ] Add loading skeletons (not just spinners)
- [ ] Add empty states for all list pages
- [ ] Add confirmation dialogs for destructive actions
- [ ] Add toast notifications for all mutations
- [ ] Add form error messages (inline, not just top alerts)
- [ ] Make responsive (mobile-first testing)
- [ ] Add keyboard shortcuts for common actions

---

## 4. Phase 2: Core PMS Features

**Goal:** A full-featured PMS that can replace commercial tools for small-medium properties.

### 4.1 Booking Calendar

- [ ] Monthly calendar view (color-coded by room/status)
- [ ] Drag-and-drop booking reschedule
- [ ] Click-to-create booking on empty dates
- [ ] Overbooking warnings
- [ ] Today marker
- [ ] Navigation (prev/next month, today button)
- [ ] Room column view (like a Gantt chart)

### 4.2 Housekeeping Module

- [ ] Housekeeping board (room status overview)
- [ ] Mark rooms as clean / dirty / inspecting
- [ ] Assign tasks to staff members
- [ ] Housekeeping checklist per room type
- [ ] Auto-mark dirty after checkout

### 4.3 Maintenance Tracking

- [ ] Maintenance request creation
- [ ] Priority levels (low, medium, high, emergency)
- [ ] Assign to staff
- [ ] Status tracking (open, in-progress, resolved)
- [ ] Cost tracking (parts, labor)
- [ ] Recurring maintenance schedules

### 4.4 Invoicing & Payments

- [ ] Generate invoices from bookings
- [ ] Line items (room charge, extras, taxes, discounts)
- [ ] PDF invoice generation
- [ ] Payment recording (cash, card, bank transfer, online)
- [ ] Partial payments
- [ ] Refund processing
- [ ] Tax configuration per property
- [ ] Payment reminder emails

### 4.5 Reports & Analytics

- [ ] Occupancy report (daily, weekly, monthly, yearly)
- [ ] Revenue report (by property, room type, channel)
- [ ] Average daily rate (ADR)
- [ ] Revenue per available room (RevPAR)
- [ ] Guest demographics
- [ ] Booking source breakdown
- [ ] Export reports as CSV/PDF
- [ ] Date range picker for all reports

### 4.6 Staff & Roles

- [ ] User roles (admin, manager, receptionist, housekeeping, maintenance)
- [ ] Role-based access control (RBAC)
- [ ] Staff directory
- [ ] Staff activity log
- [ ] Permission matrix per role

### 4.7 Guest Experience

- [ ] Guest messaging / notes
- [ ] Special requests tracking
- [ ] Loyalty program (stay count, tier, perks)
- [ ] Guest preferences (room type, floor, amenities)
- [ ] Automated welcome emails
- [ ] Automated checkout survey

### 4.8 Pricing & Rate Management

- [ ] Dynamic pricing (seasonal rates)
- [ ] Minimum stay requirements
- [ ] Early bird discounts
- [ ] Last-minute discounts
- [ ] Length-of-stay discounts
- [ ] Promo codes / coupons
- [ ] Rate plans (standard, non-refundable, package)

---

## 5. Phase 3: Multi-Tenant & Scale

**Goal:** Support multiple hotel chains, thousands of properties, and millions of bookings.

### 5.1 Database Migration to Supabase (PostgreSQL)

**Why Supabase over Convex:**
- PMS queries are fundamentally relational (date range joins, availability searches, revenue aggregation)
- Row-Level Security provides bulletproof multi-tenant isolation at the database level
- Exclusion constraints prevent double-booking at the DB level (impossible in Convex)
- Table partitioning handles millions of booking rows
- Read replicas separate analytics queries from operational writes
- Fully open-source and self-hostable (enterprise requirement)
- SQL window functions for advanced analytics (RevPAR, YoY growth)

**See Section 8 for the full migration plan.**

### 5.2 Multi-Tenant Architecture

- [ ] `tenants` table (hotel chains / organizations)
- [ ] Every table gets `tenant_id` column
- [ ] Row-Level Security policies on all tables
- [ ] Tenant-scoped API middleware
- [ ] Tenant switching for super-admins
- [ ] Per-tenant settings (timezone, currency, locale)

### 5.3 Performance at Scale

| Target | Current | Goal |
|---|---|---|
| Users | 1 | 10,000+ |
| Properties | Few | 1,000+ |
| Bookings | Hundreds | 10M+ |
| Response time | <500ms | <100ms (p95) |
| Concurrent connections | 1 | 1,000+ |

**Optimizations:**
- [ ] Database indexes on all foreign keys + frequent filter columns
- [ ] Table partitioning for bookings (by month)
- [ ] Read replicas for dashboard analytics
- [ ] Connection pooling (Supavisor / PgBouncer)
- [ ] API response caching (stale-while-revalidate)
- [ ] Pagination on all list endpoints (cursor-based, not offset)
- [ ] Query optimization (N+1 prevention, select only needed columns)
- [ ] CDN for static assets and API responses

### 5.4 Infrastructure

- [ ] Move from single Next.js process to distributed:
  - Next.js frontend (Vercel)
  - Background workers (queue processing, email, reports)
  - WebSocket server (real-time updates)
- [ ] Message queue (Redis / Upstash) for async tasks
- [ ] Object storage (Supabase Storage / S3) for files:
  - Guest ID documents
  - Property photos
  - Invoice PDFs
  - Receipt images
- [ ] Error tracking (Sentry)
- [ ] Performance monitoring (OpenTelemetry)
- [ ] Uptime monitoring
- [ ] Log aggregation

### 5.5 Real-Time Features

- [ ] Live booking updates (when staff creates a booking, others see it instantly)
- [ ] Room status changes (housekeeping → front desk sync)
- [ ] Notification bell (real-time alerts)
- [ ] Live dashboard counters
- [ ] Collaborative editing (two receptionists editing same booking)

---

## 6. Phase 4: Integrations

**Goal:** Connect HotelOS with the broader hospitality ecosystem.

### 6.1 Channel Manager (OTA Integration)

- [ ] Booking.com connectivity (via API or Beds24 bridge)
- [ ] Airbnb sync (calendar + pricing)
- [ ] Expedia / Vrbo
- [ ] Google Hotel Ads
- [ ] Agoda
- [ ] Two-way sync:
  - Availability → OTA
  - Bookings ← OTA
  - Pricing → OTA
  - Room details → OTA

### 6.2 Payment Gateways

- [ ] Stripe (credit card processing)
- [ ] PayPal
- [ ] Razorpay (India)
- [ ] Local payment methods per region
- [ ] Payment link generation (email guest a pay link)
- [ ] Recurring billing (long-stay guests)

### 6.3 Communication

- [ ] Email service (Resend / SendGrid / Postmark)
  - Booking confirmation
  - Check-in instructions
  - Payment receipts
  - Cancellation notices
  - Review requests
- [ ] SMS notifications (Twilio)
  - Check-in reminder
  - Payment received
  - Emergency alerts
- [ ] WhatsApp Business API
- [ ] In-app messaging (guest ↔ staff)

### 6.4 Smart Locks & IoT

- [ ] Smart lock integration (generate door codes on check-in)
- [ ] Keyless entry systems
- [ ] Thermostat control (auto-adjust when room is empty)
- [ ] Energy monitoring

### 6.5 Accounting

- [ ] QuickBooks integration
- [ ] Xero integration
- [ ] Export to accounting software
- [ ] Tax compliance per jurisdiction

### 6.6 Analytics & BI

- [ ] Google Analytics (dashboard usage)
- [ ] Export to Google Sheets
- [ ] Power BI / Tableau connector
- [ ] Custom dashboard builder

---

## 7. Phase 5: Enterprise

**Goal:** Serve large hotel chains, resorts, and government properties.

### 7.1 Advanced Features

- [ ] Multi-property management (chain view)
- [ ] Central reservations system (book across properties)
- [ ] Inter-property guest transfers
- [ ] Revenue management system (AI-powered pricing)
- [ ] Group bookings (block rooms for events)
- [ ] Banquet & event management
- [ ] Restaurant / F&B POS integration
- [ ] Spa & activity booking
- [ ] Airport transfer scheduling

### 7.2 Compliance & Security

- [ ] SOC 2 Type II compliance
- [ ] GDPR compliance (data export, right to be forgotten)
- [ ] PCI DSS compliance (payment card handling)
- [ ] HIPAA compliance (for medical/resort properties)
- [ ] Audit log (immutable, tamper-proof)
- [ ] Data retention policies
- [ ] IP allowlisting
- [ ] SSO / SAML (Okta, Azure AD, Google Workspace)
- [ ] SCIM user provisioning
- [ ] Two-factor authentication (TOTP, hardware keys)

### 7.3 Self-Hosting

- [ ] Kubernetes deployment manifests
- [ ] Helm chart
- [ ] One-click deploy (Railway, Render, Fly.io)
- [ ] Air-gapped deployment (for government/military)
- [ ] Custom domain support
- [ ] White-label option (rebrand for hotel chains)

### 7.4 API for Third Parties

- [ ] Public REST API (OAuth2 authenticated)
- [ ] GraphQL API (for flexible queries)
- [ ] Webhook system (event-driven integrations)
- [ ] API documentation (OpenAPI / Swagger)
- [ ] Developer portal
- [ ] API rate limiting per integration
- [ ] SDK generation (TypeScript, Python, Go, Java)

### 7.5 Mobile App

- [ ] React Native app (iOS + Android)
- [ ] Guest-facing app (booking, check-in, requests)
- [ ] Staff app (housekeeping, maintenance, notifications)
- [ ] Offline mode (for areas with poor connectivity)

---

## 8. Database Migration: SQLite → Supabase

### 8.1 Why Migrate

| Problem with SQLite | How Supabase Solves It |
|---|---|
| Single file — no concurrent connections | PostgreSQL handles thousands of concurrent connections |
| No read replicas | Read replicas for analytics without impacting writes |
| No row-level security | RLS enforces multi-tenant isolation at DB level |
| No table partitioning | Native table partitioning for bookings > 10M rows |
| No exclusion constraints | Exclusion constraints prevent double-booking |
| No window functions | SQL analytics (RevPAR, YoY growth, rolling averages) |
| Vendor lock-in (custom format) | Standard PostgreSQL — migrate anywhere |
| No self-hosting option | Supabase is fully open-source |
| No connection pooling needed at scale | Supavisor / PgBouncer built-in |

### 8.2 Migration Steps

```
Step 1: Preparation
├── Audit current SQLite schema
├── Map all data types (SQLite integers → PostgreSQL integers/bigints)
├── Identify all foreign keys and constraints
├── List all indexes
└── Export seed data (if any)

Step 2: Supabase Setup
├── Create Supabase project
├── Configure PostgreSQL schema (based on current Drizzle schema)
├── Add Row-Level Security policies
├── Add exclusion constraint for double-booking prevention
├── Configure Supabase Auth (or keep Better Auth with PostgreSQL adapter)
└── Set up environment variables

Step 3: Schema Conversion
├── Convert Drizzle SQLite schema → Drizzle PostgreSQL schema
├── Update table names to use underscores consistently
├── Update column types (integer timestamps → timestamptz)
├── Add indexes for performance
├── Add RLS policies
└── Generate migration files

Step 4: Data Migration
├── Export data from SQLite (CSV or INSERT statements)
├── Import into Supabase PostgreSQL
├── Verify data integrity (row counts, checksums)
└── Test all queries against new database

Step 5: Application Update
├── Update db/index.ts (Drizzle connection → Supabase PostgreSQL)
├── Update drizzle.config.ts (dialect: 'postgresql')
├── Test all database operations
├── Test auth flow
├── Test all API endpoints
└── Performance testing

Step 6: Cutover
├── Put app in maintenance mode
├── Final data sync (delta from step 4)
├── Switch DNS / config to Supabase
├── Run smoke tests
├── Bring app back online
└── Monitor for 48 hours

Step 7: Cleanup
├── Remove SQLite files
├── Remove SQLite-specific dependencies
├── Update documentation
└── Update deployment configs
```

### 8.3 Schema Changes During Migration

```sql
-- Add tenant column to all tables
ALTER TABLE properties ADD COLUMN tenant_id text NOT NULL DEFAULT 'default';
ALTER TABLE rooms ADD COLUMN tenant_id text NOT NULL DEFAULT 'default';
ALTER TABLE guests ADD COLUMN tenant_id text NOT NULL DEFAULT 'default';
ALTER TABLE bookings ADD COLUMN tenant_id text NOT NULL DEFAULT 'default';
ALTER TABLE payments ADD COLUMN tenant_id text NOT NULL DEFAULT 'default';

-- Create tenants table
CREATE TABLE tenants (
  id text PRIMARY KEY DEFAULT gen_random_text(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  plan text NOT NULL DEFAULT 'free',
  settings jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Enable RLS on all tables
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
-- ... etc for all tables

-- RLS policy example
CREATE POLICY tenant_isolation ON bookings
  USING (tenant_id = current_setting('app.current_tenant', true));

-- Prevent double-booking
ALTER TABLE bookings ADD CONSTRAINT no_overlap
  EXCLUDE USING gist (
    room_id WITH =,
    tstzrange(check_in, check_out) WITH &&
  );

-- Partition bookings table (for when we hit millions of rows)
ALTER TABLE bookings DETACH PARTITION bookings_2026_q1;
CREATE TABLE bookings_2026_q2 PARTITION OF bookings
  FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
```

### 8.4 Estimated Effort

| Step | Effort | Risk |
|---|---|---|
| Schema conversion | 1-2 days | Low |
| Data migration | 1 day | Low (small dataset now) |
| Application update | 2-3 days | Medium |
| Testing | 2 days | Medium |
| Cutover | Half day | High |
| **Total** | **~1 week** | |

---

## 9. Architecture Decisions

### ADR-001: Keep Next.js as Full-Stack Framework

**Decision:** Continue using Next.js as the unified frontend + backend framework. Do not split into separate frontend and API servers until Phase 3.

**Rationale:**
- Reduces deployment complexity
- Shared TypeScript types between client and server
- Server Components reduce client bundle size
- API routes are sufficient for current scale
- Splitting adds operational overhead (CORS, separate deploys, versioning)

**When to revisit:** When API routes become a bottleneck (high latency under load) or when background processing needs exceed what serverless can handle.

---

### ADR-002: Supabase Over Convex for Database

**Decision:** When migrating off SQLite, use Supabase (PostgreSQL) — not Convex.

**Rationale:**
- PMS queries are relational (date range joins, availability searches, revenue aggregation) — SQL is the right tool
- Row-Level Security provides automatic multi-tenant isolation
- Exclusion constraints prevent double-booking at the database level
- Table partitioning handles massive datasets
- Read replicas separate analytics from operational queries
- Self-hostable (enterprise requirement)
- Convex has no SQL, no RLS, no partitioning, no self-hosting

**See full comparison in Section 8.1.**

**When to revisit:** If the product pivots away from PMS to something that doesn't need relational queries.

---

### ADR-003: Better Auth Over Supabase Auth (For Now)

**Decision:** Keep Better Auth for authentication even after migrating to Supabase for the database.

**Rationale:**
- Better Auth already works and is integrated
- Passkey support is built-in and tested
- No vendor lock-in to Supabase Auth
- Can switch to Supabase Auth later if needed (both use JWT)

**When to revisit:** If we need features Supabase Auth provides that Better Auth doesn't (e.g., built-in email templates, phone auth, magic links at scale).

---

### ADR-004: Drizzle ORM Over Raw SQL / ORMs

**Decision:** Continue using Drizzle ORM for database access.

**Rationale:**
- Type-safe (generated from schema)
- Lightweight (~3KB, unlike Prisma's heavy runtime)
- SQL-like API (developers who know SQL can use it immediately)
- Supports PostgreSQL and SQLite (easy migration path)
- Migrations are SQL files (inspectable, versionable)
- No black-box query generation (you know what SQL runs)

**When to revisit:** If we need a feature Drizzle doesn't support (materialized views, advanced GIS queries).

---

### ADR-005: SQLite for Development, PostgreSQL for Production (Eventually)

**Decision:** During Phase 1-2, use SQLite for both dev and prod. Migrate to PostgreSQL (Supabase) in Phase 3.

**Rationale:**
- Zero setup cost for local development
- SQLite is fast enough for single-property / small-scale usage
- Drizzle abstracts the database layer — migration is easier
- No need to over-engineer before we have users
- Migration path is clear and tested (Section 8)

**When to revisit:** If we get enterprise customers who demand PostgreSQL from day one.

---

### ADR-006: Bun Over npm/pnpm/yarn

**Decision:** Use Bun as the JavaScript runtime and package manager.

**Rationale:**
- Faster install and startup than npm
- Built-in TypeScript support (no `ts-node`)
- Native test runner (faster than Jest)
- Compatible with npm ecosystem
- Single tool (runtime + bundler + test runner)

**When to revisit:** If we encounter compatibility issues with native modules (better-sqlite3 already had issues) or if the team strongly prefers Node.js.

---

## 10. Performance Targets

| Metric | Phase 1 | Phase 2 | Phase 3 | Phase 4 |
|---|---|---|---|---|
| Page load (dashboard) | < 2s | < 1.5s | < 1s | < 0.5s |
| API response (p95) | < 500ms | < 300ms | < 100ms | < 50ms |
| Database queries | < 100ms | < 50ms | < 20ms | < 10ms |
| Concurrent users | 10 | 100 | 1,000 | 10,000 |
| Bookings in system | 1K | 100K | 10M | 100M |
| Properties supported | 5 | 50 | 1,000 | 10,000 |

### Performance Guidelines

- All list endpoints must support pagination (cursor-based, max 100 items per page)
- All API responses must be under 50KB (use field selection / GraphQL for large responses)
- Images must be optimized (WebP, lazy loading, CDN)
- Database queries must be logged and profiled (no N+1)
- Heavy queries (reports) must run on read replicas
- Cache frequently-accessed data (property settings, room inventory)
- Use `SELECT` only needed columns — never `SELECT *` in production code

---

## 11. Security Checklist

### Authentication & Authorization

- [ ] Rate limiting on all auth endpoints
- [ ] Password policy enforcement (min 8 chars, complexity)
- [ ] Account lockout after N failed attempts
- [ ] Session timeout (configurable, default 24h)
- [ ] Secure session cookies (HttpOnly, Secure, SameSite)
- [ ] CSRF protection on all mutating endpoints
- [ ] Row-Level Security for multi-tenant isolation
- [ ] Role-based access control (RBAC)
- [ ] Audit logging for all destructive actions

### Data Protection

- [ ] Encrypt sensitive data at rest (guest IDs, payment info)
- [ ] Encrypt data in transit (HTTPS everywhere)
- [ ] No PII in logs
- [ ] No secrets in environment files committed to git
- [ ] Database credentials rotated regularly
- [ ] Regular security audits
- [ ] Dependency vulnerability scanning (`bun audit`)
- [ ] Input sanitization (XSS prevention)
- [ ] SQL injection prevention (use parameterized queries via Drizzle)

### Infrastructure

- [ ] HTTPS for all environments (Let's Encrypt)
- [ ] WAF (Web Application Firewall)
- [ ] DDoS protection (Cloudflare)
- [ ] Regular backup (automated, off-site)
- [ ] Backup encryption
- [ ] Disaster recovery plan
- [ ] Incident response plan
- [ ] Penetration testing before each major release

### Compliance

- [ ] GDPR: Data export endpoint
- [ ] GDPR: Right to be forgotten (soft delete + purge)
- [ ] GDPR: Consent management
- [ ] PCI DSS: No raw credit card storage
- [ ] PCI DSS: Use payment processor tokens
- [ ] SOC 2: Audit trail
- [ ] SOC 2: Access controls

---

## 12. Open Questions

These need to be answered before proceeding:

### Business

1. **Target customer:** Small homestays (1-5 rooms) or hotel chains (100+ rooms)?
   - *Impacts: Schema design, pricing model, feature priorities*

2. **Pricing model:** Free/open-source with paid hosting? Freemium? Per-property pricing?
   - *Impacts: Multi-tenant urgency, feature gating*

3. **Geographic focus:** Global or specific regions (SE Asia, Europe, US)?
   - *Impacts: Payment gateways, compliance requirements, localization*

4. **Competitive differentiation:** What makes HotelOS different from Cloudbeds, Mews, Sirvoy?
   - *Impacts: Feature roadmap priorities*

### Technical

5. **Who will own the Supabase project?** Self-managed or use Supabase Cloud?
   - *Impacts: Cost, operational overhead, data sovereignty*

6. **Do we need a mobile app in Phase 4, or is responsive web enough?**
   - *Impacts: React Native development effort vs. PWA*

7. **Real-time requirements:** Does the dashboard need live WebSocket updates, or is polling sufficient?
   - *Impacts: Infrastructure complexity*

8. **Should we support PostgreSQL-only from Phase 1, or is the SQLite → PostgreSQL migration acceptable?**
   - *Impacts: Initial setup complexity vs. long-term flexibility*

9. **Email service provider:** Which one? (Resend, SendGrid, Postmark, SES?)
   - *Impacts: Deliverability, cost, compliance*

10. **Should we build a channel manager from scratch or integrate an existing one (e.g., Beds24, RateGain)?**
    - *Impacts: Months of development vs. integration cost*

---

## Appendix A: Useful Commands

```bash
# Development
bun run dev                    # Start dev server
bun run build                  # Production build
bun run start                  # Production server
bun run lint                   # Lint check

# Database
bun run db:generate            # Generate migration from schema changes
bun run db:push                # Push schema to database
bun run db:studio              # Open Drizzle Studio (visual DB browser)

# Auth
bun run auth:generate          # Generate Better Auth schema

# Docker
docker-compose up -d           # Start in background
docker-compose down            # Stop
docker-compose logs -f         # View logs

# Maintenance
bun audit                      # Check for vulnerable dependencies
bun upgrade                    # Update dependencies
```

## Appendix B: Environment Variables

```bash
# Required
BETTER_AUTH_SECRET=<random-string>          # JWT signing secret
BETTER_AUTH_URL=http://localhost:3000        # App URL
NEXT_PUBLIC_BASE_URL=http://localhost:3000   # Client-side base URL
NEXT_PUBLIC_PASSKEY_RP_ID=localhost          # Passkey relying party ID
NEXT_PUBLIC_PASSKEY_ORIGIN=http://localhost:3000  # Passkey origin

# Phase 1+ (optional)
SMTP_HOST=                                   # Email service host
SMTP_PORT=                                   # Email service port
SMTP_USER=                                   # Email service user
SMTP_PASSWORD=                               # Email service password
EMAIL_FROM=                                  # "From" address

# Phase 3+ (Supabase)
SUPABASE_URL=                                # Supabase project URL
SUPABASE_ANON_KEY=                           # Supabase anon key
SUPABASE_SERVICE_KEY=                        # Supabase service key (server only)
DATABASE_URL=                                # PostgreSQL connection string

# Phase 4+ (Integrations)
STRIPE_SECRET_KEY=                           # Stripe API key
STRIPE_WEBHOOK_SECRET=                       # Stripe webhook signing secret
SENDGRID_API_KEY=                            # SendGrid API key
TWILIO_ACCOUNT_SID=                          # Twilio account SID
TWILIO_AUTH_TOKEN=                           # Twilio auth token
```

## Appendix C: Key File Reference

| File | What it does |
|---|---|
| `lib/auth.ts` | Better Auth server configuration |
| `lib/auth-client.ts` | Better Auth React client (signUp, signIn, signOut) |
| `lib/auth-server.ts` | Server helpers: getSession(), requireAuth(), handleApiError() |
| `lib/store.ts` | Zustand global state (properties, rooms, guests, bookings) |
| `lib/utils.ts` | General utilities (cn() for class merging) |
| `db/schema.ts` | All database table definitions (source of truth) |
| `db/index.ts` | Drizzle ORM initialization and database connection |
| `drizzle.config.ts` | Drizzle Kit configuration (migration generation) |
| `auth-schema.ts` | Duplicate of auth tables — consider removing |
| `middleware.ts` | Next.js middleware (currently a no-op, auth handled client-side) |
| `app/api/auth/[...all]/route.ts` | Better Auth API handler |
| `app/dashboard/auth-guard.tsx` | Client-side auth protection wrapper |
| `app/auth/auth-redirect.tsx` | Redirect logged-in users away from auth pages |

---

*This is a living document. Update it as decisions are made and features are shipped.*
