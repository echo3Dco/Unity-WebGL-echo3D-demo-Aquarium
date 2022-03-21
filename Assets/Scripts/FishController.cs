using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishController : MonoBehaviour
{
    public Animator myAnim;
    public Shader distantLandsFishShader;
    public Texture2D distantLandsFishTextureAtlas;
    public EquariumManager manager;

    private MeshRenderer myMeshRenderer;
    private bool finishedModelLoad = false;

    // Start is called before the first frame update
    void Start()
    {
            StartCoroutine(postImportActivity());
    }

    // Update is called once per frame
    void Update()
    {

    }
    public void finishedModelLoading() {
        finishedModelLoad = true;
    }
    public void setManagerRef(EquariumManager mgr)
    {
        manager = mgr;
    }
//After loading the mesh from echo some fixes/tweaks are needed
    IEnumerator postImportActivity() {


        //A hacky way to detect when the objects have loaded. 
        //Specific to the models used (in the case of Thalassaphobia models, 2 children are created on load)
        while (!finishedModelLoad){
            yield return null;
        }
        yield return new WaitForSeconds(2f);
        if (myAnim) {myAnim.Rebind();}

        foreach (Transform child in transform)
        {
            child.localRotation = Quaternion.identity;

            //All fish except the hammerhead import with the same gameobject structure/heirarchy
            Transform nestedChild = child.GetChild(0);
            if (nestedChild!=null)
            {
                //clear any position/rotation on import
                nestedChild.localRotation = Quaternion.identity;
                nestedChild.localPosition = Vector3.zero;

                //The initialized meshrenderer for everything but the hammerhead is located in a nested child
                myMeshRenderer = nestedChild.gameObject.GetComponent<MeshRenderer>();

                if (myMeshRenderer != null) //aka every fish but the hammerhead
                {

                    //set the appopriate shader, texture and shader values (for swimming animation effect)
                    myMeshRenderer.material.shader = distantLandsFishShader;
                    myMeshRenderer.material.SetTexture("_Atlas", distantLandsFishTextureAtlas);
                    myMeshRenderer.material.SetTextureScale("_Atlas",new Vector2(Random.value, Random.value));
                    myMeshRenderer.material.SetVector("_WaveAmount", new Vector4(6f,2f,0,0));
                    myMeshRenderer.material.SetVector("_TimeScale", new Vector4(1,1,0,0));
                    myMeshRenderer.material.SetVector("_WaveWidth", new Vector4(5,4,0,0));

                    //random scale for variety
                    float randomScale = Random.Range(1f,1.75f);
                    gameObject.transform.localScale = new Vector3(randomScale, randomScale, randomScale);
                }
            }
        }  
        transform.Rotate(Vector3.up, 180f);

        manager.fishFinishedLoading();

        yield break;
    }
}
