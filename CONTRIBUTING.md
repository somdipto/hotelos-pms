# Contributing to HotelOS

Thank you for your interest in contributing to HotelOS! Our goal is to provide an open-source property management system for hotels, homestays, villas, and other accommodation properties. We welcome contributions in all forms—from bug fixes and design improvements to brand-new features.

> HotelOS is built with Next.js (app router), React, and Tailwind CSS. The project uses shadcn/ui components and follows modern web development practices. Please ensure your contributions follow our best practices for clarity, maintainability, and consistency.

## Table of Contents

- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Submitting Changes](#submitting-changes)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Feature Guidelines](#feature-guidelines)
- [Code of Conduct](#code-of-conduct)

## How to Contribute

There are many ways to contribute to HotelOS:

- **Report bugs** — Open an issue if you find a bug
- **Request features** — Suggest improvements via GitHub Issues
- **Fix bugs** — Submit pull requests for open issues
- **Add features** — Propose new features with a clear plan
- **Improve docs** — Help make documentation clearer and more comprehensive
- **Review PRs** — Provide feedback on open pull requests

## Development Setup

1. Fork the repository
2. Clone your fork:

   ```bash
   git clone https://github.com/<your-username>/hotelos.git
   cd hotelos
   ```

3. Install dependencies:

   ```bash
   bun install
   ```

4. Set up environment variables:

   ```bash
   cp .example.env .env
   ```

5. Set up the database:

   ```bash
   bun run db:generate
   bun run db:push
   ```

6. Start the development server:

   ```bash
   bun run dev
   ```

7. Open [http://localhost:3000](http://localhost:3000) and start developing.

## Submitting Changes

1. Create a feature branch from `main`:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit them following our [Commit Message Guidelines](#commit-message-guidelines).

3. Push your branch:

   ```bash
   git push origin feature/your-feature-name
   ```

4. Open a Pull Request against the `main` branch.

### Pull Request Checklist

- [ ] Changes are tested and work as expected
- [ ] Code follows project style conventions
- [ ] Commit messages follow Conventional Commits format
- [ ] New features include appropriate documentation updates
- [ ] No sensitive data or secrets are committed

### Review Process

- All PRs require at least one review before merging
- CI checks must pass (linting, type checking)
- Reviewers may request changes or additional context
- Be responsive to review feedback

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat` — New feature
- `fix` — Bug fix
- `docs` — Documentation changes
- `style` — Code style changes (formatting, semicolons, etc.)
- `refactor` — Code refactoring (no new features, no bug fixes)
- `perf` — Performance improvements
- `test` — Adding or updating tests
- `chore` — Maintenance tasks, build config, dependencies

### Examples

```
feat(bookings): add calendar view for reservations
fix(auth): resolve session timeout on refresh
docs(readme): update installation instructions
refactor(dashboard): simplify chart data fetching
chore(deps): update shadcn/ui components
```

## Feature Guidelines

When adding new features to HotelOS, please follow these guidelines to maintain consistency and quality:

### UI Components

- Use [shadcn/ui](https://ui.shadcn.com/) components as the base
- Place new components in `/components/ui/` for shared primitives
- Feature-specific components go in `/components/`
- Follow existing naming conventions (PascalCase for components)

### Styling

- Use Tailwind CSS utility classes exclusively
- Avoid inline styles or CSS modules
- Use `cn()` from `lib/utils.ts` for conditional class merging

### Database Changes

- Update the schema in `db/schema.ts`
- Run `bun run db:generate` to create a migration
- Document any breaking changes in the PR description

### API Routes

- Place routes in `/app/api/<feature>/`
- Follow the existing error handling patterns
- Use Zod for request validation

### State Management

- Use React Context for auth and theme
- Use Zustand for complex client-side state
- Keep state close to where it's used

## Code of Conduct

- Be respectful and inclusive in all interactions
- Provide constructive feedback
- Accept constructive criticism gracefully
- Focus on what is best for the community

## Need Help?

- Check existing issues and discussions
- Ask questions in GitHub Discussions
- Review the codebase for patterns and conventions

##

Thank you for taking the time to contribute to HotelOS. We truly appreciate your efforts and look forward to collaborating with you!
