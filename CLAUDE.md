# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Environment Setup
```bash
# Using Nix (recommended)
nix-shell

# Or manual setup (see setup.sh)
sudo apt-get install openresty uuid-dev libmagickwand-dev luarocks libcurl4-openssl-dev libargon2-dev libssl-dev libsqlite3-dev
sudo luarocks install lapis moonscript markdown lsqlite3 bcrypt lua-uuid luafilesystem magick lume argon2 sendmail luasec Lua-curl json-lua
```

### Build and Run
```bash
# Compile MoonScript to Lua
moonc .

# Run database migrations
lapis migrate

# Start development server
lapis server

# Build for production
lapis build
```

### Testing and Development
- No test framework is currently configured
- Check logs in `application.log` and `hallofshame.log`
- Database file: `showtime-v2.sqlite`

## Architecture Overview

### Framework and Language
- **Lapis**: Lua web framework running on OpenResty (Nginx + Lua)
- **MoonScript**: Primary language that compiles to Lua (all `.moon` files have corresponding `.lua` files)
- **SQLite**: Database for persistence

### Core Structure

#### Application Flow
1. **Entry Point**: `app.moon` - Main Lapis application with CSRF protection middleware
2. **Route Handlers**: `/applications/` directory contains modular route handlers:
   - `login.moon` - Authentication (email-based, password auth exists but unused)
   - `dashboard.moon` - User dashboard and main navigation
   - `workshops.moon` - Workshop CRUD operations
   - `admin.moon` - Administrative functions

#### Data Layer
- **Models**: `/models/` directory with MoonScript ORM models:
  - `Users` - Three roles: admin (99), teacher (20), guest (10)
  - `Workshops` - Visibility levels: invite_only (0), unlisted (1), public (2)
  - `Participations` - User workshop registrations with approval status
  - `Files` - Workshop file attachments
  - `Sessiontokens` - Session-based authentication
  - `Emailcodes` - Email verification codes
  - `Invites` - Workshop invite codes (not yet implemented)

#### Security Features
- **CSRF Protection**: Custom CSRF library in `/libs/csrf.moon` with token generation, validation, and middleware
- **Session Management**: Token-based sessions with expiry
- **Request Logging**: "Hall of Shame" logging for suspicious 404 attempts
- **Role-based Access**: Different permissions for admin, teacher, and guest roles

### Key Implementation Details

#### MoonScript Workflow
- Write code in `.moon` files (more concise syntax)
- Compile with `moonc .` to generate `.lua` files
- Lapis runs the compiled Lua files
- Both versions exist in repo (31 MoonScript files, 31 Lua files)

#### Database Migrations
- Single migration file: `migrations.moon`
- Defines all tables and initial schema
- Run with `lapis migrate`

#### User Registration Flow
- All new signups default to teacher role
- Email-based authentication (no password setup UI yet)
- Session tokens stored in database with expiry

#### Workshop System
- Teachers can create workshops with visibility settings
- Participants can join workshops and require approval
- File attachments supported
- Extra text field with configurable visibility

### Current Limitations
- Invite system not implemented (models exist but no UI)
- Password authentication exists but no way to set passwords
- No way to get a role outside of guest without editing files
- No automated testing
