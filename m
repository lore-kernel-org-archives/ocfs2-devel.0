From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 24 Feb 2016 09:48:28 +0800
Subject: [Ocfs2-devel] ocfs2-test for v4.3 done
In-Reply-To: <20160219030124.GA4861@laptop.ha>
References: <56776B6B.2010208@oracle.com> <20151221135038.GA3194@laptop.ha>
	<5678B6AC.1080005@oracle.com> <20160216095411.GA8125@laptop.ha>
	<56C3D7DC.2030403@oracle.com> <20160219030124.GA4861@laptop.ha>
Message-ID: <56CD0BEC.6040900@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

On 02/19/2016 11:01 AM, Eric Ren wrote:
> Hi Junxiao,
> 
> On Wed, Feb 17, 2016 at 10:15:56AM +0800, Junxiao Bi wrote: 
>> Hi Eric,
>>
>> I remember i described it before, please search it on ocfs2-devel. For
>> ocfs2 env setup, please refer to README in ocfs2-test.
> 
> Yes, you did. Actually, it's the  quoted paragraph below;-)
> Thanks, but more things what I really want to learn about are, such as:
> 1. git hook/auto control scripts, if it's OK to share;
Sure. Attached.
> 2. pain point and solution, for example, a latest tagged release kernel may
>    not compile successfully by `make defconfig` or `cp /boot/config-`uname -r``;
>    Or cannot boot up even if we've built kernel RPM and installed it.
That maybe because some config not enabled for your platform. I used xen
vm as test nodes, and use make xenconfig to generate .config and it
works well.

There are two pain points for this test framework:
1. auto bisect to spot regression issue.
2. improve ocfs2-test speed.
Now it needs several days to done the test. Better split the test as
function test and stress test.

Please think about it when build your test framework.

Thanks,
Junxiao.
> 
>    Did you have this problem? Any suggestion;-) What I can think of is to try opensuse
>    tumbleweed distribution(a rolling release).
> 
>>
>> On 02/16/2016 05:54 PM, Eric Ren wrote:
>>> Hi Junxiao,
>>>
>>>> Four vm are used, one for git server, and the other three to build
>>>> kernel and run ocfs2 test. Tag a branch and push it to the git server,
>>>> the test will be started. The test cases to run can be set in tag message.
>>>
>>> Recently, I get free days and also want to setup automatic testing env for ocfs2.
>>> I'll use pcmk as cluster stack while you probably use o2cb. I think we can complement
>>> each other.  May I bother you to describe the work flow more specifically, or share
>>> experiences and references? That way it would save my life;-)
>>>
> Thanks!
> Eric
> 

-------------- next part --------------
#!/bin/sh
#
# An example hook script to prepare a packed repository for use over
# dumb transports.
#
# To enable this hook, rename this file to "post-update".

#exec git update-server-info

function parse_tag() {
	tag=`git tag -n1 -l $tag_name | awk '{print $2}'`
	echo $tag | grep -sq $BUILD_TAG
	if [ $? -eq 0 ]; then
		command=1
	fi

	echo $tag | grep -sq $TEST_TAG
	if [ $? -eq 0 ]; then
		echo $tag | grep -sq $TESTONLY_TAG
		if [ $? -eq 0 ]; then
			command=3
			cases=`echo $tag | sed "s:^${TESTONLY_TAG}-::"`
		else
			command=2
			cases=`echo $tag | sed "s:^${TEST_TAG}-::"`
		fi

		if [ X"$cases" = X"$tag" ];then
			cases="all"
		fi

		for cas in `echo $cases | sed "s:,: :g"`; do
			echo $USERDEF_TESTCASES " " $SINGLE_TESTCASES " " $MULTIPLE_TESTCASES | grep -sqw $cas
			if [ $? -ne 0 ]; then
				echo "error, testcase [${cas}] not supported."
				echo "The following testcases are supported:"
				echo "user defined testcases: $USERDEF_TESTCASES"
				echo "single testcases:  $SINGLE_TESTCASES"
				echo "multiple testcases: $MULTIPLE_TESTCASES"
				exit 1
			else
				testcase=${testcase}" "${cas}
			fi
		done

		if [ -z "$testcase" ]; then
			exit 1
		fi
	fi

	if [ $command -eq 0 ]; then
		exit 0
	elif [ $command -eq 1 ];then
		echo "command: build $version"
	elif [ $command -eq 2 ]; then
		echo "command: test $version"
		echo "testcase: $testcase"
	else
		echo "command: testonly"
		echo "testcase: $testcase"
	fi
}

