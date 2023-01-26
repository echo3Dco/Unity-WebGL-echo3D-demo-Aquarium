using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/* 

This script is used to make adjustments to loaded holograms pre and post load.
It determines the appropriate adjustments based on the entryID. 
*/

[RequireComponent(typeof(Echo3DHologram))]
public class SceneHelper : MonoBehaviour
{

    private Echo3DHologram hologram;

    void Awake()
    {
        PreloadConfiguration();
    }


    private void PreloadConfiguration()
    {
        hologram = GetComponent<Echo3DHologram>();
        if (hologram == null)
        {
            Debug.LogError("Scene helper failed to load hologram component.");
            return;
        }
        switch (hologram.entries)
        {
            case Globals.arch01EntryId:
            case Globals.largeSoftCoralEntryId:
            case Globals.smallSoftCoralEntryId:
            case Globals.bulbousCoralEntryId:
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

}
