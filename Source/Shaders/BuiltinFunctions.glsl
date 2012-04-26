/**
 * DOC_TBA
 *
 * @name agi_infinity
 * @glslConstant 
 */
const float agi_infinity = 5906376272000.0; // Distance from the Sun to Pluto in meters.  TODO: What is best given lowp, mediump, and highp?

/**
 * DOC_TBA
 *
 * @name agi_epsilon1
 * @glslConstant 
 */
const float agi_epsilon1 = 0.1;
        
/**
 * DOC_TBA
 *
 * @name agi_epsilon2
 * @glslConstant 
 */
const float agi_epsilon2 = 0.01;
        
/**
 * DOC_TBA
 *
 * @name agi_epsilon3
 * @glslConstant 
 */
const float agi_epsilon3 = 0.001;
        
/**
 * DOC_TBA
 *
 * @name agi_epsilon4
 * @glslConstant 
 */
const float agi_epsilon4 = 0.0001;
        
/**
 * DOC_TBA
 *
 * @name agi_epsilon5
 * @glslConstant 
 */
const float agi_epsilon5 = 0.00001;
        
/**
 * DOC_TBA
 *
 * @name agi_epsilon6
 * @glslConstant 
 */
const float agi_epsilon6 = 0.000001;
        
/**
 * DOC_TBA
 *
 * @name agi_epsilon7
 * @glslConstant 
 */
const float agi_epsilon7 = 0.0000001;

/**
 * DOC_TBA
 *
 * @name agi_equalsEpsilon
 * @glslFunction
 */
bool agi_equalsEpsilon(float left, float right, float epsilon) {
    return (abs(left - right) <= epsilon);
}

bool agi_equalsEpsilon(float left, float right) {
    // Workaround bug in Opera Next 12.  Do not delegate to the other agi_equalsEpsilon.
    return (abs(left - right) <= agi_epsilon7);
}

///////////////////////////////////////////////////////////////////////////////

/**
 * Returns the transpose of the matrix.  The input <code>matrix</code> can be 
 * a <code>mat2</code>, <code>mat3</code>, or <code>mat4</code>.
 *
 * @name agi_transpose
 * @glslFunction
 *
 * @param {} matrix The matrix to transpose.
 *
 * @returns {} The transposed matrix.
 *
 * @example
 * // GLSL declarations
 * mat2 agi_transpose(mat2 matrix);
 * mat3 agi_transpose(mat3 matrix);
 * mat4 agi_transpose(mat4 matrix);
 *
 * // Tranpose a 3x3 rotation matrix to find its inverse.
 * mat3 eastNorthUpToEye = agi_eastNorthUpToEyeCoordinates(
 *     positionMC, normalEC);
 * mat3 eyeToEastNorthUp = agi_transpose(eastNorthUpToEye);
 */
mat2 agi_transpose(mat2 matrix)
{
    return mat2(
        matrix[0][0], matrix[1][0],
        matrix[0][1], matrix[1][1]);
}

mat3 agi_transpose(mat3 matrix)
{
    return mat3(
        matrix[0][0], matrix[1][0], matrix[2][0],
        matrix[0][1], matrix[1][1], matrix[2][1],
        matrix[0][2], matrix[1][2], matrix[2][2]);
}

mat4 agi_transpose(mat4 matrix)
{
    return mat4(
        matrix[0][0], matrix[1][0], matrix[2][0], matrix[3][0],
        matrix[0][1], matrix[1][1], matrix[2][1], matrix[3][1],
        matrix[0][2], matrix[1][2], matrix[2][2], matrix[3][2],
        matrix[0][3], matrix[1][3], matrix[2][3], matrix[3][3]);
}

///////////////////////////////////////////////////////////////////////////////

/**
 * Transforms a position from model to window coordinates.  The transformation
 * from model to clip coordinates is done using {@link agi_modelViewProjection}.
 * The transform from normalized device coordinates to window coordinates is
 * done using {@link agi_viewportTransformation}, which assumes a depth range
 * of <code>near = 0</code> and <code>far = 1</code>.
 * <br /><br />
 * This transform is useful when there is a need to manipulate window coordinates
 * in a vertex shader as done by {@link BillboardCollection}.
 * <br /><br />
 * This function should not be confused with {@link agi_viewportOrthographic},
 * which is an orthographic projection matrix that transforms from window 
 * coordinates to clip coordinates.
 *
 * @name agi_modelToWindowCoordinates
 * @glslFunction
 *
 * @param {vec4} position The position in model coordinates to transform.
 *
 * @returns {vec4} The transformed position in window coordinates.
 *
 * @see agi_eyeToWindowCoordinates
 * @see agi_modelViewProjection
 * @see agi_viewportTransformation
 * @see agi_viewportOrthographic
 * @see BillboardCollection
 *
 * @example
 * vec4 positionWC = agi_modelToWindowCoordinates(positionMC);
 */