function build_kernel() {
	echo "archive tag: $tag_name to ${version}.tar"
	git archive --prefix=${version}/ $tag_name > /tmp/${version}.tar
	echo "copy ${version}.tar to $BUILD_SERVER:$BUILD_PATH"
	scp /tmp/${version}.tar root@${BUILD_SERVER}:${BUILD_PATH} && rm -rf /tmp/${version}.tar
	echo "untar ${version}.tar on build server"
	$REMOTE_BUILD "tar xf ${BUILD_PATH}/${version}.tar -C ${BUILD_PATH} && rm -rf ${BUILD_PATH}/${version}.tar"

	echo "building, please wait"
	scp /repo/mainline.git/hooks/ocfs2.config root@${BUILD_SERVER}:/tmp
	$REMOTE_BUILD "cd $build_dir; make mrproper > /dev/null; \
		make defconfig >> ${build_dir}/build.log; \
		cat /tmp/ocfs2.config >> ${build_dir}/.config; \
	    	make xenconfig >> ${build_dir}/build.log; \
		make binrpm-pkg >> ${build_dir}/build.log;"
}

function install_kernel() {
	echo "copy kernel to test server $1:/tmp"
	scp /tmp/${version}.rpm root@$1:/tmp
	if [ $? -ne 0 ]; then
		echo "copy to server $1 failed."
		exit 1
	fi

	echo "install kernel to test server $1."
	ret=`ssh root@$1 "rpm -ivh --force /tmp/${version}.rpm &> /dev/null; echo $?"`
	if [ $ret -ne 0 ];then
		echo "install kernel to $1 failed $ret."
		exit 1;
	fi

	# update grub to boot the new install kernel by default
	ssh root@$1 "rm -f /boot/grub/grub.conf.orig; \
		mv /boot/grub/grub.conf /boot/grub/grub.conf.orig; \
		sed 's/^default=.*$/default=0/' /boot/grub/grub.conf.orig > /boot/grub/grub.conf; \
		rm -rf /tmp/${version}.rpm"
}

function exit_error() {
	if [ $1 -ne 0 ];then
		echo "ocfs2 $2 test case [ $3 ] failed."
		exit $1
	fi
}

function run_single_testcase() {
	umount_testdev $test_dev
	$REMOTE_TEST "cd ${exe_dir}; $single_test -m $mntdir -l $logdir \
		-d $test_dev -k $kernelsrc -t $1"
	exit_error $? "single" "$1"
}

function run_multiple_testcase() {
	umount_testdev $test_dev
	$REMOTE_TEST "cd ${exe_dir}; $multi_test -n ${TEST_SERVER_LIST} \
		-d $test_dev -o $logdir -k $kernelsrc -t $1 $mntdir"
	exit_error $? "multiple" "$1"
}

function run_discontig_testcase() {
	umount_testdev $test_dev
	echo "discontig multi node test start."
	$REMOTE_TEST "cd ${exe_dir}; $discontig_test -m ${TEST_SERVER_LIST} \
		-d $test_dev -o $logdir $mntdir"
	exit_error $? "discontig" "multiple"
	echo "discontig multi node test done."

	echo "discontig single node test start."
	$REMOTE_TEST "cd ${exe_dir}; $discontig_test -d $test_dev -o $logdir $mntdir"
	exit_error $? "discontig" "single"
	echo "discontig single node test done."

}

function umount_testdev()
{
	ssh root@${ML_TEST_SERVER1} "mount | grep -sq $1 && umount $1 &> /dev/null"
	ssh root@${ML_TEST_SERVER2} "mount | grep -sq $1 && umount $1 &> /dev/null"
	ssh root@${ML_TEST_SERVER3} "mount | grep -sq $1 && umount $1 &> /dev/null"
}

BUILD_SERVER=mainline-test1.cn.oracle.com
ML_TEST_SERVER1=mainline-test1.cn.oracle.com
ML_TEST_SERVER2=mainline-test2.cn.oracle.com
ML_TEST_SERVER3=mainline-test3.cn.oracle.com
REMOTE_BUILD="ssh root@${BUILD_SERVER}"
RPMBUILD_PATH=/root/rpmbuild
BUILD_PATH=${RPMBUILD_PATH}/build
BIN_PATH=${RPMBUILD_PATH}/rpms/x86_64
PROD=ML
BUILD_TAG=${PROD}build
TEST_TAG=${PROD}test
TESTONLY_TAG=${TEST_TAG}only
command=0

