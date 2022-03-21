namespace Everloop {
	using UnityEngine;
	using System.Collections;
	
	public class AnimationToggle : MonoBehaviour
	{
		public Animation Animation;
		
		public void Toggle(bool isOn)
		{
			AnimationState cameraAnimation = Animation["CameraAnimation"];
			if (!isOn)
			{
				cameraAnimation.time = cameraAnimation.length;
			}
			cameraAnimation.speed = isOn? 1.0f : -1.0f;
			Animation.Play();
		}
	}
}