namespace Everloop {
	using UnityEngine;

	[RequireComponent(typeof(AudioSource))]
	public class UnmuteController : MonoBehaviour {
	    public void Unmute(bool enabled) {
			AudioSource audio = GetComponent<AudioSource>();
	        if (enabled) {
	            audio.mute = false;
	        }
	    }
	}
}
