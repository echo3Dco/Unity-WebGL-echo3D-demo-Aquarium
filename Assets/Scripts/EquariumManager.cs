using System.Collections;
using System.Collections.Generic;

using UnityEngine.Networking;
using UnityEngine;
using DistantLands;

[RequireComponent(typeof(Echo3DHologram))]
public class EquariumManager : MonoBehaviour
{

    public List<WaypointSystem> presetCritterPaths;
    public GameObject crittersParentObj;
    public UIManager userInterface;

    public GameObject fishModelPrefab;
    public GameObject hammerheadPrefab;
    List<GameObject> crittersToSpawn;
    List<string> entriesToSpawn;
    private int totalFishToSpawn = 0;
    private int totalFishLoaded = 0;
    private int dataQueried = 0;
    private int assetsDownloaded = 0;

    private Echo3DHologram allFishQueryHologram;


    //on Awake, query the echo database and get a list of all possible entries (critters/fish)
    void Awake()
    {
        //Debug.Log("Echo 3D CS Start");
        totalFishToSpawn = presetCritterPaths.Count;
        // The echo3D server details
        string endpointURL = "https://api.echo3D.co";
        string queryURL = endpointURL + "/query?key=" + Globals.fishProjectApiKey + "&secKey=" + Globals.fishProjectSecKey + "&src=UnitySDK";
        allFishQueryHologram = GetComponent<Echo3DHologram>();
        allFishQueryHologram.queryOnly = true;
        allFishQueryHologram.queryURL = queryURL;
        allFishQueryHologram.queryData = null;
    }

    void Start()
    {
        StartCoroutine(whichFishShouldSpawn());
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("DB: " + allFishQueryHologram.queryData == null);
    }


    public void fishFinishedLoading()
    {
        totalFishLoaded++;

        if (totalFishLoaded == totalFishToSpawn)
        {
            userInterface.sceneLoaded();
        }
    }

    public void queriedDatabase()
    {
        dataQueried++;
    }

    public void assetDownloaded()
    {
        assetsDownloaded++;
    }

    public string getLoadedPercent()
    {

        int percent = Mathf.RoundToInt((dataQueried + assetsDownloaded + totalFishLoaded) / (totalFishToSpawn * 3f) * 100);

        return " (" + percent.ToString() + "%)";
    }
    IEnumerator whichFishShouldSpawn()
    {
        while (allFishQueryHologram.queryData == null)
        {
            yield return null;
        }

        Debug.Log("I have many critters to choose from: " + allFishQueryHologram.queryData.getEntries().Count);

        entriesToSpawn = new List<string>();
        Entry[] entriesArray = new Entry[allFishQueryHologram.queryData.getEntries().Count];
        allFishQueryHologram.queryData.getEntries().CopyTo(entriesArray);

        for (int i = 0; i < presetCritterPaths.Count; i++)
        {
            entriesToSpawn.Add(entriesArray[Random.Range(0, entriesArray.Length)].getId());
        }
        spawnFish();
        yield break;
    }

    void spawnFish()
    {

        entriesToSpawn.ForEach((entry) =>
        {
            GameObject newCritter = Instantiate(entry == Globals.hammerheadEntryId ? hammerheadPrefab : fishModelPrefab, Vector3.zero, Quaternion.identity, crittersParentObj.transform);
            Echo3DHologram holo = GetComponentInChildren<Echo3DHologram>();
            if (entry != Globals.hammerheadEntryId)
            {
                newCritter.GetComponentInChildren<FishController>().setManagerRef(this);
                holo.entries = entry;
                holo.apiKey = Globals.fishProjectApiKey;
                holo.secKey = Globals.fishProjectSecKey;
            }

            WaypointSystem path = createCritterPath();
            path.SetTargetTransform(newCritter.transform);
        });
    }

    WaypointSystem createCritterPath()
    {
        //todo: dynamic pathing generation within the aquarium. Currently predefined via gameobjects in scene (FishPath objects)

        return presetCritterPaths.Find((waypointSys) => waypointSys.objectToMove == null);
    }



}
