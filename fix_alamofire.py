import re

path = "GithubClient.xcodeproj/project.pbxproj"
with open(path, "r") as f:
    content = f.read()

original = content

# 1. Insertar sección PBXBuildFile (si no existe ya)
build_file_id = "AC8906F73006C34900893897"
if "Begin PBXBuildFile section" not in content:
    build_file_block = (
        "/* Begin PBXBuildFile section */\n"
        f"\t\t{build_file_id} /* Alamofire in Frameworks */ = {{isa = PBXBuildFile; productRef = AC8906F43006C34900893896 /* Alamofire */; }};\n"
        "/* End PBXBuildFile section */\n\n"
    )
    marker = "/* Begin PBXFileReference section */"
    assert content.count(marker) == 1, "No se encontró el marcador esperado (PBXFileReference)"
    content = content.replace(marker, build_file_block + marker)
    print("✅ Sección PBXBuildFile insertada")
else:
    print("ℹ️ Ya existía una sección PBXBuildFile, no se tocó")

# 2. Agregar el build file a la fase Frameworks
frameworks_old = (
    "AC15474B2F16A0A300962CDB /* Frameworks */ = {\n"
    "\t\t\tisa = PBXFrameworksBuildPhase;\n"
    "\t\t\tbuildActionMask = 2147483647;\n"
    "\t\t\tfiles = (\n"
    "\t\t\t);\n"
)
frameworks_new = (
    "AC15474B2F16A0A300962CDB /* Frameworks */ = {\n"
    "\t\t\tisa = PBXFrameworksBuildPhase;\n"
    "\t\t\tbuildActionMask = 2147483647;\n"
    "\t\t\tfiles = (\n"
    f"\t\t\t\t{build_file_id} /* Alamofire in Frameworks */,\n"
    "\t\t\t);\n"
)
if frameworks_old in content:
    content = content.replace(frameworks_old, frameworks_new)
    print("✅ Alamofire agregado a la fase Frameworks")
elif build_file_id in content and "Alamofire in Frameworks" in content:
    print("ℹ️ La fase Frameworks ya tenía a Alamofire, no se tocó")
else:
    raise SystemExit("❌ No se encontró el bloque esperado de PBXFrameworksBuildPhase. Avisa antes de continuar.")

# 3. Agregar Alamofire a packageProductDependencies del target
deps_old = (
    "\t\t\tname = GithubClient;\n"
    "\t\t\tpackageProductDependencies = (\n"
    "\t\t\t);\n"
)
deps_new = (
    "\t\t\tname = GithubClient;\n"
    "\t\t\tpackageProductDependencies = (\n"
    "\t\t\t\tAC8906F43006C34900893896 /* Alamofire */,\n"
    "\t\t\t);\n"
)
if deps_old in content:
    content = content.replace(deps_old, deps_new)
    print("✅ Alamofire agregado a packageProductDependencies del target")
elif "AC8906F43006C34900893896 /* Alamofire */,\n\t\t\t);" in content:
    print("ℹ️ El target ya tenía a Alamofire en packageProductDependencies, no se tocó")
else:
    raise SystemExit("❌ No se encontró el bloque esperado de packageProductDependencies. Avisa antes de continuar.")

if content != original:
    with open(path, "w") as f:
        f.write(content)
    print("\n🎉 Listo, project.pbxproj actualizado correctamente.")
else:
    print("\n⚠️ No se hizo ningún cambio (todo ya estaba en su lugar).")
