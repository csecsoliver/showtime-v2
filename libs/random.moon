log = require "libs/log"
hrt = (digits) -> -- human-readable token, don't think of the wrong thing
    f = io.open("/dev/urandom", "rb")
    log digits
    rand_bytes = f\read(digits)
    f\close!
    hex = ""

    for i = 1, digits
        hex = hex .. string.format("%02x", string.byte(rand_bytes, i))
    hex
{
    :hrt
}