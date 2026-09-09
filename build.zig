const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_export = b.option(bool, "Build Export", "whether to build the export library") orelse false;
    const use_fbx = b.option(bool, "Use FBX", "whether to use the FBX importer") orelse true;
    const use_gltf = b.option(bool, "Use glTF", "whether to use the glTF importer") orelse false;

    const upstream = b.dependency("assimp", .{});

    const mod = b.addModule("assimp", .{
        .target = target,
        .optimize = optimize,
        .link_libcpp = target.result.abi != .msvc,
        .link_libc = true,
    });
    mod.addCMacro("OPENDDL_STATIC_LIBARY", "1");
    mod.addCMacro("RAPIDJSON_HAS_STDSTRING", "1");

    if (!build_export) {
        mod.addCMacro("ASSIMP_BUILD_NO_EXPORT", "1");
    }

    // Never build USD
    mod.addCMacro("ASSIMP_BUILD_NO_USD_EXPORTER", "1");
    mod.addCMacro("ASSIMP_BUILD_NO_USD_IMPORTER", "1");

    mod.addIncludePath(upstream.path("."));
    mod.addIncludePath(upstream.path("include"));
    mod.addIncludePath(upstream.path("code"));
    // mod.addIncludePath(upstream.path("code/AssetLib/USD"));
    mod.addIncludePath(upstream.path("contrib"));
    mod.addIncludePath(upstream.path("contrib/zlib"));
    mod.addIncludePath(upstream.path("contrib/unzip"));
    mod.addIncludePath(upstream.path("contrib/pugixml/src"));
    mod.addIncludePath(upstream.path("contrib/rapidjson/include"));
    mod.addIncludePath(upstream.path("contrib/utf8cpp/source"));
    mod.addIncludePath(upstream.path("contrib/openddlparser/include"));

    const zlib_config = b.addConfigHeader(.{
        .include_path = "zconf.h",
        .style = .{ .cmake = upstream.path("contrib/zlib/zconf.h.in") },
    }, .{});
    mod.addConfigHeader(zlib_config);

    const assimp_config = b.addConfigHeader(.{
        .include_path = "assimp/config.h",
        .style = .{ .cmake = upstream.path("include/assimp/config.h.in") },
    }, .{});
    mod.addConfigHeader(assimp_config);
    const assimp_revision = b.addConfigHeader(.{
        .include_path = "assimp/revision.h",
        .style = .{ .cmake = upstream.path("include/assimp/revision.h.in") },
    }, .{
        .GIT_COMMIT_HASH = "17ec36b",
        .GIT_BRANCH = "master",
        .ASSIMP_VERSION_MAJOR = 6,
        .ASSIMP_VERSION_MINOR = 0,
        .ASSIMP_VERSION_PATCH = 5,
        .ASSIMP_PACKAGE_VERSION = "6.0.5",
        .CMAKE_SHARED_LIBRARY_PREFIX = "",
        .LIBRARY_SUFFIX = "",
        .CMAKE_DEBUG_POSTFIX = "",
    });
    mod.addConfigHeader(assimp_revision);

    mod.addCSourceFiles(.{
        .root = upstream.path("code/Common"),
        .files = &common,
        .flags = &.{"-std=c++17"},
    });

    mod.addCSourceFiles(
        .{
            .root = upstream.path("code"),
            .files = &.{
                "CApi/AssimpCExport.cpp",
                "CApi/CInterfaceIOWrapper.cpp",
                "Geometry/GeometryUtils.cpp",
                "Material/MaterialSystem.cpp",
                "Pbrt/PbrtExporter.cpp",
                "PostProcessing/ArmaturePopulate.cpp",
                "PostProcessing/CalcTangentsProcess.cpp",
                "PostProcessing/ComputeUVMappingProcess.cpp",
                "PostProcessing/ConvertToLHProcess.cpp",
                "PostProcessing/DeboneProcess.cpp",
                "PostProcessing/DropFaceNormalsProcess.cpp",
                "PostProcessing/EmbedTexturesProcess.cpp",
                "PostProcessing/FindDegenerates.cpp",
                "PostProcessing/FindInstancesProcess.cpp",
                "PostProcessing/FindInvalidDataProcess.cpp",
                "PostProcessing/FixNormalsStep.cpp",
                "PostProcessing/GenBoundingBoxesProcess.cpp",
                "PostProcessing/GenFaceNormalsProcess.cpp",
                "PostProcessing/GenVertexNormalsProcess.cpp",
                "PostProcessing/ImproveCacheLocality.cpp",
                "PostProcessing/JoinVerticesProcess.cpp",
                "PostProcessing/LimitBoneWeightsProcess.cpp",
                "PostProcessing/MakeVerboseFormat.cpp",
                "PostProcessing/OptimizeGraph.cpp",
                "PostProcessing/OptimizeMeshes.cpp",
                "PostProcessing/PretransformVertices.cpp",
                "PostProcessing/ProcessHelper.cpp",
                "PostProcessing/RemoveRedundantMaterials.cpp",
                "PostProcessing/RemoveVCProcess.cpp",
                "PostProcessing/ScaleProcess.cpp",
                "PostProcessing/SortByPTypeProcess.cpp",
                "PostProcessing/SplitByBoneCountProcess.cpp",
                "PostProcessing/SplitLargeMeshes.cpp",
                "PostProcessing/TextureTransform.cpp",
                "PostProcessing/TriangulateProcess.cpp",
                "PostProcessing/ValidateDataStructure.cpp",
            },
            .flags = &.{
                "-std=c++17",
            },
        },
    );

    // FBX
    if (use_fbx) {
        mod.addCSourceFiles(.{
            .root = upstream.path("code/AssetLib/FBX"),
            .files = &formats.FBX,
            .flags = &.{"-std=c++17"},
        });
    } else {
        mod.addCMacro("ASSIMP_BUILD_NO_FBX_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_FBX_EXPORTER", "1");
    }

    // glTF
    if (use_gltf) {
        mod.addCSourceFiles(.{
            .root = upstream.path("code/AssetLib/glTFCommon"),
            .files = &formats.GLTF_COMMON,
            .flags = &.{"-std=c++17"},
        });
        mod.addCSourceFiles(.{
            .root = upstream.path("code/AssetLib/glTF"),
            .files = &formats.GLTF,
            .flags = &.{"-std=c++17"},
        });
        mod.addCSourceFiles(.{
            .root = upstream.path("code/AssetLib/glTF2"),
            .files = &formats.GLTF2,
            .flags = &.{"-std=c++17"},
        });
    } else {
        mod.addCMacro("ASSIMP_BUILD_NO_GLTF_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_GLTF_EXPORTER", "1");
    }

    inline for (comptime std.meta.declarations(libraries)) |ext_lib| {
        mod.addCSourceFiles(.{
            .root = upstream.path(""),
            .files = &@field(libraries, ext_lib.name),
        });
    }

    const lib = b.addLibrary(.{
        .name = "assimp",
        .root_module = mod,
        .linkage = .static,
    });
    b.installArtifact(lib);

    lib.installConfigHeader(zlib_config);
    lib.installConfigHeader(assimp_config);
    lib.installConfigHeader(assimp_revision);
    lib.installHeadersDirectory(upstream.path("include"), "", .{
        .include_extensions = &.{ ".h", ".inl", ".hpp" },
    });
}

