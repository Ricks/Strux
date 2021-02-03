#!/usr/local/opt/ruby/bin/ruby

# Run the unit tests

print "Running unit tests...\n"
buildOut = `xcodebuild test -scheme Strux-Package -enableCodeCoverage YES -derivedDataPath .build/derivedData`
buildMatch = buildOut.match(/Test session results, code coverage, and logs:\s+(?<file>\S+)\s+.*TEST SUCCEEDED/)
if !!!buildMatch
    print "Test failed!\n"
    exit 1
end

result_file = buildMatch[:file]
text_file = "/tmp/codecov.html"
badge_file = "/tmp/codecov.svg"

# Generate the coverage report

#system "xcrun xccov view --report #{result_file} > #{text_file}"
#covOut = File.read(text_file)

pre_body = <<-PRE_BODY
<!DOCTYPE html>
<html>
<head>
<style>
body {
/*  width: max-content; */
  text-align: center;
  background-color: linen;
}
</style>
</head>
<body>
<pre>
PRE_BODY

post_body = <<-POST_BODY

</pre>
</body>
</html>
POST_BODY

covOut = `xcrun xccov view --report #{result_file}`
covMatch = covOut.match(/(^.*\n.*\n)([\S\s]*)/)
firstTwoLines = covMatch[1]
remaining = covMatch[2]
targets = remaining.split(/\n(?=\S)/)
pct = ""
targets.each do | target |
    targetMatch = target.match(/^(?<name>\S+)\s+(?<coverage>\d+\.\d+)%/)
    if !!!targetMatch
        print "Unable to parse coverage output!\n"
        exit 1
    end
    targetName = targetMatch[:name]
    if targetName == "Strux.framework"
        pct = targetMatch[:coverage]
        covFinal = "#{pre_body}#{firstTwoLines}#{target}#{post_body}"
        File.write(text_file, covFinal)
        break
    end
end
if pct == ""
    print "Unable to parse coverage output!\n"
    exit 1
end

# Get the badge color

pctFloat = pct.to_f
color = "red"
if pctFloat >= 95
    color = "brightgreen"
elsif pctFloat >= 90
    color = "green"
elsif pctFloat >= 80
    color = "yellowgreen"
elsif pctFloat >= 70
    color = "yellow"
elsif pctFloat >= 60
    color = "orange"
end

system "curl \"https://img.shields.io/badge/coverage-#{pct}%25-#{color}\" > #{badge_file}"
system "gsutil rm gs://scipioapps/mystrux/codecov.html"
system "gsutil rm gs://scipioapps/mystrux/codecov.svg"
system "gsutil -h \"Cache-Control: no-cache\" cp #{text_file} gs://scipioapps/mystrux/codecov.html"
system "gsutil -h \"Cache-Control: no-cache\" cp #{badge_file} gs://scipioapps/mystrux/codecov.svg"
system "gsutil acl ch -u AllUsers:R gs://scipioapps/mystrux/codecov.html"
system "gsutil acl ch -u AllUsers:R gs://scipioapps/mystrux/codecov.svg"
