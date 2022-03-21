using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace DistantLands
{
    public class WaypointSystem : MonoBehaviour
    {


        public Transform objectToMove;
        public float moveSpeed;
        public float turnSpeed;

        private Transform target;
        private int progress;
        private List<Transform> waypoints;


        // Start is called before the first frame update
        void Awake()
        {

            waypoints = GetComponentsInChildren<Transform>().ToList();
            waypoints.Remove(transform);
            target = waypoints[progress];
        }

        // Update is called once per frame
        void Update()
        {
            if (objectToMove == null)
            {
                return;
            }
            objectToMove.position += objectToMove.forward * moveSpeed * Time.deltaTime;
            objectToMove.rotation = Quaternion.RotateTowards(objectToMove.rotation, Quaternion.LookRotation(target.position - objectToMove.position, Vector3.up), turnSpeed * Time.deltaTime);

            if (Vector3.Distance(objectToMove.position, target.position) < moveSpeed)
                NextPoint();

        }

        public void SetTargetTransform(Transform target)
        {
            objectToMove = target;
            target.position = waypoints[0].position;
        }
        public void NextPoint()
        {

            progress++;

            if (progress >= waypoints.Count)
                progress = 0;

            target = waypoints[progress];


        }



        private void OnDrawGizmos()
        {


            for (int i = 0; i < transform.childCount; i++)
            {

                if (!transform.GetChild(i))
                    continue;

                Transform j = transform.GetChild(i);

                Gizmos.color = Color.green;
                Gizmos.DrawWireSphere(j.position, 0.5f);

                if (i < transform.childCount - 1)
                    Gizmos.DrawLine(j.position, transform.GetChild(i + 1).position);
                else
                    Gizmos.DrawLine(j.position, transform.GetChild(0).position);

            }
        }
    }
}