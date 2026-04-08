<p align="center">
  <strong>HotelOS</strong> — A modern property management platform for hospitality.
</p>

---

HotelOS is a property management system designed for hotels, homestays, villas, and other accommodation properties. Built with performance and usability in mind, it provides everything needed to manage property operations from a single dashboard.

## Features

- **Dashboard Overview** — Real-time insights into bookings, occupancy, and revenue
- **Booking Management** — Create, modify, and track reservations
- **Guest Profiles** — Centralized guest information and history
- **Room Management** — Monitor availability, status, and maintenance schedules
- **Financial Reports** — Generate detailed occupancy and revenue analytics
- **Multi-Property Support** — Manage multiple locations from one account
- **Fully Responsive** — Optimized for desktop, tablet, and mobile

## Tech Stack

| Layer            | Technology                                      |
|------------------|-------------------------------------------------|
| Framework        | Next.js 15 (App Router)                         |
| UI Components    | shadcn/ui + Radix UI                            |
| Styling          | Tailwind CSS                                    |
| Authentication   | Better Auth                                     |
| Database         | SQLite + Drizzle ORM                            |
| Runtime          | Bun                                             |

## Quick Start

### Prerequisites

- Bun installed
- SQLite (included, no setup required)

### Run Locally

```bash
# Install dependencies
bun install

# Set up environment variables
cp .example.env .env

# Initialize database
bun run db:generate
bun run db:push

# Start the development server
bun run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Production Build

```bash
bun run build
bun run start
```

### Database Commands

```bash
bun run db:generate   # Generate migration files
bun run db:push       # Push schema changes to database
bun run db:studio     # Open Drizzle Studio (database GUI)
```

## Docker Deployment

```bash
# Start with Docker Compose
docker-compose up -d
```

The application will be available at `http://localhost:3000` with persistent database storage.

## Project Structure

```
├── app/                  # Next.js App Router
│   ├── auth/             # Authentication pages (login, signup)
│   ├── dashboard/        # Protected dashboard routes
│   └── api/              # API routes (auth handler)
├── components/           # React components
│   └── ui/               # UI component primitives
├── db/                   # Database schema and connection
├── drizzle/              # Migration files
├── lib/                  # Utilities and shared code
└── hooks/                # Custom React hooks
```

## License

MIT License — see [LICENSE](LICENSE) for details.
# hotelos-pms
# hotelos-pms
