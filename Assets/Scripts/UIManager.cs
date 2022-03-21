using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class UIManager : MonoBehaviour
{

    public Image loadingCurtain;
    public Text loadingTextObj;
    public EquariumManager equariumManager;
    public EverloopController musicBox;

    [HideInInspector]
    public bool finishedLoading = false;

    float curtainAlpha = 1f;
    bool revealCurtain = false;
    string loadingTextEllipsis = "";
    const string loadingText = "Loading Equarium";
    string loadingProgress = " (0%)";
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(loadingTextAnim());
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.anyKey && finishedLoading)
        {
            loadingTextObj.gameObject.SetActive(false);
            revealCurtain = true;
        }
        if (Input.GetKeyDown(KeyCode.P))
        {
            if ( musicBox.volume <= 0.95f)
            {
                musicBox.volume += 0.05f;
            }
        }
        else if (Input.GetKeyDown(KeyCode.L))
        {
            if (musicBox.volume >= 0.05f)
            {
                musicBox.volume -= 0.05f;
            }
        }
        fadeCurtain();
        loadingTextAnim();
    }


    public void sceneLoaded()
    {
        finishedLoading = true;
        loadingTextObj.text = "Press any key.";
    }

    void fadeCurtain()
    {
        if (curtainAlpha == 0 || !revealCurtain)
        {
            return;
        }

        curtainAlpha -= 0.001f;
        if (curtainAlpha < 0)
        {
            curtainAlpha = 0;
        }
        loadingCurtain.color = new Color (0,0,0,curtainAlpha);
    }

    IEnumerator loadingTextAnim()
    {
        while (!finishedLoading)
        {
        yield return new WaitForSeconds(0.25f);

        loadingProgress = equariumManager.getLoadedPercent();
        if (finishedLoading) {yield break;}
        switch(loadingTextEllipsis.Length)
        {
            case 0:
            {
                loadingTextEllipsis = ".";
                break;
            }
            case 1: 
            {
                loadingTextEllipsis = "..";
                break;
            }
            case 2: {
                loadingTextEllipsis = "...";
                break;
            }
            case 3: {
                loadingTextEllipsis = "";
                break;
            }
            default:
            {
                loadingTextEllipsis = "";
                break;
            }
        }
        loadingTextObj.text = loadingText + loadingProgress + loadingTextEllipsis;
        }
        yield return null;
    }
}
