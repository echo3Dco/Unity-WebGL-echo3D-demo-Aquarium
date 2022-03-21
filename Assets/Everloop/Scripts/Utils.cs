using UnityEngine;
using System.Collections.Generic;

namespace Everloop
{
	public class Utils
	{
		
		public static void Shuffle<T>(IList<T> list) {
			for (int i = 0; i < list.Count; i++) {
				T temp = list[i];
				int randomIndex = Random.Range(i, list.Count);
				list[i] = list[randomIndex];
				list[randomIndex] = temp;
			}
		}
		
		public static float NormalDistributionRandom(float minValue, float maxValue) {
			float u, v, S;
			
			do {
				u = 2.0f * Random.value - 1.0f;
				v = 2.0f * Random.value - 1.0f;
				S = u * u + v * v;
			} while (S >= 1.0f);
			
			float fac = Mathf.Sqrt(-2.0f * Mathf.Log(S) / S);
			fac = u * fac;
			
			float mean = (minValue + maxValue) / 2f;
			float sigma = (maxValue - mean) / 3f;
			
			return mean + sigma * fac;
		}
		
		public static AudioSource GetOneOfTheFirst(List<AudioSource> array) {
			if (array.Count >= 3) {
				float r = Random.value;
				// 40% : 35% : 25%
				int index = r < 0.4? 0 : (r < 0.75? 1 : 2);
				return array[index];
			} else if (array.Count >= 2) {
				float r = Random.value;
				// 65% : 35%
				int index = r < 0.65? 0 : 1;
				return array[index];
			} else if (array.Count >= 1) {
				return array[0];
			}
			return null;
		}

	}
}

