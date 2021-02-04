#!/usr/local/opt/ruby/bin/ruby

# Assumes working directory is project root

#jazzy --swift-build-tool spm
print "Generating documentation...\n"
if !system "jazzy -x -workspace,Strux.xcworkspace,-scheme,Strux"
    print "doc exit with error 😞\n"
    exit 1
end

badge_file = "docs/docsets/Strux.docset/Contents/Resources/Documents/badge.svg"
badge_url = "gs://scipioapps/mystrux/doccov.svg"

system "gsutil rm #{badge_url}"
if !system "gsutil -h \"Cache-Control: no-cache\" cp #{badge_file} #{badge_url}"
    print "doc exit - couldn't write the badge file 😞\n"
    exit 1
end
if !system "gsutil acl ch -u AllUsers:R #{badge_url}"
    print "doc exit - couldn't set acl for doccov.svg 😞\n"
    exit 1
end
if !system "git add ."
    print "doc exit - 'git add .' failed 😞\n"
    exit 1
end

print "doc success 🤠 YEEE HAW!\n\n"
