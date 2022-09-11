local f = vim.fn
local SEC_DIGITS = 9
local MILLI_DIGITS = 3
local MICRO_DIGITS = 3
local NANO_DIGITS = 3
local function get_word_under_cursor()
  return f.escape(f.expand("<cword>"), "\\/")
end
local function pad_string_to_int(s, len)
  _G.assert((nil ~= len), "Missing argument len on fnl/epoch-converter.fnl:10")
  _G.assert((nil ~= s), "Missing argument s on fnl/epoch-converter.fnl:10")
  if (string.len(s) > 0) then
    local padded_string = (s .. string.rep("0", (len - string.len(s))))
    return tonumber(padded_string)
  else
    return 0
  end
end
local function s_to_epoch(s)
  _G.assert((nil ~= s), "Missing argument s on fnl/epoch-converter.fnl:16")
  local secs = s:sub(1, SEC_DIGITS)
  local millis = s:sub((SEC_DIGITS + 1), (SEC_DIGITS + MILLI_DIGITS))
  local micros = s:sub((SEC_DIGITS + MILLI_DIGITS + 1), (SEC_DIGITS + MILLI_DIGITS + MICRO_DIGITS))
  local nanos = s:sub((SEC_DIGITS + MILLI_DIGITS + MICRO_DIGITS + 1), (SEC_DIGITS + MILLI_DIGITS + MICRO_DIGITS + NANO_DIGITS))
  local secs_number = tonumber(secs)
  local millis_number = pad_string_to_int(millis, MILLI_DIGITS)
  local micros_number = pad_string_to_int(micros, MICRO_DIGITS)
  local nanos_number = pad_string_to_int(nanos, NANO_DIGITS)
  local datetime = os.date("*t", secs_number)
  print(millis_number)
  do end (datetime)["milli"] = millis_number
  datetime["micro"] = micros_number
  datetime["nano"] = nanos_number
  return datetime
end
local function format_nano_datetime(datetime)
  return string.format("%04d-%02d-%02d %02d:%02d:%02d.%03d%03d%03d", datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec, datetime.milli, datetime.micro, datetime.nano)
end
local function print_datetime_under_cursor()
  return vim.pretty_print(format_nano_datetime(s_to_epoch(get_word_under_cursor())))
end
return {print_datetime_under_cursor = print_datetime_under_cursor}
