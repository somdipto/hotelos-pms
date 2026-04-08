# HotelOS Documentation

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Database](#database)
- [Authentication](#authentication)
- [API Routes](#api-routes)
- [State Management](#state-management)
- [Styling](#styling)
- [Deployment](#deployment)
- [Common Tasks](#common-tasks)

---

## Overview

HotelOS is a full-stack property management system built with Next.js. It handles everything — frontend, backend API, authentication, and database — in a single application.

**Tech Stack:**
- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript (strict mode)
- **UI:** React 19 + shadcn/ui + Radix UI
- **Styling:** Tailwind CSS
- **Auth:** Better Auth (email/password + passkeys)
- **Database:** SQLite + Drizzle ORM
- **Runtime:** Bun
- **Package Manager:** Bun

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   Browser                        │
│  (React Client Components)                       │
│  - Pages (app/)                                  │
│  - UI Components (components/)                   │
│  - Hooks (hooks/)                                │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              Next.js Server (Node.js)            │
│                                                  │
│  ┌──────────────┐  ┌─────────────────────────┐  │
│  │  App Router   │  │    API Routes           │  │
│  │  (SSR/SSG)   │  │  /api/auth/[...all]     │  │
│  │  /dashboard   │  │  /api/health            │  │
│  │  /auth        │  │  /api/passkeys          │  │
│  └──────────────┘  └─────────────────────────┘  │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │         Server Logic (lib/)              │   │
│  │  auth.ts        → Better Auth config    │   │
│  │  auth-server.ts → Session helpers       │   │
│  │  auth-client.ts → React auth client     │   │
│  │  store.ts       → Zustand state         │   │
│  └──────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              SQLite Database                     │
│                                                  │
│  Tables: user, session, account, verification,  │
│  passkey, properties, rooms, guests, bookings,  │
│  payments                                        │
│                                                  │
│  ORM: Drizzle ORM                                │
│  Migrations: drizzle/ folder                     │
└─────────────────────────────────────────────────┘
```

---

## Project Structure

```
├── app/                          # Next.js App Router
│   ├── layout.tsx                # Root layout (metadata, providers)
│   ├── page.tsx                  # Landing page
│   ├── auth/                     # Authentication pages
│   │   ├── login/page.tsx        # Login form
│   │   ├── signup/page.tsx       # Registration form
│   │   ├── auth-redirect.tsx     # Redirect if already logged in
│   │   └── error/page.tsx        # Auth error page
│   ├── dashboard/                # Protected dashboard area
│   │   ├── layout.tsx            # Dashboard layout (sidebar, header)
│   │   ├── page.tsx              # Dashboard home
│   │   ├── auth-guard.tsx        # Client-side auth protection
│   │   └── settings/page.tsx     # Settings page
│   └── api/                      # API routes (backend)
│       ├── auth/[...all]/        # Better Auth handler
│       ├── health/               # Health check endpoint
│       └── passkeys/             # Passkey operations
│
├── components/                   # React components
│   ├── ui/                       # shadcn/ui primitives (button, input, etc.)
│   ├── app-sidebar.tsx           # Main navigation sidebar
│   ├── nav-user.tsx              # User menu in sidebar
│   ├── property-switcher.tsx     # Property selector
│   ├── auth-provider.tsx         # Better Auth provider wrapper
│   └── logout-button.tsx         # Logout button component
│
├── db/                           # Database layer
│   ├── index.ts                  # Drizzle ORM initialization
│   └── schema.ts                 # All table definitions
│
├── drizzle/                      # Migration files
│   ├── 0000_*.sql                # Initial migration
│   ├── 0001_*.sql                # Schema update migration
│   ├── 0002_*.sql                # Name field nullable fix
│   └── meta/                     # Drizzle metadata
│
├── lib/                          # Shared utilities
│   ├── auth.ts                   # Better Auth server config
│   ├── auth-client.ts            # Better Auth React client
│   ├── auth-server.ts            # Session & error helpers
│   ├── store.ts                  # Zustand global state
│   └── utils.ts                  # General utilities (cn(), etc.)
│
├── hooks/                        # Custom React hooks
│
├── public/                       # Static assets (images, icons)
│
├── styles/                       # Global CSS
│
├── drizzle.config.ts             # Drizzle Kit configuration
├── next.config.mjs               # Next.js configuration
├── tailwind.config.ts            # Tailwind CSS configuration
├── middleware.ts                 # Next.js middleware (auth routing)
├── package.json                  # Dependencies and scripts
└── tsconfig.json                 # TypeScript configuration
```

---

## Getting Started

### Prerequisites

- [Bun](https://bun.sh/) installed
- Node.js 20+ (if not using Bun)

### First-time Setup

```bash
# 1. Install dependencies
bun install

# 2. Set up environment
cp .example.env .env

# 3. Initialize database
bun run db:generate
bun run db:push

# 4. Start dev server
bun run dev
```

Open [http://localhost:3000](http://localhost:3000).

### Available Scripts

| Command | Description |
|---|---|
| `bun run dev` | Start development server (hot reload) |
| `bun run build` | Production build |
| `bun run start` | Start production server |
| `bun run lint` | Run ESLint |
| `bun run db:generate` | Generate migration files from schema changes |
| `bun run db:push` | Apply migrations to database |
| `bun run db:studio` | Open Drizzle Studio (database GUI) |

---

## Database

### Engine: SQLite

SQLite is a file-based database. No separate database server is needed.

### Database File Location

| Environment | Path |
|---|---|
| Development | `./hotelos.db` (project root) |
| Production | `./data/hotelos.db` |

### ORM: Drizzle

All table definitions are in [`db/schema.ts`](db/schema.ts).

**Current tables:**

| Table | Purpose |
|---|---|
| `user` | User accounts (Better Auth) |
| `session` | User sessions (Better Auth) |
| `account` | OAuth/provider accounts (Better Auth) |
| `verification` | Email verification tokens (Better Auth) |
| `passkey` | Passkey credentials (Better Auth) |
| `properties` | Hotel/homestay properties |
| `rooms` | Rooms/units within properties |
| `guests` | Guest information |
| `bookings` | Reservations and stays |
| `payments` | Payment records |

### Making Schema Changes

```bash
# 1. Edit db/schema.ts

# 2. Generate migration
bun run db:generate

# 3. Apply to database
bun run db:push
```

### Viewing the Database

```bash
# Open Drizzle Studio (visual database browser)
bun run db:studio

# Or query directly with SQLite
sqlite3 hotelos.db ".tables"
sqlite3 hotelos.db "SELECT * FROM user;"
```

---

## Authentication

### System: Better Auth

Better Auth handles all authentication — email/password, sessions, and passkeys.

### Configuration Files

| File | Purpose |
|---|---|
| `lib/auth.ts` | Server-side Better Auth config |
| `lib/auth-client.ts` | Client-side auth functions |
| `lib/auth-server.ts` | Server helpers (getSession, requireAuth) |
| `app/api/auth/[...all]/route.ts` | API route handler for auth |

### How It Works

**Registration:**
```tsx
import { signUp } from "@/lib/auth-client";

const result = await signUp.email({
  name: "John Doe",
  email: "john@example.com",
  password: "securepassword",
});
```

**Login:**
```tsx
import { signIn } from "@/lib/auth-client";

const result = await signIn.email({
  email: "john@example.com",
  password: "securepassword",
});
```

**Check Session:**
```tsx
import { authClient } from "@/lib/auth-client";

const { data: session, isPending } = authClient.useSession();
```

**Server-side Session Check:**
```tsx
import { getSession } from "@/lib/auth-server";

const session = await getSession();
```

### Environment Variables

| Variable | Description |
|---|---|
| `BETTER_AUTH_SECRET` | Secret for signing tokens |
| `BETTER_AUTH_URL` | Base URL of the app |
| `NEXT_PUBLIC_BASE_URL` | Base URL for auth client |
| `NEXT_PUBLIC_PASSKEY_RP_ID` | Passkey relying party ID |
| `NEXT_PUBLIC_PASSKEY_ORIGIN` | Passkey origin URL |

---

## API Routes

All backend API lives in `app/api/`.

| Route | Purpose |
|---|---|
| `/api/auth/[...all]` | Better Auth — handles sign-up, sign-in, session, passkeys |
| `/api/health` | Health check endpoint |
| `/api/passkeys` | Passkey-specific operations |

### Adding a New API Route

Create a file at `app/api/<route>/route.ts`:

```tsx
import { NextResponse } from "next/server";

export async function GET(request: Request) {
  return NextResponse.json({ message: "Hello" });
}

export async function POST(request: Request) {
  const body = await request.json();
  return NextResponse.json({ received: body });
}
```

---

## State Management

### Zustand (Global Client State)

Located in [`lib/store.ts`](lib/store.ts).

Stores:
- Properties list
- Rooms list
- Guests list
- Bookings list
- Payments list

Usage:
```tsx
import { useStore } from "@/lib/store";

const properties = useStore((state) => state.properties);
const addProperty = useStore((state) => state.addProperty);
```

### React Context

- `AuthProvider` (`components/auth-provider.tsx`) — wraps the app with Better Auth session context

---

## Styling

### Tailwind CSS

All styling uses Tailwind utility classes. Configuration in `tailwind.config.ts`.

### shadcn/ui

UI component primitives in `components/ui/`. These are copied-in components (not a dependency) so you can modify them freely.

### Adding a New shadcn Component

```bash
npx shadcn@latest add <component-name>
```

---

## Deployment

### Docker

```bash
# Build and run
docker-compose up -d

# Or manually
docker build -t hotelos .
docker run -p 3000:3000 -v ./data:/app/data hotelos
```

Database persists in the `./data` volume.

### VPS / Bare Metal

```bash
# Build
bun run build

# Start
bun run start
```

The app runs on port 3000 by default. Use a reverse proxy (nginx, Caddy, Traefik) for production.

### Environment Variables

All variables from `.example.env` must be set in production.

---

## Common Tasks

### Add a New Page

1. Create `app/<route>/page.tsx`
2. If it needs auth, wrap with `AuthGuard`:
   ```tsx
   import AuthGuard from "@/app/dashboard/auth-guard";
   
   export default function MyPage() {
     return (
       <AuthGuard>
         {/* your page */}
       </AuthGuard>
     );
   }
   ```

### Add a New Database Table

1. Add table to `db/schema.ts`
2. Run `bun run db:generate`
3. Run `bun run db:push`

### Add a New API Endpoint

Create `app/api/<feature>/route.ts` with your handlers.

### Add a New UI Component

```bash
npx shadcn@latest add <component>
```

---

## Need Help?

- **Architecture questions** — Read this doc and check `AGENTS.md`
- **Auth issues** — See [Better Auth docs](https://better-auth.com)
- **Next.js issues** — See [Next.js docs](https://nextjs.org/docs)
- **Drizzle issues** — See [Drizzle docs](https://orm.drizzle.team)
