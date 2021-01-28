#!/usr/local/opt/ruby/bin/ruby
print "Running unit tests...\n"
buildOut = `xcodebuild test -scheme Strux-Package -enableCodeCoverage YES -derivedDataPath .build/derivedData 2>&1`
buildMatch = buildOut.match(/Test session results, code coverage, and logs:\s+(?<file>\S+)\s+.*TEST SUCCEEDED/)
if !!!buildMatch
    print "Test failed!\n"
    exit 1
end
resultFile = buildMatch[:file]

covOut = `xcrun xccov view --report #{resultFile} 2>&1`
covMatch = covOut.match(/Strux.framework\s+(?<coverage>\d+\.\d+)%/)
if !!!covMatch
    print "Failed to parse test results!\n"
    exit 1
end
pct = covMatch[:coverage]
cmd = "curl \"https://img.shields.io/badge/test coverage-#{pct}%25-brightgreen\" > badge.svg 2>/dev/null"
system cmd
