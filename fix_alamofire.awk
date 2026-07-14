BEGIN {
    build_file_id = "AC8906F73006C34900893897"
    in_frameworks = 0
    in_pkgdeps = 0
    inserted_buildfile = 0
    inserted_frameworks = 0
    inserted_pkgdeps = 0
}
{
    line = $0

    if (!inserted_buildfile && line ~ /\/\* Begin PBXFileReference section \*\//) {
        print "/* Begin PBXBuildFile section */"
        print "\t\t" build_file_id " /* Alamofire in Frameworks */ = {isa = PBXBuildFile; productRef = AC8906F43006C34900893896 /* Alamofire */; };"
        print "/* End PBXBuildFile section */"
        print ""
        inserted_buildfile = 1
    }

    if (line ~ /AC15474B2F16A0A300962CDB \/\* Frameworks \*\//) {
        in_frameworks = 1
    }

    if (in_frameworks && line ~ /files = \(/ && !inserted_frameworks) {
        print line
        getline nextline
        if (nextline ~ /\);/) {
            print "\t\t\t\t" build_file_id " /* Alamofire in Frameworks */,"
        }
        print nextline
        inserted_frameworks = 1
        in_frameworks = 0
        next
    }

    if (line ~ /name = GithubClient;/) {
        in_pkgdeps = 1
    }
    if (in_pkgdeps && line ~ /packageProductDependencies = \(/ && !inserted_pkgdeps) {
        print line
        getline nextline
        if (nextline ~ /\);/) {
            print "\t\t\t\tAC8906F43006C34900893896 /* Alamofire */,"
        }
        print nextline
        inserted_pkgdeps = 1
        in_pkgdeps = 0
        next
    }

    print line
}
