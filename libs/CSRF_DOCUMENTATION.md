# CSRF Protection Library Documentation

## Overview

This is a custom CSRF (Cross-Site Request Forgery) protection library designed for Lapis applications. It provides enterprise-grade security features including cryptographically secure token generation, timing attack protection, and comprehensive logging.

## Security Features

### 1. Cryptographically Secure Tokens
- **256-bit random tokens** generated using OpenSSL's cryptographically secure random number generator
- Tokens are encoded as hexadecimal strings for safe transport and storage
- Each token is unique per session

### 2. Timing Attack Protection
- Constant-time comparison to prevent timing attacks
- Length validation before comparison to prevent length-based timing attacks
- Character-by-character comparison without early termination

### 3. Session Management
- Tokens stored securely in user sessions
- Automatic token creation on first access
- Token regeneration capability to prevent fixation attacks

### 4. Comprehensive Logging
- Failed validation attempts logged with IP addresses and user agents
- Detailed error messages for debugging
- Integration with Nginx's logging system

### 5. Flexible Middleware
- Configurable HTTP methods that require protection
- Path-based exemptions using regex patterns
- Custom validator support for specialized validation logic

## API Reference

### Core Functions

#### `generate_token()`
Generates a new cryptographically secure CSRF token.

```moonscript
token = csrf.generate_token()
-- Returns: 64-character hexadecimal string
```

**Security Notes:**
- Uses `openssl.rand.bytes(32)` for 256-bit entropy
- Tokens are encoded as hex for safe transport

#### `get_csrf_token(session)`
Retrieves existing CSRF token from session or generates new one.

```moonscript
token = csrf.get_csrf_token(@session)
-- Returns: Token string stored in session
```

**Behavior:**
- Returns existing token if present in session
- Generates new token if none exists
- Automatically stores token in `session.csrf_token`

#### `regenerate_csrf_token(session)`
Generates and stores a new CSRF token, invalidating the previous one.

```moonscript
new_token = csrf.regenerate_csrf_token(@session)
-- Returns: New token string
```

**Use Cases:**
- After user authentication
- When switching contexts
- Periodic token rotation

#### `validate_csrf_token(session, params)`
Validates CSRF token from request against session token.

```moonscript
valid, message = csrf.validate_csrf_token(@session, @params)
-- Returns: boolean, string
```

**Parameters:**
- `session`: User session containing CSRF token
- `params`: Request parameters (checks `csrf_token` and `csrf-token`)

**Return Values:**
- `valid`: `true` if token valid, `false` otherwise
- `message`: Descriptive error message for debugging

#### `csrf_field(session)`
Generates HTML form field for CSRF token.

```moonscript
html = csrf.csrf_field(@session)
-- Returns: '<input type="hidden" name="csrf_token" value="...">'
```

#### `add_csrf_to_context(session, context)`
Adds CSRF token and field to template context.

```moonscript
csrf.add_csrf_to_context(@session, @)
-- Makes @csrf_token and @csrf_field available in templates
```

### Middleware

#### `csrf_middleware(options)`
Creates CSRF validation middleware for request filtering.

```moonscript
csrf_protect = csrf.csrf_middleware {
    exempt_paths: {"/l", "/api/.*"}
}
csrf_protect(@)
```

**Configuration Options:**

- `protected_methods` (array): HTTP methods requiring validation
  - Default: `{"POST", "PUT", "DELETE", "PATCH"}`

- `exempt_paths` (array): Paths exempt from CSRF validation
  - Default: `{}`
  - Supports regex patterns (e.g., `"/api/.*"`)

- `error_message` (string): Error message for invalid tokens
  - Default: `"Invalid CSRF token"`

- `custom_validator` (function): Custom validation function
  - Receives `self` (request context)
  - Should return `true` for valid, `false` for invalid

## Implementation Guide

### 1. Basic Setup

In your main application (`app.moon`):