vec4 agi_modelToWindowCoordinates(vec4 position)
{
    vec4 q = agi_modelViewProjection * position;                // clip coordinates
    q.xyz /= q.w;                                                // normalized device coordinates
    q.xyz = (agi_viewportTransformation * vec4(q.xyz, 1.0)).xyz; // window coordinates
    return q;
}

/**
 * Transforms a position from eye to window coordinates.  The transformation
 * from eye to clip coordinates is done using {@link agi_projection}.
 * The transform from normalized device coordinates to window coordinates is
 * done using {@link agi_viewportTransformation}, which assumes a depth range
 * of <code>near = 0</code> and <code>far = 1</code>.
 * <br /><br />
 * This transform is useful when there is a need to manipulate window coordinates
 * in a vertex shader as done by {@link BillboardCollection}.
 *
 * @name agi_eyeToWindowCoordinates
 * @glslFunction
 *
 * @param {vec4} position The position in eye coordinates to transform.
 *
 * @returns {vec4} The transformed position in window coordinates.
 *
 * @see agi_modelToWindowCoordinates
 * @see agi_projection
 * @see agi_viewportTransformation
 * @see BillboardCollection
 *
 * @example
 * vec4 positionWC = agi_modelToWindowCoordinates(positionEC);
 */
vec4 agi_eyeToWindowCoordinates(vec4 positionEC)
{
    vec4 q = agi_projection * positionEC;                       // clip coordinates
    q.xyz /= q.w;                                                // normalized device coordinates
    q.xyz = (agi_viewportTransformation * vec4(q.xyz, 1.0)).xyz; // window coordinates
    return q;
}

///////////////////////////////////////////////////////////////////////////////

/**
 * DOC_TBA
 *
 * @name agi_eyeOffset
 * @glslFunction
 *
 * @param {vec4} positionEC DOC_TBA.
 * @param {vec3} eyeOffset DOC_TBA.
 *
 * @returns {vec4} DOC_TBA.
 */
vec4 agi_eyeOffset(vec4 positionEC, vec3 eyeOffset)
{
    // This equation is approximate in x and y.
    vec4 p = positionEC;
    vec4 zEyeOffset = normalize(p) * eyeOffset.z;
    p.xy += eyeOffset.xy + zEyeOffset.xy;
    p.z += zEyeOffset.z;
    return p;
}

///////////////////////////////////////////////////////////////////////////////

/**
 * DOC_TBA
 *
 * @name agi_geodeticSurfaceNormal
 * @glslFunction
 *
 * @param {vec3} positionOnEllipsoid DOC_TBA
 * @param {vec3} ellipsoidCenter DOC_TBA
 * @param {vec3} oneOverEllipsoidRadiiSquared DOC_TBA
 * 
 * @returns {vec3} DOC_TBA.
 */
vec3 agi_geodeticSurfaceNormal(vec3 positionOnEllipsoid, vec3 ellipsoidCenter, vec3 oneOverEllipsoidRadiiSquared)
{
    return normalize((positionOnEllipsoid - ellipsoidCenter) * oneOverEllipsoidRadiiSquared);
}

/**
 * DOC_TBA
 *
 * @name agi_ellipsoidWgs84TextureCoordinates
 * @glslFunction
 */
vec2 agi_ellipsoidWgs84TextureCoordinates(vec3 normal)
{
    return vec2(atan(normal.y, normal.x) * agi_oneOverTwoPi + 0.5, asin(normal.z) * agi_oneOverPi + 0.5);
}

/**
 * Determines if a position on or near the surface of an ellipsoid is on the ellipsoid's 
 * back-face from the perspective of the viewer.  This is used to avoid z-fighting between 
 * vector data (polylines, polygons, billboards, etc.) on the surface and the ellipsoid itself.
 * <br /><br />
 * It assumes the ellipsoid's center is <code>(0, 0, 0)</code> in world coordinates.
 * <br /><br />
 * <code>oneOverEllipsoidRadiiSquared</code> is usually provided by a uniform variable, whose
 * value is computed in JavaScript using {@link Ellipsoid#getOneOverRadiiSquared}.
 *
 * @name agi_isBackFacing
 * @glslFunction
 *
 * @param {vec3} positionOnEllipsoidEC The surface position on the ellipsoid in eye coordinates. 
 * @param {vec3} oneOverEllipsoidRadiiSquared The reciprocal of the ellipsoid's squared radii.
 *
 * @returns {bool} <code>true</code> if the position is on the back-face of the ellipsoid; otherwise, <code>false</code>.
 *
 * @see Ellipsoid#getOneOverRadiiSquared
 *
 * @example
 * // discard fragment if it is back-facing
 * if (agi_isBackFacing(positionEC, oneOverEllipsoidRadiiSquared))
 * {
 *   discard;
 * }
 */
