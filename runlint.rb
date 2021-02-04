#!/usr/local/opt/ruby/bin/ruby

# Assumes working directory is project root

print "Linting...\n"
Dir.chdir "Sources"
lout = `swiftlint 2>&1`
print lout, "\n"
loutMatch = lout.match("Found 0 violations, 0 serious")
if !!!loutMatch
    print "1 or more lint violations:"
    print lout
    print "exit with error 😞\n"
    exit 1
end
print "lint success 🤠 YEEE HAW!\n"
