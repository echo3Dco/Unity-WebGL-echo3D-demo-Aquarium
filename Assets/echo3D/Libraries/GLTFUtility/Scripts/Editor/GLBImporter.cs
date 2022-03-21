using UnityEngine;

#if UNITY_2019
using UnityEditor.Experimental.AssetImporters;
#endif

namespace Siccity.GLTFUtility {

#if UNITY_2019
	[ScriptedImporter(1, "glb")]
#else
	[UnityEditor.AssetImporters.ScriptedImporter(1, "glb")]
#endif
	public class GLBImporter : GLTFImporter {
#if UNITY_2019
		public override void OnImportAsset(AssetImportContext ctx) {
#else
		public override void OnImportAsset(UnityEditor.AssetImporters.AssetImportContext ctx) {
#endif
			// Load asset
			GLTFAnimation.ImportResult[] animations;
			GameObject root = Importer.LoadFromFile(ctx.assetPath, importSettings, out animations, Format.GLB);
			// Save asset
			GLTFAssetUtility.SaveToAsset(root, animations, ctx);
		}
	}
}