const common = [_][]const u8{
    "AssertHandler.cpp",
    "Assimp.cpp",
    "Base64.cpp",
    "BaseImporter.cpp",
    "BaseProcess.cpp",
    "Bitmap.cpp",
    "Compression.cpp",
    "CreateAnimMesh.cpp",
    "DefaultIOStream.cpp",
    "DefaultIOSystem.cpp",
    "DefaultLogger.cpp",
    "Exceptional.cpp",
    "Exporter.cpp",
    "IOSystem.cpp",
    "Importer.cpp",
    "ImporterRegistry.cpp",
    "PostStepRegistry.cpp",
    "RemoveComments.cpp",
    "SGSpatialSort.cpp",
    "SceneCombiner.cpp",
    "ScenePreprocessor.cpp",
    "SkeletonMeshBuilder.cpp",
    "SpatialSort.cpp",
    "StandardShapes.cpp",
    "Subdivision.cpp",
    "TargetAnimation.cpp",
    "Version.cpp",
    "VertexTriangleAdjacency.cpp",
    "ZipArchiveIOSystem.cpp",
    "material.cpp",
    "scene.cpp",
    "simd.cpp",
};

const formats = struct {
    // pub const @"3DS" = [_][]const u8{
    //     "3DSConverter.cpp",
    //     "3DSExporter.cpp",
    //     "3DSLoader.cpp",
    // };
    pub const @"3MF" = [_][]const u8{
        "D3MFExporter.cpp",
        "D3MFImporter.cpp",
        "D3MFOpcPackage.cpp",
        "XmlSerializer.cpp",
    };
    pub const AC = [_][]const u8{
        "ACLoader.cpp",
    };
    pub const AMF = [_][]const u8{
        "AMFImporter.cpp",
        "AMFImporter_Geometry.cpp",
        "AMFImporter_Material.cpp",
        "AMFImporter_Postprocess.cpp",
    };
    pub const ASE = [_][]const u8{
        "ASELoader.cpp",
        "ASEParser.cpp",
    };
    pub const ASSBIN = [_][]const u8{
        "AssbinExporter.cpp",
        "AssbinFileWriter.cpp",
        "AssbinLoader.cpp",
    };
    pub const ASSJSON = [_][]const u8{
        "cencode.c",
        "json_exporter.cpp",
        "mesh_splitter.cpp",
    };
    pub const ASSXML = [_][]const u8{
        "AssxmlExporter.cpp",
        "AssxmlFileWriter.cpp",
    };
    pub const B3D = [_][]const u8{
        "B3DImporter.cpp",
    };
    pub const BVH = [_][]const u8{
        "BVHLoader.cpp",
    };
    pub const BLENDER = [_][]const u8{
        "BlenderBMesh.cpp",
        "BlenderCustomData.cpp",
        "BlenderDNA.cpp",
        "BlenderLoader.cpp",
        "BlenderModifier.cpp",
        "BlenderScene.cpp",
        "BlenderTessellator.cpp",
    };
    pub const C4D = [_][]const u8{
        "C4DImporter.cpp",
    };
    pub const COB = [_][]const u8{
        "COBLoader.cpp",
    };
    pub const CSM = [_][]const u8{
        "CSMLoader.cpp",
    };
    pub const COLLADA = [_][]const u8{
        "ColladaExporter.cpp",
        "ColladaHelper.cpp",
        "ColladaLoader.cpp",
        "ColladaParser.cpp",
    };
    pub const DXF = [_][]const u8{
        "DXFLoader.cpp",
    };
    pub const FBX = [_][]const u8{
        "FBXAnimation.cpp",
        "FBXBinaryTokenizer.cpp",
        "FBXConverter.cpp",
        "FBXDeformer.cpp",
        "FBXDocument.cpp",
        "FBXDocumentUtil.cpp",
        "FBXExportNode.cpp",
        "FBXExportProperty.cpp",
        "FBXExporter.cpp",
        "FBXImporter.cpp",
        "FBXMaterial.cpp",
        "FBXMeshGeometry.cpp",
        "FBXModel.cpp",
        "FBXNodeAttribute.cpp",
        "FBXParser.cpp",
        "FBXProperties.cpp",
        "FBXTokenizer.cpp",
        "FBXUtil.cpp",
    };
    pub const HMP = [_][]const u8{
        "HMPLoader.cpp",
    };
    pub const IFC = [_][]const u8{
        "IFCBoolean.cpp",
        "IFCCurve.cpp",
        "IFCGeometry.cpp",
        "IFCLoader.cpp",
        "IFCMaterial.cpp",
        "IFCOpenings.cpp",
        "IFCProfile.cpp",
        "IFCReaderGen1_2x3.cpp",
        "IFCReaderGen2_2x3.cpp",
        "IFCReaderGen_4.cpp",
        "IFCUtil.cpp",
    };
    pub const IQM = [_][]const u8{
        "IQMImporter.cpp",
    };
    pub const IRR = [_][]const u8{
        "IRRLoader.cpp",
        "IRRMeshLoader.cpp",
        "IRRShared.cpp",
    };
    pub const LWO = [_][]const u8{
        "LWOAnimation.cpp",
        "LWOBLoader.cpp",
        "LWOLoader.cpp",
        "LWOMaterial.cpp",
    };
    pub const LWS = [_][]const u8{
        "LWSLoader.cpp",
    };
    pub const M3D = [_][]const u8{
        "M3DExporter.cpp",
        "M3DImporter.cpp",
        "M3DWrapper.cpp",
    };
    pub const MD2 = [_][]const u8{
        "MD2Loader.cpp",
    };
    pub const MD3 = [_][]const u8{
        "MD3Loader.cpp",
    };
    pub const MD5 = [_][]const u8{
        "MD5Loader.cpp",
        "MD5Parser.cpp",
    };
    pub const MDC = [_][]const u8{
        "MDCLoader.cpp",
    };
    pub const MDL = [_][]const u8{
        "MDLLoader.cpp",
        "MDLMaterialLoader.cpp",
        "HalfLife/HL1MDLLoader.cpp",
        "HalfLife/UniqueNameGenerator.cpp",
    };
    pub const MMD = [_][]const u8{
        "MMDImporter.cpp",
        "MMDPmxParser.cpp",
    };
    pub const MS3D = [_][]const u8{
        "MS3DLoader.cpp",
    };
    pub const NDO = [_][]const u8{
        "NDOLoader.cpp",
    };
    pub const NFF = [_][]const u8{
        "NFFLoader.cpp",
    };
    pub const OFF = [_][]const u8{
        "OFFLoader.cpp",
    };
    pub const OBJ = [_][]const u8{
        "ObjExporter.cpp",
        "ObjFileImporter.cpp",
        "ObjFileMtlImporter.cpp",
        "ObjFileParser.cpp",
    };
    pub const OGRE = [_][]const u8{
        "OgreBinarySerializer.cpp",
        "OgreImporter.cpp",
        "OgreMaterial.cpp",
        "OgreStructs.cpp",
        "OgreXmlSerializer.cpp",
    };
    pub const OPENGEX = [_][]const u8{
        "OpenGEXExporter.cpp",
        "OpenGEXImporter.cpp",
    };
    pub const PLY = [_][]const u8{
        "PlyExporter.cpp",
        "PlyLoader.cpp",
        "PlyParser.cpp",
    };
    pub const Q3BSP = [_][]const u8{
        "Q3BSPFileImporter.cpp",
        "Q3BSPFileParser.cpp",
    };
    pub const Q3D = [_][]const u8{
        "Q3DLoader.cpp",
    };
    pub const RAW = [_][]const u8{
        "RawLoader.cpp",
    };
    pub const SIB = [_][]const u8{
        "SIBImporter.cpp",
    };
    pub const SMD = [_][]const u8{
        "SMDLoader.cpp",
    };
    pub const STEP_PARSER = [_][]const u8{
        "STEPFileEncoding.cpp",
        "STEPFileReader.cpp",
    };
    pub const STL = [_][]const u8{
        "STLExporter.cpp",
        "STLLoader.cpp",
    };
    pub const STEP = [_][]const u8{
        "StepExporter.cpp",
    };
    pub const TERRAGEN = [_][]const u8{
        "TerragenLoader.cpp",
    };
    pub const USD = [_][]const u8{
        "USDLoader.cpp",
        "USDLoaderImplTinyusdz.cpp",
        "USDLoaderImplTinyusdzHelper.cpp",
        "USDLoaderUtil.cpp",
    };
    pub const UNREAL = [_][]const u8{
        "UnrealLoader.cpp",
    };
    pub const VRML = [_][]const u8{
        "VrmlConverter.cpp",
    };
    pub const X = [_][]const u8{
        "XFileExporter.cpp",
        "XFileImporter.cpp",
        "XFileParser.cpp",
    };
    pub const X3D = [_][]const u8{
        "X3DExporter.cpp",
        "X3DGeoHelper.cpp",
        "X3DImporter.cpp",
        "X3DImporter_Geometry2D.cpp",
        "X3DImporter_Geometry3D.cpp",
        "X3DImporter_Group.cpp",
        "X3DImporter_Light.cpp",
        "X3DImporter_Metadata.cpp",
        "X3DImporter_Networking.cpp",
        "X3DImporter_Postprocess.cpp",
        "X3DImporter_Rendering.cpp",
        "X3DImporter_Shape.cpp",
        "X3DImporter_Texturing.cpp",
        "X3DXmlHelper.cpp",
    };
    pub const XGL = [_][]const u8{
        "XGLLoader.cpp",
    };
    pub const GLTF = [_][]const u8{
        "glTFExporter.cpp",
        "glTFImporter.cpp",
    };
    pub const GLTF2 = [_][]const u8{
        "glTF2Exporter.cpp",
        "glTF2Importer.cpp",
    };
    pub const GLTF_COMMON = [_][]const u8{
        "glTFCommon.cpp",
    };
};

