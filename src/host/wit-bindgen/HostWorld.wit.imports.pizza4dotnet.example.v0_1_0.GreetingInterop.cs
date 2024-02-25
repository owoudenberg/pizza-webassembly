// Generated by `wit-bindgen` 0.19.1. DO NOT EDIT!
using System;
using System.Runtime.CompilerServices;
using System.Collections;
using System.Runtime.InteropServices;
using System.Text;
using System.Diagnostics;

namespace HostWorld.wit.imports.pizza4dotnet.example.v0_1_0
{
    public static class GreetingInterop {
        
        internal static class GreetWasmInterop
        {
            [DllImport("pizza4dotnet:example/greeting@0.1.0", EntryPoint = "greet"), WasmImportLinkage]
            internal static extern void wasmImportGreet(int p0, int p1, int p2);
        }
        
        internal static unsafe string Greet(string name)
        {
            
            var result = name;
            IntPtr interopString = InteropString.FromString(result, out int lengthresult);
            
            void* buffer = stackalloc int[8 + 4 - 1];
            var ptr = ((int)buffer) + (4 - 1) & -4;
            GreetWasmInterop.wasmImportGreet(interopString.ToInt32(), lengthresult, ptr);
            return ReturnArea.GetUTF8String(ptr);
            
            //TODO: free alloc handle (interopString) if exists
        }
        
        private unsafe struct ReturnArea
        {
            public static byte GetU8(IntPtr ptr)
            {
                var span = new Span<byte>((void*)ptr, 1);
                
                return span[0];
            }
            
            public static ushort GetU16(IntPtr ptr)
            {
                var span = new Span<byte>((void*)ptr, 2);
                
                return BitConverter.ToUInt16(span);
            }
            
            public static int GetS32(IntPtr ptr)
            {
                var span = new Span<byte>((void*)ptr, 4);
                
                return BitConverter.ToInt32(span);
            }
            
            internal static float GetF32(IntPtr ptr, int offset)
            {
                var span = new Span<byte>((void*)ptr, 4);
                return BitConverter.ToSingle(span.Slice(offset, 4));
            }
            
            public static string GetUTF8String(IntPtr ptr)
            {
                return Encoding.UTF8.GetString((byte*)GetS32(ptr), GetS32(ptr + 4));
            }
            
        }
        
    }
}
