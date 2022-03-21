namespace Everloop {
	using System;
	using UnityEngine;
	using UnityEngine.EventSystems;
	using UnityEngine.UI;

	public class TimeSlider : Slider
	{
	    private AudioSource _sound;
		private bool _isDragging;
		private float _volume;

	    protected override void Start() {
	        base.Start();

		    _sound = GetComponent<AudioSourceReference>().AudioSource;
	        maxValue = _sound.clip.length;
		}

	    protected override void Update() {
			base.Update();
			
	        if (!Input.GetMouseButton(0) || !_isDragging) {
	            value = _sound.time;
	        }

			if (_isDragging && Input.GetMouseButtonUp(0)) {
				_isDragging = false;
				_sound.mute = false;
			}
	    }

	    public override void OnDrag(PointerEventData eventData) {
	        _sound.time = Math.Min(value, _sound.clip.length - 1);
			_isDragging = true;

			// Mute sound while seeking to avoid seek noise.
			_sound.mute = true;

	        base.OnDrag(eventData);
	    }
	}
}
