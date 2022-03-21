namespace Everloop {
	using UnityEngine;
	using UnityEngine.UI;

	public class MusicButton : MonoBehaviour
	{
	    public AudioSource Audio;
	    public Toggle PadToggle;

	    void Update()
	    {
	        if (!Audio.isPlaying && PadToggle.isOn)
	        {
	            PadToggle.isOn = false;
	            Audio.time = 0;
	        }
	        if (Audio.isPlaying && !PadToggle.isOn)
	        {
	            PadToggle.isOn = true;
	        }
	    }

	    public void OnToggle(bool isOn)
	    {
	        if (Audio == null)
	        {
	            return;
	        }

	        if (isOn)
	        {
	            Audio.Play();
	        }
	        else
	        {
	            Audio.Pause();
	        }
	    }
	}
}