```moonscript
csrf = require "libs/csrf"

class extends lapis.Application
    @before_filter =>
        -- Apply CSRF protection to all POST requests except login
        csrf_protect = csrf.csrf_middleware {
            exempt_paths: {"/l"} -- Exempt login route
        }
        csrf_protect(@)

        -- Add CSRF token to all templates
        csrf.add_csrf_to_context(@session, @)
```

### 2. Template Integration

In your views (e.g., etlua templates):

```html
<form method="post" action="/submit">
    <%= csrf_field %>
    <!-- Other form fields -->
    <button type="submit">Submit</button>
</form>

<!-- Or access token directly -->
<input type="hidden" name="csrf_token" value="<%= csrf_token %>">
```

### 3. Manual Token Validation

For custom validation logic:

```moonscript
class extends lapis.Application
    "/custom-action": =>
        if @req.method == "POST"
            valid, message = csrf.validate_csrf_token(@session, @params)
            if not valid
                @status = 403
                return "CSRF validation failed: " .. message

            -- Process valid request
```

### 4. Advanced Configuration

Custom middleware configuration:

```moonscript
csrf_protect = csrf.csrf_middleware {
    protected_methods: {"POST", "PUT", "DELETE", "PATCH"}
    exempt_paths: {
        "/l"           -- Login endpoint
        "/api/.*"      -- All API endpoints
        "/webhook/.*"  -- Webhook endpoints
    }
    error_message: "Security validation failed"
    custom_validator: (self) =>
        -- Custom validation logic
        return some_custom_check(self)
}
```

## Security Best Practices

### 1. Token Management
- Regenerate tokens after authentication
- Use HTTPS in production to protect tokens in transit
- Don't expose tokens in JavaScript or URLs

### 2. Path Exemptions
- Only exempt endpoints that truly need it (e.g., login, webhooks)
- Use specific patterns instead of broad exemptions
- Document why each path is exempt

### 3. Error Handling
- Don't expose detailed error messages to users
- Log validation failures for security monitoring
- Return generic error messages to clients

### 4. Monitoring
- Monitor `hallofshame.log` for suspicious activity
- Set up alerts for high rates of CSRF failures
- Review logs regularly for attack patterns

## Implementation Details

### Token Generation Process
1. Generate 32 cryptographically secure random bytes
2. Convert bytes to hexadecimal string (64 characters)
3. Store in session under `csrf_token` key

### Validation Process
1. Check for token in session
2. Extract token from request parameters
3. Validate token lengths match
4. Perform constant-time character comparison
5. Log validation result with metadata

### Error Handling
- Invalid tokens return 403 Forbidden status
- Detailed errors logged with IP and User-Agent
- Generic error messages returned to client

## Migration from Lapis Built-in CSRF

If switching from Lapis's built-in CSRF:

1. Remove Lapis CSRF configuration
2. Add custom middleware as shown above
3. Update templates to use `csrf_field` helper
4. Test all forms with POST/PUT/DELETE/PATCH
5. Monitor logs for validation issues

## Troubleshooting

### Common Issues

**"No CSRF token in session" error:**
- Ensure `add_csrf_to_context` is called before rendering
- Check session configuration
- Verify session storage is working

**"No CSRF token in request" error:**
- Add `<%= csrf_field %>` to forms
- Check JavaScript AJAX requests include token
- Verify token name in request parameters

**"Invalid CSRF token" error:**
- Check for token regeneration between request/response
- Verify session persistence
- Check for multiple tabs/windows with different tokens

### Debug Mode

Add temporary debugging to middleware:

```moonscript
csrf_protect = csrf.csrf_middleware {
    custom_validator: (self) =>
        valid, message = csrf.validate_csrf_token(self.session, self.params)
        ngx.log(ngx.INFO, "CSRF Debug: valid=", valid, " message=", message)
        return valid
}
```

## Dependencies

- `openssl.rand` - For cryptographically secure random number generation
- `ngx` - Nginx module for logging and request information
- Session storage - Must be configured in Lapis application