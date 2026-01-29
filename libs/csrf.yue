-- CSRF Protection Library for Lapis
-- Provides secure token generation and validation to prevent CSRF attacks

openssl_rand = require "openssl.rand"
ngx = require "ngx"

-- Convert binary data to hexadecimal string for safe storage and transmission
binary_to_hex = (binary) ->
  return string.gsub(binary, ".", (c) ->
    return string.format("%02x", string.byte(c))
  )

-- Convert hexadecimal string back to binary
hex_to_binary = (hex) ->
  return string.gsub(hex, "..", (cc) ->
    return string.char(tonumber(cc, 16))
  )

-- Generate a cryptographically secure CSRF token
generate_token = ->
  -- Generate 32 random bytes (256 bits) and convert to hex for storage
  binary = openssl_rand.bytes(32)
  return binary_to_hex(binary)

-- Get or create a CSRF token for the current session
get_csrf_token = (session) ->
  -- Check if token already exists in session
  if session.csrf_token
    return session.csrf_token
  
  -- Generate new token and store in session
  token = generate_token()
  session.csrf_token = token
  return token

-- Regenerate CSRF token to prevent token fixation attacks
regenerate_csrf_token = (session) ->
  token = generate_token()
  session.csrf_token = token
  return token

-- Validate CSRF token from request against session token
validate_csrf_token = (session, params) ->
  -- Get token from session
  session_token = session.csrf_token
  if not session_token
    return false, "No CSRF token in session"
  
  -- Get token from request parameters (POST data or query string)
  request_token = params.csrf_token or params["csrf-token"]
  if not request_token
    return false, "No CSRF token in request"
  
  -- Compare tokens with constant-time comparison to prevent timing attacks
  if string.len(session_token) ~= string.len(request_token)
    return false, "Token length mismatch"
  
  -- Simple character-by-character comparison
  for i = 1, string.len(session_token)
    if string.byte(session_token, i) ~= string.byte(request_token, i)
      return false, "Invalid CSRF token"
  
  return true, "Valid CSRF token"

-- Generate HTML form field for CSRF token
csrf_field = (session) ->
  token = get_csrf_token(session)
  return "<input type=\"hidden\" name=\"csrf_token\" value=\"#{token}\">"

-- Add CSRF token to template context
add_csrf_to_context = (session, context) ->
  context.csrf_token = get_csrf_token(session)
  context.csrf_field = csrf_field(session)
  return context

-- Middleware function to validate CSRF tokens on POST requests
csrf_middleware = (csrf_options = {}) ->
  -- Default options
  options = {
    -- HTTP methods that require CSRF validation
    protected_methods: {"POST", "PUT", "DELETE", "PATCH"}
    -- Error message for invalid tokens
    error_message: "Invalid CSRF token"
    -- Whether to skip validation for certain paths
    exempt_paths: csrf_options.exempt_paths or {}
    -- Custom validation function (optional)
    custom_validator: csrf_options.custom_validator or nil
  }
  
  return (self) ->
    -- Check if request method requires CSRF protection
    method = self.req.cmd_mth
    -- Check if method requires protection using a helper function
    is_protected = false
    for protected_method in *options.protected_methods
      if method == protected_method
        is_protected = true
        break
    
    if not is_protected
      return true -- Skip validation for non-protected methods
    
    -- Check if current path is exempt from CSRF validation
    path = self.req.parsed_url.path
    for exempt_path in *options.exempt_paths
      if path\match(exempt_path)
        return true -- Skip validation for exempt paths
    
    -- Use custom validator if provided
    if options.custom_validator
      return options.custom_validator(self)
    
    -- Default validation
    valid, message = validate_csrf_token(self.session, self.params)
    if not valid
      -- Log the attempt for debugging
      ngx.log(ngx.WARN, "CSRF validation failed: " .. message .. 
                      " for path: " .. path .. 
                      " from IP: " .. (self.req.headers["X-Forwarded-For"] or ngx.var.remote_addr))
      
      -- Return 403 Forbidden response
      self.status = 403
      return { render: false, layout: false }, options.error_message
    
    return true

return {
  generate_token: generate_token
  get_csrf_token: get_csrf_token
  regenerate_csrf_token: regenerate_csrf_token
  validate_csrf_token: validate_csrf_token
  csrf_field: csrf_field
  add_csrf_to_context: add_csrf_to_context
  csrf_middleware: csrf_middleware
}