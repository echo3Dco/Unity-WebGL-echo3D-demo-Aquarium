using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishController : MonoBehaviour
{
    public Animator myAnim;
    public Shader distantLandsFishShader;
    public Texture2D distantLandsFishTextureAtlas;
    public EquariumManager manager;
    public bool isHammerHead = false;

    private MeshRenderer myMeshRenderer;



    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(isHammerHead ? postImportActivityHammerhead() : postImportActivity());
    }

    // Update is called once per frame
    void Update()
    {

    }
    public void setManagerRef(EquariumManager mgr)
    {
        manager = mgr;
    }
    //After loading the mesh from echo some fixes/tweaks are needed
    IEnumerator postImportActivity()
    {
        //A hacky way to detect when the objects have loaded. 
        //Specific to the models used (in the case of Thalassaphobia models, 2 children are created on load)
        while (GetComponentInChildren<MeshRenderer>() == null)
        {
            yield return null;
        }
        yield return new WaitForSeconds(2f);


        //The initialized meshrenderer for everything but the hammerhead is located in a nested child
        myMeshRenderer = GetComponentInChildren<MeshRenderer>();

        if (myMeshRenderer != null) //aka every fish but the hammerhead
        {
            //set the appropriate/randomized shader, texture and shader values (for swimming animation effect)
            myMeshRenderer.material.shader = distantLandsFishShader;
            myMeshRenderer.material.SetTexture("_Atlas", distantLandsFishTextureAtlas);
            myMeshRenderer.material.SetTextureScale("_Atlas", new Vector2(Random.value, Random.value));
            myMeshRenderer.material.SetVector("_WaveAmount", new Vector4(6f, 2f, 0, 0));
            myMeshRenderer.material.SetVector("_TimeScale", new Vector4(1, 1, 0, 0));
            myMeshRenderer.material.SetVector("_WaveWidth", new Vector4(5, 4, 0, 0));

            //random scale for variety
            float randomScale = Random.Range(100f, 175f);
            gameObject.transform.localScale = new Vector3(randomScale, randomScale, randomScale);
        }

        manager.fishFinishedLoading();
        yield break;
    }

    IEnumerator postImportActivityHammerhead()
    {
        while (GetComponentInChildren<SkinnedMeshRenderer>() == null)
        {
            yield return null;
        }
        yield return new WaitForSeconds(2f);
        if (myAnim)
        {
            myAnim.Rebind();
        }
        manager.fishFinishedLoading();
        yield break;
    }
}
