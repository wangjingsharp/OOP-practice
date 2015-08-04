//
//  Shader.vsh
//  VioletGL
//
//  Created by 정규 김 on 10. 8. 3..
//  Copyright 오디아츠 2010. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
