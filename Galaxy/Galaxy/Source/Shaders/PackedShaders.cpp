// Generated code

#if !DEBUG
#include "Shaders/ShaderProvider/ShaderProvider.h"
const string ShaderProvider::UnpackCode(const uint32_t& h) {
switch (h) {
case 1939412094: return "#version 460 core\nin vec2 fragmentTextureCoords;uniform sampler2D dataTexture;out vec4 color;void main(){color=texture(dataTexture,fragmentTextureCoords);}";
case 776390504: return "#version 460 core\nin vec4 position;in vec2 vertexTextureCoords;out vec2 fragmentTextureCoords;void main(){gl_Position=position;fragmentTextureCoords=vertexTextureCoords;}";
case 1285147531: return "#version 460 core\nlayout(local_size_x=8,local_size_y=8,local_size_z=1)in;uniform uint seed;uniform ivec2 size;layout(rgba32f)restrict uniform image2D dataTexture;uint b(uint h){h^=2747636419;h*=2654435769;h^=h>>16;h*=seed+1;h*=2654435769;h^=h>>16;h*=2654435769;return h;}vec3 c(ivec2 j){vec3 k;for(int y=-1;y<2;y++){for(int x=-1;x<2;x++){ivec2 l=ivec2(j.x+x,j.y+y);k+=vec3(imageLoad(dataTexture,l));}}return k/9.;}void d(ivec2 m,uint n){vec3 p;for(int i=0;i<p.length();i++){n=b(n);p[i]=n/4294967295.;}imageStore(dataTexture,m,vec4(p,1));}void g(ivec2 q){vec3 r=vec3(1);vec3 s=c(q);if(s.x+s.y+s.z<2.25){for(int i=0;i<r.length();i++)r[i]=s[i]>.9?1.05:1.0005;}imageStore(dataTexture,q,vec4(s*r,1));}void main(){ivec2 t=ivec2(gl_GlobalInvocationID.xy);if(t.x>=size.x||t.y>=size.y)return;uint v=b(t.y*size.x+t.x);bool w=v<20000000;if(w)d(t,v);else\ng(t);}";
default: return ""; }}
#endif
