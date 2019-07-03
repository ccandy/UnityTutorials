using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformationGrid : MonoBehaviour
{
    // Start is called before the first frame update

    public Transform        prefab;
    public int              girdResolution = 10;
    Transform[]             gird;
    List<Transformation>    transformations;

    Matrix4x4 transformation;

    private void Awake()
    {
        gird    = new Transform[girdResolution * girdResolution * girdResolution];
        for(int i = 0, z = 0; z < girdResolution; z++)
        {
            for (int y = 0; y < girdResolution; y++)
            {
                for (int x = 0; x < girdResolution; x++, i++)
                {
                    gird[i] = CreateGridPoint(x, y, z);
                }
            }
        }

        transformations = new List<Transformation>();
    }




    Transform CreateGridPoint(int x, int y, int z)
    {
        Transform point     = Instantiate<Transform>(prefab);
        point.localPosition = GetCoords(x, y, z);
        point.GetComponent<MeshRenderer>().material.color = new Color(
                (float)x / girdResolution,
                (float)y / girdResolution,
                (float)z / girdResolution
            );

        return point;
    }

    Vector3 GetCoords(int x, int y, int z)
    {
        return new Vector3(

            x - (girdResolution - 1) * 0.5f,
            y - (girdResolution - 1) * 0.5f,
            z - (girdResolution - 1) * 0.5f

        );
    }

    private void Update()
    {
        UpdateTransformation();
        for (int i = 0, z = 0; z < girdResolution; z++)
        {
            for(int y = 0; y < girdResolution; y++)
            {
                for (int x = 0; x < girdResolution; x++, i++)
                {
                    gird[i].localPosition = TransformPoint(x, y, z);
                }
            }
        }
    }



    void UpdateTransformation()
    {
        GetComponents<Transformation>(transformations);
        if (transformations.Count > 0)
        {
            transformation = transformations[0].Matrix;
            for (int i = 1; i < transformations.Count; i++)
            {
                transformation = transformations[i].Matrix * transformation;
            }
        }
    }

    private Vector3 TransformPoint(int x, int y, int z)
    {
        Vector3 coords = GetCoords(x, y, z);
        for(int n = 0; n < transformations.Count; n++)
        {
            coords = transformations[n].Apply(coords);
        }
        return coords;
    }




}
