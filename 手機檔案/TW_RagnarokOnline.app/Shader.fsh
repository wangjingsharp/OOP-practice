//
//  Shader.fsh
//  VioletGL
//
//  Created by 정규 김 on 10. 8. 3..
//  Copyright 오디아츠 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
