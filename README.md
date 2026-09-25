# mobile-openjdk8-build-multiarch

Based on http://openjdk.java.net/projects/mobile/android.html

## Building 

### Setup
- **Warning**: Do not attempt to build use newer or older NDK, it will lead to compilation errors.

### Platform and architecture specific environment variables
<table>
      <thead>
        <tr>
          <th></th>
          <th align="center" colspan="7">Environment variables</th>
        </tr>
        <tr>
          <th>Platform - Architecture</th>
          <th align="center">TARGET</th>
          <th align="center">TARGET_JDK</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Android - armv8/aarch64</td>
          <td align="center">aarch64-linux-android</td>
          <td align="center">aarch64</td>
        </tr>
        <tr>
          <td>Android - armv7/aarch32</td>
          <td align="center">arm-linux-androideabi</td>
          <td align="center">arm</td>
        </tr>
        <tr>
          <td>Android - x86/i686</td>
          <td align="center">i686-linux-android</td>
          <td align="center">x86</td>
        </tr>
        <tr>
          <td>Android - x86_64/amd64</td>
          <td align="center">x86_64-linux-android</td>
          <td align="center">x86_64</td>
        </tr>
      </tbody>
	</table>

### Run in this directory:
```
export BUILD_FREETYPE_VERSION=[2.6.2/.../2.10.4] # default: 2.13.3
export JDK_DEBUG_LEVEL=[release/fastdebug/debug] # default: release
export JVM_VARIANTS=[client/server] # default: client (aarch32), server (other architectures)

# Setup, choose an architecture to compile and run it just once

# armv7 32-bit / aarch32
./ci_build_arch_aarch32.sh

# arm64 / aarch64
./ci_build_arch_aarch64.sh

# x86_64
./ci_build_arch_x86_64.sh

# x86 32-bit
./ci_build_arch_x86.sh
```

