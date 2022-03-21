using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DistantLands
{
    public class MoveFishSchool : MonoBehaviour
    {

        public float moveRange;
        public float moveSpeed;
        public Vector2 positionChangeSpeed;
        float _time;
        Vector3 _originalPos;
        Vector3 _newPos;
        Transform target;


        void Awake()
        {
            _originalPos = transform.position;
            target = transform.GetChild(0);
        }

        // Update is called once per frame
        void Update()
        {

            if (_time >= 0)
            {
                _time -= Time.deltaTime;
                target.position = Vector3.MoveTowards(target.position, _newPos, moveSpeed * Time.deltaTime);
            }
            else
            {
                _time = Random.Range(positionChangeSpeed.x, positionChangeSpeed.y);
                _newPos = _originalPos += (Random.insideUnitSphere * moveRange);

            }
        }
    }
}