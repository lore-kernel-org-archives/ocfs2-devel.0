From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:33 +0800
Subject: [Ocfs2-devel] [PATCH 15/17] Handle the case when a symbolic link
	device is given
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-16-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's a usual case that the shared disk is given in symbolic
name, like iscsi disk "/dev/disk/by-path/disk". So work out
the typical device name in such case.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/discontig_bg_test/discontig_runner.sh |  5 +++++
 programs/python_common/multiple_run.sh         | 13 +++++++++++++
 programs/python_common/single_run-WIP.sh       |  6 ++++++
 3 files changed, 24 insertions(+)

diff --git a/programs/discontig_bg_test/discontig_runner.sh b/programs/discontig_bg_test/discontig_runner.sh
index 4c13adb..182ca3a 100755
--- a/programs/discontig_bg_test/discontig_runner.sh
+++ b/programs/discontig_bg_test/discontig_runner.sh
@@ -126,6 +126,11 @@ function f_setup()
 	if [ -z "${DEVICE}" ];then
 		f_usage
 	fi	
+
+	# if a symbollink is given, work out the typical device name, like /dev/sda
+	if [ -L ${DEVICE} ];then
+		DEVICE=`readlink -f ${DEVICE}`
+	fi
 	
 	if [ -z "${MOUNT_POINT}" ];then
 		f_usage
diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index 74c3531..3e11abd 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -135,6 +135,19 @@ f_setup()
 
 	f_getoptions $*
 
+	if [ -z ${DEVICE} ] ; then
+		${ECHO} "ERROR: No device"
+		f_usage
+	elif [ ! -b ${DEVICE} ] ; then
+		${ECHO} "ERROR: Invalid device ${DEVICE}"
+		exit 1
+	fi
+
+	# if a symbollink is given, work out the typical device name, like /dev/sda
+	if [ -L ${DEVICE} ];then
+		 DEVICE=`readlink -f ${DEVICE}`
+	fi
+
 	if [ -z "${MOUNT_POINT}" ];then
                 f_usage
         fi
diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
index 5c174f0..92d1216 100755
--- a/programs/python_common/single_run-WIP.sh
+++ b/programs/python_common/single_run-WIP.sh
@@ -1095,6 +1095,7 @@ do
     		?) usage;;
   	esac
 done
+
 if [ -z ${DEVICE} ] ; then
 	${ECHO} "ERROR: No device"
 	usage
@@ -1103,6 +1104,11 @@ elif [ ! -b ${DEVICE} ] ; then
 	exit 1
 fi
 
+# if a symbollink is given, work out the typical device name, like /dev/sda
+if [ -L ${DEVICE} ];then
+	DEVICE=`readlink -f ${DEVICE}`
+fi
+
 if [ -z ${MOUNTPOINT} ] ; then
 	${ECHO} "ERROR: No mountpoint"
 	usage
-- 
2.6.6
