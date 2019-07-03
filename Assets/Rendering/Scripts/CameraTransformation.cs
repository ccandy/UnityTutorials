using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTransformation : Transformation
{
    public float focalLenght;
    public override Matrix4x4 Matrix
    {
        get
        {
            Matrix4x4 matrix = new Matrix4x4();
            matrix.SetRow(0, new Vector4(focalLenght, 0f, 0f, 0f));
            matrix.SetRow(1, new Vector4(0f, focalLenght, 0f, 0f));
            matrix.SetRow(2, new Vector4(0f, 0f, 0f, 0f));
            matrix.SetRow(3, new Vector4(0f, 0f, 1f, 1f));
            return matrix;
        }
    }

}
