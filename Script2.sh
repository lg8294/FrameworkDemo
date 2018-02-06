#!/bin/sh

#  Script2.sh
#  FrameworkDemo
#
#  Created by iOS on 2018/2/6.
#  Copyright © 2018年 lg. All rights reserved.

# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME
# 例如: FMK_NAME = "MyFramework"
FMK_NAME="StaticFrameworkDemo"
#SOCKET_FMK_NAME="SocketIO"

# 自定义输出路径
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
#SOCKET_INSTALL_DIR=${SRCROOT}/Products/${SOCKET_FMK_NAME}.framework

#命令行编译默认输出路径
WRK_DIR=build

#真机发布版本路径
DEVICE_RELEASE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
#SOCKET_DEVICE_RELEASE_DIR=${WRK_DIR}/Release-iphoneos/${SOCKET_FMK_NAME}.framework

#模拟器发布版本路径
SIMULATOR_RELEASE_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework
#SOCKET_SIMULATOR_RELEASE_DIR=${WRK_DIR}/Release-iphonesimulator/${SOCKET_FMK_NAME}.framework

# 清理工程并编译
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos ONLY_ACTIVE_ARCH=NO clean build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO clean build

# Cleaning the oldest.
#删除自定义的输出文件夹
if [ -d "${INSTALL_DIR}" ] #判断是否是文件，如果不存在返回false
then
rm -rf "${INSTALL_DIR}"
fi

#if [ -d "${SOCKET_INSTALL_DIR}" ] #判断是否是文件，如果不存在返回false
#then
#rm -rf "${SOCKET_INSTALL_DIR}"
#fi

#创建自定义的输出文件夹
mkdir -p "${INSTALL_DIR}" #-p参数可以确保各个创建成功，即使指定的路径不存在也会逐层创建
#mkdir -p "${SOCKET_INSTALL_DIR}"

#拷贝真机发布版本到自定义输出路径
cp -R "${DEVICE_RELEASE_DIR}/" "${INSTALL_DIR}/"
cp -R "${SOCKET_DEVICE_RELEASE_DIR}/" "${SOCKET_INSTALL_DIR}/"

#使用Lipo工具合并真机发布版本和模拟器发布版本并输出到自定义文件夹
lipo -create "${DEVICE_RELEASE_DIR}/${FMK_NAME}" "${SIMULATOR_RELEASE_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
#lipo -create "${SOCKET_DEVICE_RELEASE_DIR}/${SOCKET_FMK_NAME}" "${SOCKET_SIMULATOR_RELEASE_DIR}/${SOCKET_FMK_NAME}" -output "${SOCKET_INSTALL_DIR}/${SOCKET_FMK_NAME}"

#打开自定义输出文件夹
open "${SRCROOT}/Products/"

#删除默认输出文件夹
rm -r "${WRK_DIR}" #这里有时会由于库文件还没有合并完成就删除了原始库，导致合并失败

