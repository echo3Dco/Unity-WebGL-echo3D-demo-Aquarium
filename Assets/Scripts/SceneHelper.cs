using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/* 
This script is used to make adjustments to loaded holograms pre and post load.
It determines the appropriate adjustments based on the gameobject name. 
*/

[RequireComponent(typeof(Echo3DHologram))]
public class SceneHelper : MonoBehaviour
{
    public bool onLoadAdjustment = false;
    private Echo3DHologram hologram;

    public Material ArchRockMaterial;
    public Material SmallSoftCoralMaterial;
    public Material LargeSoftCoralMaterial;
    public Material BulbousCoralMaterial;
    public Material CoralBunchMaterial;
    public Material LargeShelfCoral2Material;
    public Material LargeShelfCoral4Material;
    public Material BlobbyCoralMaterial;

    void Awake()
    {
        hologram = GetComponent<Echo3DHologram>();
        if (hologram == null)
        {
            Debug.LogError("No Echo3DHologram exists on this gameobject. Scenehelper will not help!");
            return;
        }
        SetApiAndSecurityKeys(hologram);
        SetEntry(hologram);
    }


    private void SetApiAndSecurityKeys(Echo3DHologram hologram)
    {
        switch (gameObject.name)
        {
            case "ArchRock":
            case "SmallSoftCoral":
            case "LargeSoftCoral":
            case "BulbousCoral":
            case "CoralBunch1":
            case "CoralBunch3":
            case "LargeShelfCoral2":
            case "LargeShelfCoral4":
            case "BlobbyCoral":
            case "Coral3":
            case "ChestTrunk":
            case "ChestGold":
            case "ChestLid":
                {
                    hologram.apiKey = Globals.staticModelsProjectApiKey;
                    hologram.secKey = Globals.staticModelsProjectSecKey;
                    break;
                }
            default:
                {
                    break;
                }
        }
    }

    private void SetEntry(Echo3DHologram hologram)
    {
        switch (gameObject.name)
        {
            case "ArchRock":
                {
                    hologram.entries = Globals.arch01EntryId;
                    break;
                }
            case "SmallSoftCoral":
                {
                    hologram.entries = Globals.smallSoftCoralEntryId;
                    break;
                }
            case "LargeSoftCoral":
                {
                    hologram.entries = Globals.largeSoftCoralEntryId;
                    break;
                }
            case "BulbousCoral":
                {
                    hologram.entries = Globals.bulbousCoralEntryId;
                    break;
                }
            case "CoralBunch1":
                {
                    hologram.entries = Globals.coralBunch1EntryId;
                    break;
                }
            case "CoralBunch3":
                {
                    hologram.entries = Globals.coralBunch3EntryId;
                    break;
                }
            case "LargeShelfCoral2":
                {
                    hologram.entries = Globals.largeShelfCoral2EntryId;
                    break;
                }
            case "LargeShelfCoral4":
                {
                    hologram.entries = Globals.largeShelfCoral4EntryId;
                    break;
                }
            case "BlobbyCoral":
                {
                    hologram.entries = Globals.blobbyCoralEntryId;
                    break;
                }
            case "Coral3":
                {
                    hologram.entries = Globals.coral3EntryId;
                    break;
                }
            case "ChestGold":
                {
                    hologram.entries = Globals.chestGoldEntryId;
                    break;
                }
            case "ChestLid":
                {
                    hologram.entries = Globals.chestLidEntryId;
                    break;
                }
            case "ChestTrunk":
                {
                    hologram.entries = Globals.chestTrunkEntryId;
                    break;
                }
            default:
                {
                    break;
                }
        }
    }

    private void OnLoadAdjustment()
    {
        MeshRenderer myRenderer = gameObject.GetComponentInChildren<MeshRenderer>();
        switch (gameObject.name)
        {
            case "ArchRock":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = ArchRockMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "SmallSoftCoral":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = SmallSoftCoralMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "LargeSoftCoral":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = LargeSoftCoralMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "BulbousCoral":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = BulbousCoralMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "CoralBunch1":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = CoralBunchMaterial;
                        onLoadAdjustment = false;
                    };
                    break;
                }
            case "CoralBunch3":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = CoralBunchMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "LargeShelfCoral2":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = LargeShelfCoral2Material;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "LargeShelfCoral4":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = LargeShelfCoral4Material;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "BlobbyCoral":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = BlobbyCoralMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            case "Coral3":
                {
                    if (myRenderer)
                    {
                        myRenderer.material = BlobbyCoralMaterial;
                        onLoadAdjustment = false;
                    }
                    break;
                }
            default:
                {
                    onLoadAdjustment = false;
                    break;
                }
        }
    }

    void Update()
    {
        if (onLoadAdjustment)
        {
            OnLoadAdjustment();
        }
    }

}
