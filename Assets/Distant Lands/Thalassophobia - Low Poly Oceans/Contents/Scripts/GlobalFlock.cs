using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace DistantLands
{
	public class GlobalFlock : MonoBehaviour
	{

		public GameObject[] fishPrefabs;
		public GameObject fishSchool;
		public float wanderSize = 7;
		public GameObject target;

		public int numFish = 30;
		[HideInInspector]
		public List<GameObject> allFish;
		public static Vector3 goalPos = Vector3.zero;

		// Use this for initialization
		void Start()
		{
			for (int i = 0; i < numFish; i++)
			{
				GameObject fish = Instantiate(
					fishPrefabs[Random.Range(0, fishPrefabs.Length)], transform.position + Random.insideUnitSphere * wanderSize, Quaternion.identity);
				fish.transform.parent = fishSchool.transform;
				fish.transform.localScale = Vector3.one * (Random.value * .2f + 0.9f);
				fish.GetComponent<Fish>().flock = this;
				allFish.Add(fish);
			}
		}

		// Update is called once per frame
		void Update()
		{
			HandleGoalPos();
		}

		void HandleGoalPos()
		{
			if (Random.Range(1, 10000) < 50)
			{
				goalPos = new Vector3(
					Random.Range(-wanderSize, wanderSize),
					Random.Range(-wanderSize, wanderSize),
					Random.Range(-wanderSize, wanderSize)
				);
			}
		}

		private void OnDrawGizmos()
		{

			Gizmos.color = Color.blue;

			Gizmos.DrawWireSphere(transform.position, wanderSize);


		}


	}
}