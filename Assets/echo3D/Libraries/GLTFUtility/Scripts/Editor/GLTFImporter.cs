
using UnityEngine;

#if UNITY_2019
using UnityEditor.Experimental.AssetImporters;
#endif

namespace Siccity.GLTFUtility {
#if UNITY_2019
	[ScriptedImporter(1, "gltf")]
#else
	[UnityEditor.AssetImporters.ScriptedImporter(1, "gltf")]
#endif
#if UNITY_2019
	public class GLTFImporter : ScriptedImporter {
#else
	public class GLTFImporter : UnityEditor.AssetImporters.ScriptedImporter {
#endif
	
		public ImportSettings importSettings;
#if UNITY_2019
		public override void OnImportAsset(AssetImportContext ctx) {
#else
		public override void OnImportAsset(UnityEditor.AssetImporters.AssetImportContext ctx) {
#endif
			// Load asset
			GLTFAnimation.ImportResult[] animations;
			GameObject root = Importer.LoadFromFile(ctx.assetPath, importSettings, out animations, Format.GLTF);
			// Save asset
			GLTFAssetUtility.SaveToAsset(root, animations, ctx);
		}
	}
}