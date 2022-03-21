using UnityEngine;
using System.Collections;

namespace Everloop {
	
	public class RandomizeButton : MonoBehaviour {

		public EverloopController everloopController;
		public int numTracks = 3;
		public float fadeInDuration = 1;

		public virtual void OnClick() {
			everloopController.StopAll();
			everloopController.StartAutopilot();
		}
	}

}