bool agi_isBackFacing(vec3 positionOnEllipsoidEC, vec3 oneOverEllipsoidRadiiSquared)
{
    // If the position is assumed to be on or near the surface, avoid z-fighting with
    // the ellipsoid by computing the position's geodetic surface normal, and
    // essentially use it for back face culling.
    if (oneOverEllipsoidRadiiSquared != vec3(0.0))
    {
        vec3 n = agi_geodeticSurfaceNormal(positionOnEllipsoidEC, agi_view[3].xyz, oneOverEllipsoidRadiiSquared);
        return (dot(normalize(positionOnEllipsoidEC), n) > 0.0);
    }
    
    return false;
}
    
/**
 * Computes a 3x3 rotation matrix that transforms vectors from an ellipsoid's east-north-up coordinate system 
 * to eye coordinates.  In east-north-up coordinates, x points east, y points north, and z points along the 
 * surface normal.  East-north-up can be used as an ellipsoid's tangent space for operations such as bump mapping.
 * <br /><br />
 * The ellipsoid is assumed to be centered at the model coordinate's origin.
 *
 * @name agi_eastNorthUpToEyeCoordinates
 * @glslFunction
 *
 * @param {vec3} positionMC The position on the ellipsoid in model coordinates.
 * @param {vec3} normalEC The normalized ellipsoid surface normal, at <code>positionMC</code>, in eye coordinates.
 *
 * @returns {mat3} A 3x3 rotation matrix that transforms vectors from the east-north-up coordinate system to eye coordinates.
 *
 * @example
 * // Transform a vector defined in the east-north-up coordinate 
 * // system, (0, 0, 1) which is the surface normal, to eye 
 * // coordinates.
 * mat3 m = agi_eastNorthUpToEyeCoordinates(positionMC, normalEC);
 * vec3 normalEC = m * vec3(0.0, 0.0, 1.0);
 */
mat3 agi_eastNorthUpToEyeCoordinates(vec3 positionMC, vec3 normalEC)
{
    vec3 tangentMC = normalize(vec3(-positionMC.y, positionMC.x, 0.0));  // normalized surface tangent in model coordinates
    vec3 tangentEC = normalize(agi_normal * tangentMC);                  // normalized surface tangent in eye coordiantes
    vec3 bitangentEC = normalize(cross(normalEC, tangentEC));            // normalized surface bitangent in eye coordinates

    return mat3(
        tangentEC.x,   tangentEC.y,   tangentEC.z,
        bitangentEC.x, bitangentEC.y, bitangentEC.z,
        normalEC.x,    normalEC.y,    normalEC.z);
}

///////////////////////////////////////////////////////////////////////////////

/**
 * DOC_TBA
 *
 * @name agi_lightIntensity
 * @glslFunction
 */
float agi_lightIntensity(vec3 normal, vec3 toLight, vec3 toEye)
{
    // TODO: where does this come from?
    vec4 diffuseSpecularAmbientShininess = vec4(0.8, 0.1, 0.1, 10.0);
    
    vec3 toReflectedLight = reflect(-toLight, normal);

    float diffuse = max(dot(toLight, normal), 0.0);
    float specular = max(dot(toReflectedLight, toEye), 0.0);
    specular = pow(specular, diffuseSpecularAmbientShininess.w);

    return (diffuseSpecularAmbientShininess.x * diffuse) +
           (diffuseSpecularAmbientShininess.y * specular) +
            diffuseSpecularAmbientShininess.z;
}

/**
 * DOC_TBA
 *
 * @name agi_twoSidedLightIntensity
 * @glslFunction
 */
float agi_twoSidedLightIntensity(vec3 normal, vec3 toLight, vec3 toEye)
{
    // TODO: This is temporary.
    vec4 diffuseSpecularAmbientShininess = vec4(0.8, 0.1, 0.1, 10.0);
    
    vec3 toReflectedLight = reflect(-toLight, normal);

    float diffuse = abs(dot(toLight, normal));
    float specular = abs(dot(toReflectedLight, toEye));
    specular = pow(specular, diffuseSpecularAmbientShininess.w);

    return (diffuseSpecularAmbientShininess.x * diffuse) +
           (diffuseSpecularAmbientShininess.y * specular) +
            diffuseSpecularAmbientShininess.z;
}

/**
 * DOC_TBA
 *
 * @name agi_multiplyWithColorBalance
 * @glslFunction
 */
vec3 agi_multiplyWithColorBalance(vec3 left, vec3 right)
{
    // Algorithm from Chapter 10 of Graphics Shaders.
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    
    vec3 target = left * right;
    float leftLuminance = dot(left, W);
    float rightLumiance = dot(right, W);
    float targetLumiance = dot(target, W);
    
    return ((leftLuminance + rightLumiance) / (2.0 * targetLumiance)) * target;
}

///////////////////////////////////////////////////////////////////////////////

/**
 * DOC_TBA
 *
 * @name agi_columbusViewMorph
 * @glslFunction
 */
vec4 agi_columbusViewMorph(vec3 position2D, vec3 position3D, float time)
{
    // Just linear for now.
    vec3 p = mix(position2D, position3D, time);
    return vec4(p, 1.0);
} 