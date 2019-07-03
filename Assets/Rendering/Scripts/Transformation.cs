using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Transformation : MonoBehaviour
{
    List<Transformation> transforms;


    public Vector3 Apply(Vector3 point)
    {
        return Matrix.MultiplyPoint(point);
    }
    public abstract Matrix4x4   Matrix
    {
        get;
    } 


}
