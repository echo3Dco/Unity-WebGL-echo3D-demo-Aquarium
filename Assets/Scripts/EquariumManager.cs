using System.Collections;
using System.Collections.Generic;
using SimpleJSON;

using UnityEngine.Networking;
using UnityEngine;
using DistantLands;
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
    private int assetsDownloaded =0;

    static private Database dbObject;


    //on Awake, query the echo database and get a list of all possible entries (critters/fish)
    void Awake()
    {
        //Debug.Log("Echo 3D CS Start");
        totalFishToSpawn = presetCritterPaths.Count;
        // The echo3D server details
        string endpointURL = "https://api.echo3D.co";
        string serverURL = endpointURL + "/query?key=" + Globals.fishProjectApiKey + "&secKey=" + Globals.fishProjectSecKey + "&src=UnitySDK";


        try
        {
            // Query database for all the entries
            StartCoroutine(QueryDatabase(serverURL));
        }
        catch (System.Exception e)
        {
            Debug.Log(e);
        }
    }
    IEnumerator QueryDatabase(string serverURL)
    {
        // Create a new request
        UnityWebRequest www = UnityWebRequest.Get(serverURL);

        Debug.Log("Querying database...");
        //GetComponent<FishController>().manager.queriedDatabase();

        // Yield for the request
        yield return www.SendWebRequest();

        // Wait for the request to finish
        while (!www.isDone)
        {
            yield return null;
        }

        string json = "not found";
        // Check for errors
        if (www.result == UnityWebRequest.Result.ConnectionError)
        {
            Debug.Log(www.error);
        }
        else
        {
            // Parse response
            json = www.downloadHandler.text;

            // Handle repsonse
            Debug.Log("Query Response:");
            print(json);

            // Parse Database
            ParseDatabase(json);
        }

        // Cleanup
        www.disposeDownloadHandlerOnDispose = true;
        www.disposeUploadHandlerOnDispose = true;
        www.Dispose();
        www = null;

    }
    public void ParseDatabase(string json)
    {
        // Parse database
        if (!json.ToLower().Contains("not found"))
        {
            Debug.Log("Parsing database...");
            // Parse JSON
            var parsedJSON = JSON.Parse(json);
            // Create a Database object with and API key
            dbObject = new Database(parsedJSON["apiKey"].Value);
            // Get entries
            int i = 0;
            var entry = parsedJSON["db"][i];
            while (entry != null)
            {
                // Parse Entry
                ParseEntry(entry);
                // Continue to next entry
                entry = parsedJSON["db"][++i];
            }
            Debug.Log("Database parsed.");
        }
    }
     public Entry ParseEntry(JSONNode entry)
    {
        // Create entry
        Entry entryObject = new Entry();
        entryObject.setId(entry["id"]);

        // Create target
        Target targetObject;
        var target = entry["target"];
        string targetType = target["type"];
        switch (targetType)
        {
            case "IMAGE_TARGET":
                ImageTarget imageTargetObject = new ImageTarget();
                imageTargetObject.setFilename(target["filename"]);
                imageTargetObject.setStorageID(target["storageID"]);
                imageTargetObject.setId(target["id"]);
                imageTargetObject.setType(Target.targetType.IMAGE_TARGET);
                targetObject = imageTargetObject;
                break;
            case "GEOLOCATION_TARGET":
                GeolocationTarget geolocationTargetObject = new GeolocationTarget();
                geolocationTargetObject.setCity(target["city"]);
                geolocationTargetObject.setContinent(target["continent"]);
                geolocationTargetObject.setCountry(target["country"]);
                geolocationTargetObject.setId(target["id"]);
                geolocationTargetObject.setLatitude(target["latitude"]);
                geolocationTargetObject.setLongitude(target["longitude"]);
                geolocationTargetObject.setPlace(target["place"]);
                geolocationTargetObject.setType(Target.targetType.GEOLOCATION_TARGET);
                targetObject = geolocationTargetObject;
                break;
            case "BRICK_TARGET":
                BrickTarget brickTargetObject = new BrickTarget();
                brickTargetObject.setId(target["id"]);
                brickTargetObject.setType(Target.targetType.BRICK_TARGET);
                targetObject = brickTargetObject;
                break;
            default:
                targetObject = new Target();
                break;
        }
        List<string> hologramsListObject = new List<string>();
        int j = 0;
        var hologramID = target["holograms"][j];
        while (hologramID != null)
        {
            hologramsListObject.Add(hologramID);
            hologramID = target["holograms"][++j];
        }
        targetObject.setHolograms(hologramsListObject);
        entryObject.setTarget(targetObject);

        // Create Hologram
        Hologram hologramObject;
        var hologram = entry["hologram"];
        string hologramType = hologram["type"];
        switch (hologramType)
        {
            case "IMAGE_HOLOGRAM":
                ImageHologram imageHologramObject = new ImageHologram();
                imageHologramObject.setFilename(hologram["filename"]);
                imageHologramObject.setId(hologram["id"]);
                imageHologramObject.setStorageID(hologram["storageID"]);
                imageHologramObject.setTargetID(hologram["targetID"]);
                imageHologramObject.setType(Hologram.hologramType.IMAGE_HOLOGRAM);
                imageHologramObject.setTarget(targetObject);
                hologramObject = imageHologramObject;
                break;
            case "VIDEO_HOLOGRAM":
                VideoHologram videoHologramObject = new VideoHologram();
                videoHologramObject.setFilename(hologram["filename"]);
                videoHologramObject.setId(hologram["id"]);
                videoHologramObject.setStorageID(hologram["storageID"]);
                videoHologramObject.setTargetID(hologram["targetID"]);
                videoHologramObject.setType(Hologram.hologramType.VIDEO_HOLOGRAM);
                videoHologramObject.setTarget(targetObject);
                hologramObject = videoHologramObject;
                break;
            case "ECHO_HOLOGRAM":
                EchoHologram echoHologramObject = new EchoHologram();
                echoHologramObject.setFilename(hologram["filename"]);
                echoHologramObject.setId(hologram["id"]);
                echoHologramObject.setEncodedEcho(hologram["encodedEcho"]);
                echoHologramObject.setTextureFilename(hologram["textureFilename"]);
                echoHologramObject.setTargetID(hologram["targetID"]);
                echoHologramObject.setType(Hologram.hologramType.ECHO_HOLOGRAM);
                echoHologramObject.setTarget(targetObject);
                List<string> videosListObject = new List<string>();

                j = 0;
                var videoID = hologram["vidoes"][j];
                while (videoID != null)
                {
                    videosListObject.Add(videoID);
                    hologramID = hologram["vidoes"][++j];
                }
                echoHologramObject.setVidoes(videosListObject);

                hologramObject = echoHologramObject;
                break;
            case "MODEL_HOLOGRAM":
                ModelHologram modelHologramObject = new ModelHologram();
                modelHologramObject.setEncodedFile(hologram["encodedFile"]);
                modelHologramObject.setFilename(hologram["filename"]);
                modelHologramObject.setId(hologram["id"]);
                modelHologramObject.setMaterialFilename(hologram["materialFilename"]);
                modelHologramObject.setMaterialStorageID(hologram["materialStorageID"]);
                modelHologramObject.setStorageID(hologram["storageID"]);
                modelHologramObject.setTargetID(hologram["targetID"]);
                var textureFilenames = hologram["textureFilenames"].AsArray;
                var textureStorageIDs = hologram["textureStorageIDs"].AsArray;
                for (j = 0; j < textureFilenames.Count; j++)
                {
                    modelHologramObject.addTexture(textureFilenames[j], textureStorageIDs[j]);
                }
                modelHologramObject.setType(Hologram.hologramType.MODEL_HOLOGRAM);
                modelHologramObject.setTarget(targetObject);
                // If applicable, update model hologram with .glb version
                if (entry["additionalData"]["glbHologramStorageID"] != null) {
                    modelHologramObject.setFilename(entry["additionalData"]["glbHologramStorageFilename"]);
                    modelHologramObject.setStorageID(entry["additionalData"]["glbHologramStorageID"]);
                }
                hologramObject = modelHologramObject;
                break;
            default:
                hologramObject = new Hologram();
                break;
        }
        entryObject.setHologram(hologramObject);

        // Create SDKs array
        bool[] sdksObject = new bool[9];
        var sdks = entry["sdks"].AsArray;
        for (j = 0; j < 9; j++)
        {
            sdksObject[j] = sdks[j];
        }
        entryObject.setSupportedSDKs(sdksObject);

        // Create Additional Data
        var additionalData = entry["additionalData"];
        foreach (var data in additionalData)
        {
            entryObject.addAdditionalData(data.Key, data.Value);
        }

        // Add entry to database
        dbObject.addEntry(entryObject);

        // Return
        return entryObject;
    }
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(whichFishShouldSpawn());   
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    public void fishFinishedLoading(){
        totalFishLoaded++;
        
        if (totalFishLoaded == totalFishToSpawn)
        {
            userInterface.sceneLoaded();
        }
    }

    public void queriedDatabase(){
        dataQueried++;
    }

    public void assetDownloaded()
    {
        assetsDownloaded++;
    }

    public string getLoadedPercent(){

        int percent = Mathf.RoundToInt((dataQueried + assetsDownloaded + totalFishLoaded) / (totalFishToSpawn * 3f) * 100);
        
        return " (" + percent.ToString()+ "%)";
    }
    IEnumerator whichFishShouldSpawn()
    {
        while (dbObject==null)
        {
            yield return null;
        }
        Debug.Log("I have many critters to choose from: " + dbObject.getEntries().Count);

        entriesToSpawn = new List<string>();
        Entry[] entriesArray = new Entry[dbObject.getEntries().Count];
        dbObject.getEntries().CopyTo(entriesArray);

        for (int i = 0; i < presetCritterPaths.Count; i++)
        {
            entriesToSpawn.Add(entriesArray[Random.Range(0, entriesArray.Length)].getId());
        }
        spawnFish();
        yield break;
    }

    void spawnFish()
    {    

        entriesToSpawn.ForEach( (entry) => {
            GameObject newCritter = Instantiate(entry == Globals.hammerheadEntryId ?  hammerheadPrefab :fishModelPrefab, Vector3.zero, Quaternion.identity, crittersParentObj.transform);
            if (entry != Globals.hammerheadEntryId)
            {
                newCritter.GetComponentInChildren<FishController>().setManagerRef(this);
                newCritter.GetComponentInChildren<Echo3DHologram>().Entries = entry;
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