USERDEF_TESTCASES="all single multiple discontig"
SINGLE_TESTCASES="all create_and_open directaio fillverifyholes renamewriterace aiostress\
  filesizelimits mmaptruncate buildkernel splice sendfile mmap reserve_space inline xattr reflink mkfs tunefs backup_super"
MULTIPLE_TESTCASES="all xattr inline reflink write_append_truncate multi_mmap create_racer flock_unit cross_delete open_delete lvb_torture"
testcase=""

# skip any non-tag push
refname="$1"
echo $refname | grep -sq 'tags'
if [ $? -eq 0 ];then
	tag_name=${refname##refs/tags/}
else
	exit 0
fi

# this update is to remove tag, ignore
tag=`git tag -l $tag_name`
if [ -z "$tag" ]; then
	exit 0
fi
echo pushing tag: $tag.

version=`git tag -n1 -l $tag_name | awk '{print $3}'`

# parse tag to see what to do, build, test or testonly? "command" and "testcase" will be set
parse_tag

# build and install kernel if command is not "testonly"
if [ $command -ne 3 ]; then
	# build kernel
	build_dir=${BUILD_PATH}/${version}
	build_kernel

	# get kernel rpm package path from build log.
	bin=$($REMOTE_BUILD "tail -n 10 ${build_dir}/build.log | grep  kernel-.*.rpm | grep -v kernel-headers | awk '{print \$2}'")
	if [ -z "$bin" ]; then
		echo "build fail"
		exit 1
	fi
	echo "build success. get kernel at root@${BUILD_SERVER}:${bin}."

	if [ $command -eq 1 ];then
		exit 0
	fi

	# install kernel
	scp root@${BUILD_SERVER}:$bin /tmp/${version}.rpm
	if [ $? -ne 0 ]; then
		echo "copy from server $BUILD_SERVER failed."
		exit 1
	fi
		
	install_kernel ${ML_TEST_SERVER1}
	install_kernel ${ML_TEST_SERVER2}
	install_kernel ${ML_TEST_SERVER3}

	rm -rf /tmp/${version}.rpm

	echo "reboot test server to new kernel"
	ssh root@${ML_TEST_SERVER1} 'reboot'
	ssh root@${ML_TEST_SERVER2} 'reboot'
	ssh root@${ML_TEST_SERVER3} 'reboot'
	echo "wait 200s to reboot"
	sleep 200
fi

exe_dir=/home/test/bin/ocfs2/bin/
single_test=./single_run-WIP.sh
multi_test=./multiple_run.sh
discontig_test=./discontig_runner.sh
baselogdir=/home/test/ocfs2_test/log
kernelsrc=/home/test/ocfs2_test/linux-kernel.tar.gz
mntdir=/ocfs2_vol
test_dev=/dev/sda
REMOTE_TEST="ssh test@${ML_TEST_SERVER1}"
TEST_SERVER_LIST="mainline-test1,mainline-test2,mainline-test3"

logdir=${baselogdir}/${tag_name}-`date +%y-%m-%d-%H-%M`
$REMOTE_TEST "if [ ! -d "$logdir" ]; then mkdir $logdir; fi"

single_run=0
multiple_run=0
for cas in $testcase; do
	if [ "$cas"X = "multiple"X -o "$cas"X = "all"X ]; then
		echo "ocfs2 multi node test start."
		run_multiple_testcase "all"
		echo "ocfs2 multi node test done."
		multiple_run=1
	fi

	if [ "$cas"X = "single"X -o "$cas"X = "all"X ]; then
		echo "ocfs2 single node test start."
		run_single_testcase "all"
		echo "ocfs2 single node test done."
		single_run=1
	fi

	#if [ "$cas"X = "discontig"X -o "$cas"X = "all"X ]; then
	if [ "$cas"X = "discontig"X ]; then
		echo "ocfs2 discontig test start."
		run_discontig_testcase
		echo "ocfs2 discontig test done."
	fi

	if [ $multiple_run -eq 0 ]; then
		echo $MULTIPLE_TESTCASES | grep -sqw $cas
		if [ $? -eq 0 ]; then
			echo "ocfs2 multiple [${cas}] test start."
			run_multiple_testcase "$cas"
			echo "ocfs2 multiple [${cas}] test done."
		fi
	fi

	if [ $single_run -eq 0 ]; then
		echo $SINGLE_TESTCASES | grep -sqw $cas
		if [ $? -eq 0 ]; then
			echo "ocfs2 single [${cas}] test start."
			run_single_testcase "$cas"
			echo "ocfs2 single [${cas}] test done."
		fi
	fi
done

echo "test done, checking log at test@${ML_TEST_SERVER1}:${logdir}"
