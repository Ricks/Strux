#!/usr/local/opt/ruby/bin/ruby

#jazzy --swift-build-tool spm
print "Generating documentation...\n"
if !system "jazzy -x -workspace,Strux.xcworkspace,-scheme,Strux"
    exit 1
end

badge_file = "docs/docsets/Strux.docset/Contents/Resources/Documents/badge.svg"
badge_url = "gs://scipioapps/mystrux/doccov.svg"

system "gsutil rm #{badge_url}"
system "gsutil -h \"Cache-Control: no-cache\" cp #{badge_file} #{badge_url}"
system "gsutil acl ch -u AllUsers:R #{badge_url}"
