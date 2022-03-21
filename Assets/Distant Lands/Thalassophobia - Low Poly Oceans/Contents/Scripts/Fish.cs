using UnityEngine;
using System.Collections;

namespace DistantLands
{
	public class Fish : MonoBehaviour
	{

		private float speed;
		public float averageSpeed;
		//public float turnSpeed = 4.0f;
		Vector3 averageHeading;
		Vector3 averagePosition;
		float neighborDistance = 3.0f;
		public int performance;
		[HideInInspector]
		public GlobalFlock flock;

		bool turning = false;

		// Use this for initialization
		void Start()
		{
			speed = Random.Range(0.5f, 1.5f) * averageSpeed;
		}

		// Update is called once per frame
		void Update()
		{
			ApplyTankBoundary();

			if (turning)
			{
				Vector3 direction = flock.target.transform.position + Vector3.up * Random.Range(-2, 2) - transform.position;
				transform.rotation = Quaternion.Slerp(transform.rotation,
					Quaternion.LookRotation(direction),
					TurnSpeed() * Time.deltaTime);

			}
			else
			{
				if (Random.Range(0, performance + 1) < 1)
					ApplyRules();
			}

			transform.Translate(0, 0, Time.deltaTime * speed);
		}

		void ApplyTankBoundary()
		{
			if (Vector3.Distance(transform.position, flock.target.transform.position) >= flock.wanderSize)
			{
				turning = true;
			}
			else
			{
				turning = false;
			}
		}

		void ApplyRules()
		{
			GameObject[] gos;
			gos = flock.allFish.ToArray();

			speed = Random.Range(0.5f, 1.5f) * averageSpeed;


			Vector3 vCenter = flock.target.transform.position;
			Vector3 vAvoid = Vector3.zero;
			float gSpeed = 0;

			Vector3 goalPos = flock.target.transform.position;

			float dist;
			int groupSize = 0;


			foreach (GameObject go in gos)
			{
				if (go != this.gameObject)
				{
					dist = Vector3.Distance(go.transform.position, this.transform.position);
					if (dist <= neighborDistance)
					{
						vCenter += go.transform.position;
						groupSize++;

						if (dist < 0.75f)
						{
							vAvoid = vAvoid + (this.transform.position - go.transform.position);
						}

						Fish anotherFish = go.GetComponent<Fish>();
						gSpeed += anotherFish.speed;
					}

				}
			}

			if (groupSize > 0)
			{
				vCenter = vCenter / groupSize + (goalPos - this.transform.position);
				speed = gSpeed / groupSize;

				Vector3 direction = (vCenter + vAvoid) - transform.position;
				if (direction != Vector3.zero)
				{
					transform.rotation = Quaternion.Slerp(transform.rotation,
						Quaternion.LookRotation(direction),
						TurnSpeed() * Time.deltaTime);
				}
			}

		}

		float TurnSpeed()
		{
			return Random.Range(0.2f, .4f) * speed;
		}
	}
}