using UnityEngine.UI;
using UnityEngine;
using System.Collections;

namespace Everloop {

	[RequireComponent(typeof(Toggle))]
	public class LayerToggleListener : MonoBehaviour {
		public AudioSource track;
		public float minAlpha;

		private Toggle toggle;
		
		void Start () {
			toggle = GetComponent<Toggle>();
		}
		
		void Update () {
			if (track.isPlaying && !toggle.isOn) {
				toggle.isOn = true;
			}

			if (!track.isPlaying && toggle.isOn) {
				toggle.isOn = false;
			}

			if (toggle.isOn && (minAlpha + track.volume) != toggle.graphic.color.a) {
				Color c = toggle.graphic.color;
				c.a = minAlpha + track.volume;
				toggle.graphic.color = c;
			}
		}
	}

}
