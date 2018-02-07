# FrameworkDemo

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## 支持 Cartage 的库工程

在工程中建立 Framework 类型的 Target，然后在 `Manage schemes` 中配置为 share，就可以通过 Carthage 来集成动态 Framework 了。

## 通过 Carthage 集成动态 Framework

1. 在需要集成库的工程中配置 Cartfile 文件；
2. 执行 `carthage update`；

## 通过 Carthage 集成静态 Framework

Carthage 默认只支持集成动态 Framework。
通过替换 .o 文件 Link 过程中的 LD 命令，可以实现制作静态 Framework。

1. 在需要集成库的工程中配置 Cartfile 文件；
2. 添加 `ld.py` 文件，添加内容如下：
    
    ```py
    #!/usr/bin/env python

    import argparse
    import subprocess

    def ld_command(arch, isysroot, filelist, output):
        return [
                "libtool",
                "-static",
                "-arch_only", arch,
                "-syslibroot", isysroot,
                "-filelist", filelist,
                "-o", output,
                ]


    def build_parser():
        parser = argparse.ArgumentParser()
        parser.add_argument("-arch", required=True)
        parser.add_argument("-isysroot", required=True)
        parser.add_argument("-filelist", required=True)
        parser.add_argument("-o", dest="output", required=True)
        return parser

    if __name__ == "__main__":
        arguments, _ = build_parser().parse_known_args()
        command = ld_command(arguments.arch, arguments.isysroot,arguments.filelist, arguments.output)
        print(" ".join(command))
        print(subprocess.check_output(command))
    ```
    
    添加执行权限，`chmod +x ld.py`；
    
2. 新建 `carthage-build-static.sh` 文件，添加内容如下：

    ```sh
    #!/bin/sh -e
    
    xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
    trap 'rm -f "$xcconfig"' INT TERM HUP EXIT
    
    echo "LD = <path to ld.py>" >> $xcconfig
    echo "DEBUG_INFORMATION_FORMAT = dwarf" >> $xcconfig
    
    export XCODE_XCCONFIG_FILE="$xcconfig"
    
    carthage build "$@"
    ```
    
    添加执行权限，`chmod +x carthage-build-static.sh`；
    
3. 执行 `carthage-build-static.sh`；

## 其他

Carthage 中默认生成的 Framework 中不包含 armv7s 架构，为了生成包含 armv7s 架构，可以在 Framework 工程中的 buildsetting->Architectures->Architectures 中选择 other，添加 armv7s。这样通过 Carthage 生成的 Framework 中就包含了 armv7s 架构。


