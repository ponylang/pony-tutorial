use @eglChooseConfig[U32](disp: Pointer[_EGLDisplayHandle], attrs: Pointer[U16] tag,
  config: Pointer[_EGLConfigHandle], config_size: U32, num_config: Pointer[U32])

primitive _EGLConfigHandle
let a = Array[U16](8)
a.push(0x3040)
a.push(0x4)
a.push(0x3033)
a.push(0x4)
a.push(0x3022)
a.push(0x8)
a.push(0x3023)
a.push(0x8)
a.push(0x3024)
let config = Pointer[_EGLConfigHandle]
if @eglChooseConfig(e_dpy, a.cpointer(), config, U32(1), Pointer[U32]) == 0 then
    env.out.print("eglChooseConfig failed")
end