const libraries = struct {
    pub const unzip = [_][]const u8{
        "contrib/unzip/unzip.c",
        "contrib/unzip/ioapi.c",
        // "contrib/unzip/crypt.c",
    };
    pub const zip = [_][]const u8{
        "contrib/zip/src/zip.c",
    };
    pub const zlib = [_][]const u8{
        "contrib/zlib/inflate.c",
        "contrib/zlib/infback.c",
        "contrib/zlib/gzclose.c",
        "contrib/zlib/gzread.c",
        "contrib/zlib/inftrees.c",
        "contrib/zlib/gzwrite.c",
        "contrib/zlib/compress.c",
        "contrib/zlib/inffast.c",
        "contrib/zlib/uncompr.c",
        "contrib/zlib/gzlib.c",
        "contrib/zlib/trees.c",
        "contrib/zlib/zutil.c",
        "contrib/zlib/deflate.c",
        "contrib/zlib/crc32.c",
        "contrib/zlib/adler32.c",
    };
    pub const poly2tri = [_][]const u8{
        "contrib/poly2tri/poly2tri/common/shapes.cc",
        "contrib/poly2tri/poly2tri/sweep/sweep_context.cc",
        "contrib/poly2tri/poly2tri/sweep/advancing_front.cc",
        "contrib/poly2tri/poly2tri/sweep/cdt.cc",
        "contrib/poly2tri/poly2tri/sweep/sweep.cc",
    };
    pub const clipper = [_][]const u8{
        "contrib/clipper/clipper.cpp",
    };
    pub const openddlparser = [_][]const u8{
        "contrib/openddlparser/code/OpenDDLParser.cpp",
        "contrib/openddlparser/code/OpenDDLExport.cpp",
        "contrib/openddlparser/code/DDLNode.cpp",
        "contrib/openddlparser/code/OpenDDLCommon.cpp",
        "contrib/openddlparser/code/Value.cpp",
        "contrib/openddlparser/code/OpenDDLStream.cpp",
    };
};
