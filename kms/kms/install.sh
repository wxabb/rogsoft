#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/kms* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/kms* >/dev/null 2>&1
		exit 1
	;;
esac

# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/kms.sh stop
fi

# 安装插件
cp -rf /tmp/kms/scripts/* /koolshare/scripts/
cp -rf /tmp/kms/bin/* /koolshare/bin/
cp -rf /tmp/kms/webs/* /koolshare/webs/
cp -rf /tmp/kms/res/* /koolshare/res/
chmod +x /koolshare/scripts/kms*
chmod +x /koolshare/bin/vlmcsd

# 离线安装用
dbus set kms_version="$(cat $DIR/version)"
dbus set softcenter_module_kms_version="$(cat $DIR/version)"
dbus set softcenter_module_kms_install="1"
dbus set softcenter_module_kms_name="kms"
dbus set softcenter_module_kms_title="系统工具"
dbus set softcenter_module_kms_description="kms"

# re-enable kms
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/kms.sh start
fi

# 完成
echo_date "kms插件安装完毕！"
rm -rf /tmp/kms* >/dev/null 2>&1
exit 0
