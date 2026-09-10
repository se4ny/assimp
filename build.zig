const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_export = b.option(bool, "Build Export", "whether to build the export library") orelse false;
    const use_fbx = b.option(bool, "use_fbx", "whether to use the FBX importer") orelse false;
    const use_gltf = b.option(bool, "use_gltf", "whether to use the glTF importer") orelse false;
    const use_3mf = b.option(bool, "use_3mf", "whether to use the 3MF importer") orelse false;
    const use_ac = b.option(bool, "use_ac", "whether to use the AC importer") orelse false;
    const use_amf = b.option(bool, "use_amf", "whether to use the AMF importer") orelse false;
    const use_ase = b.option(bool, "use_amf", "whether to use the ASE importer") orelse false;
    const use_assbin = b.option(bool, "use_assbin", "whether to use the Assbin importer") orelse false;
    const use_assjson = b.option(bool, "use_assjson", "whether to use the Assjson importer") orelse false;
    const use_assxml = b.option(bool, "use_assxml", "whether to use the Assxml importer") orelse false;
    const use_b3d = b.option(bool, "use_b3d", "whether to use the B3D importer") orelse false;
    const use_bvh = b.option(bool, "use_bvh", "whether to use the BVH importer") orelse false;
    const use_blender = b.option(bool, "use_blender", "whether to use the Blender importer") orelse false;
    const use_c4d = b.option(bool, "use_c4d", "whether to use the C4D importer") orelse false;
    const use_cob = b.option(bool, "use_cob", "whether to use the COB importer") orelse false;
    const use_csm = b.option(bool, "use_csm", "whether to use the CSM importer") orelse false;
    const use_collada = b.option(bool, "use_collada", "whether to use the Collada importer") orelse false;
    const use_dxf = b.option(bool, "use_dxf", "whether to use the DXF importer") orelse false;
    const use_hmp = b.option(bool, "use_hmp", "whether to use the HMP importer") orelse false;
    const use_ifc = b.option(bool, "use_ifc", "whether to use the IFC importer") orelse false;
    const use_iqm = b.option(bool, "use_iqm", "whether to use the IQM importer") orelse false;
    const use_irr = b.option(bool, "use_irr", "whether to use the IRR importer") orelse false;
    const use_lwo = b.option(bool, "use_lwo", "whether to use the LWO importer") orelse false;
    const use_lws = b.option(bool, "use_lws", "whether to use the LWS importer") orelse false;
    const use_m3d = b.option(bool, "use_m3d", "whether to use the M3D importer") orelse false;
    const use_md2 = b.option(bool, "use_md2", "whether to use the MD2 importer") orelse false;
    const use_md3 = b.option(bool, "use_md3", "whether to use the MD3 importer") orelse false;
    const use_md5 = b.option(bool, "use_md3", "whether to use the MD5 importer") orelse false;
    const use_mdc = b.option(bool, "use_mdc", "whether to use the MDC importer") orelse false;
    const use_mdl = b.option(bool, "use_mdl", "whether to use the MDL importer") orelse false;
    const use_mmd = b.option(bool, "use_mmd", "whether to use the MMD importer") orelse false;
    const use_ms3d = b.option(bool, "use_ms3d", "whether to use the MS3D importer") orelse false;
    const use_ndo = b.option(bool, "use_ndo", "whether to use the NDO importer") orelse false;
    const use_nff = b.option(bool, "use_nff", "whether to use the NFF importer") orelse false;
    const use_off = b.option(bool, "use_off", "whether to use the OFF importer") orelse false;
    const use_obj = b.option(bool, "use_obj", "whether to use the OBJ importer") orelse false;
    const use_ogre = b.option(bool, "use_ogre", "whether to use the Ogre importer") orelse false;
    const use_opengex = b.option(bool, "use_opengex", "whether to use the OpenGEX importer") orelse false;
    const use_ply = b.option(bool, "use_ply", "whether to use the PLY importer") orelse false;
    const use_q3bsp = b.option(bool, "use_q3bsp", "whether to use the Q3BSP importer") orelse false;
    const use_q3d = b.option(bool, "use_q3d", "whether to use the Q3D importer") orelse false;
    const use_raw = b.option(bool, "use_raw", "whether to use the RAW importer") orelse false;
    const use_sib = b.option(bool, "use_sib", "whether to use the SIB importer") orelse false;
    const use_smd = b.option(bool, "use_smd", "whether to use the SMD importer") orelse false;
    const use_stl = b.option(bool, "use_stl", "whether to use the STL importer") orelse false;
    const use_step = b.option(bool, "use_step", "whether to use the STEP importer") orelse false;
    const use_terragen = b.option(bool, "use_terragen", "whether to use the Terragen importer") orelse false;
    const use_vrml = b.option(bool, "use_vrml", "whether to use the VRML importer") orelse false;
    const use_x = b.option(bool, "use_x", "whether to use the X importer") orelse false;
    const use_x3d = b.option(bool, "use_x3d", "whether to use the X3D importer") orelse false;
    const use_xgl = b.option(bool, "use_xgl", "whether to use the XGL importer") orelse false;

    const upstream = b.dependencby("assimp", .{});

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

    if (use_vrml) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_VRML_IMPORTER", "1");
    }
    if (use_terragen) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_TERRAGEN_IMPORTER", "1");
    }
    if (use_stl) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_STL_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_STL_EXPORTER", "1");
    }
    if (use_step) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_STEP_IMPORTER", "1");
    }
    if (use_q3d) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_Q3D_IMPORTER", "1");
    }
    if (use_q3bsp) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_Q3BSP_IMPORTER", "1");
    }
    if (use_off) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_OFF_IMPORTER", "1");
    }
    if (use_nff) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_NFF_IMPORTER", "1");
    }
    if (use_ndo) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_NDO_IMPORTER", "1");
    }
    if (use_mmd) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MMD_IMPORTER", "1");
    }
    if (use_md3) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MD3_IMPORTER", "1");
    }
    if (use_lws) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_LWS_IMPORTER", "1");
    }
    if (use_dxf) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_DXF_IMPORTER", "1");
    }
    if (use_c4d) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_C4D_IMPORTER", "1");
    }
    if (use_assjson) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_ASSJSON_EXPORTER", "1");
    }
    if (use_csm) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_CSM_IMPORTER", "1");
    }
    if (use_smd) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_SMD_IMPORTER", "1");
    }
    if (use_assxml) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_ASSXML_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_ASSXML_EXPORTER", "1");
    }
    if (use_opengex) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_OPENGEX_IMPORTER", "1");
    }
    if (use_collada) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_COLLADA_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_COLLADA_EXPORTER", "1");
    }
    if (use_obj) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_OBJ_IMPORTER", "1");
    }
    if (use_mdl) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MDL_IMPORTER", "1");
    }
    if (use_ms3d) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MS3D_IMPORTER", "1");
    }
    if (use_sib) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_SIB_IMPORTER", "1");
    }
    if (use_cob) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_COB_IMPORTER", "1");
    }
    if (use_ase) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_ASE_IMPORTER", "1");
    }
    if (use_lwo) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_LWO_IMPORTER", "1");
    }
    if (use_md5) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MD5_IMPORTER", "1");
    }
    if (use_b3d) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_B3D_IMPORTER", "1");
    }
    if (use_ac) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_AC_IMPORTER", "1");
    }
    if (use_mdc) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MDC_IMPORTER", "1");
    }
    if (use_bvh) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_BVH_IMPORTER", "1");
    }
    if (use_hmp) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_HMP_IMPORTER", "1");
    }
    if (use_md2) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_MD2_IMPORTER", "1");
    }
    if (use_lwo) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_LWO_IMPORTER", "1");
    }
    if (use_xgl) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_XGL_IMPORTER", "1");
    }
    if (use_raw) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_RAW_IMPORTER", "1");
    }
    if (use_ply) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_PLY_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_PLY_EXPORTER", "1");
    }
    if (use_irr) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_IRR_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_IRRMESH_IMPORTER", "1");
    }
    if (use_blender) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_BLENDER_IMPORTER", "1");
    }
    if (use_x3d) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_X3D_IMPORTER", "1");
    }
    if (use_assbin) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_ASSBIN_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_ASSBIN_EXPORTER", "1");
    }
    if (use_3mf) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_3MF_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_3MF_EXPORTER", "1");
    }
    if (use_ogre) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_OGRE_IMPORTER", "1");
    }
    if (use_amf) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_AMF_IMPORTER", "1");
    }
    if (use_ifc) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_IFC_IMPORTER", "1");
    }
    if (use_iqm) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_IQM_IMPORTER", "1");
    }
    if (use_m3d) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_M3D_IMPORTER", "1");
        mod.addCMacro("ASSIMP_BUILD_NO_M3D_EXPORTER", "1");
    }
    if (use_x) {} else {
        mod.addCMacro("ASSIMP_BUILD_NO_X_IMPORTER", "1");
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
