(local f vim.fn)
(local SEC-DIGITS 9)
(local MILLI-DIGITS 3)
(local MICRO-DIGITS 3)
(local NANO-DIGITS 3)

(lambda get-word-under-cursor []
  (f.escape (f.expand "<cword>") "\\/"))

(lambda pad-string-to-int [s len]
  (if (> (string.len s) 0)
    (let [padded-string (.. s (string.rep "0" (- len (string.len s))))]
      (tonumber padded-string))
    0))

(lambda s-to-epoch [s]
  (let [secs (s:sub 1 SEC-DIGITS)
        millis (s:sub (+ SEC-DIGITS 1) (+ SEC-DIGITS MILLI-DIGITS))
        micros (s:sub (+ SEC-DIGITS MILLI-DIGITS 1) (+ SEC-DIGITS MILLI-DIGITS MICRO-DIGITS))
        nanos (s:sub (+ SEC-DIGITS MILLI-DIGITS MICRO-DIGITS 1) (+ SEC-DIGITS MILLI-DIGITS MICRO-DIGITS NANO-DIGITS))

        secs-number (tonumber secs)
        millis-number (pad-string-to-int millis MILLI-DIGITS)
        micros-number (pad-string-to-int micros MICRO-DIGITS)
        nanos-number (pad-string-to-int nanos NANO-DIGITS)
        datetime (os.date "*t" secs-number)]
    (print millis-number)
    (tset datetime :milli millis-number)
    (tset datetime :micro micros-number)
    (tset datetime :nano nanos-number)
    datetime))

(fn format-nano-datetime [datetime]
  (string.format
    "%04d-%02d-%02d %02d:%02d:%02d.%03d%03d%03d"
    (. datetime :year)
    (. datetime :month)
    (. datetime :day)
    (. datetime :hour)
    (. datetime :min)
    (. datetime :sec)
    (. datetime :milli)
    (. datetime :micro)
    (. datetime :nano)))

(fn print-datetime-under-cursor []
  (print
    (-> (get-word-under-cursor)
        (s-to-epoch)
        (format-nano-datetime))))

{:print_datetime_under_cursor print-datetime-under-cursor}
