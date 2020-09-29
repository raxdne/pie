#
# (p) 2017 A. Tenbusch
#

# https://www.rosettacode.org/wiki/URL_encoding#Tcl
# Encode all except "unreserved" characters; use UTF-8 for extended chars.
# See http://tools.ietf.org/html/rfc3986 §2.4 and §2.5
proc urlEncode {str} {
    set uStr [encoding convertto utf-8 $str]
    set chRE {[^-A-Za-z0-9._~\n]};		# Newline is special case!
    set replacement {%[format "%02X" [scan "\\\0" "%c"]]}
    return [string map {"\n" "%0A"} [subst [regsub -all $chRE $uStr $replacement]]]
}


set strPrefix "C:/UserData/Work/Documents/"
set strURL "http://127.0.0.1:8186/cxproc/exe?cxp=PiejQDefault&path="

if {[llength $argv] < 1} {
    puts "no argv"
} elseif {[string length [lindex $argv 0]] < 1} {
    puts "no argv 1"
} elseif {[string match "$strPrefix*" [file normalize [lindex $argv 0]]]} {
    regsub -nocase $strPrefix [file normalize [lindex $argv 0]] {} strFileUrl
    set strURLNew "$strURL[urlEncode $strFileUrl]"
    puts "OK \"$strURLNew\""
    catch {exec "iexplore.exe" "$strURLNew" & }
} else {
    puts "??? [file normalize [lindex $argv 0]]"
}
