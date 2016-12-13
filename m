From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:19 +0800
Subject: [Ocfs2-devel] [PATCH 01/17] ocfs2 test: correct the check on
	testcase if supported
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-2-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/python_common/multiple_run.sh   | 2 +-
 programs/python_common/single_run-WIP.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index dd9603f..c4a7da9 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -201,7 +201,7 @@ f_setup()
 	fi
 
 	SUPPORTED_TESTCASES="all xattr inline reflink write_append_truncate multi_mmap create_racer flock_unit cross_delete open_delete lvb_torture"
-	for cas in ${TESTCASES}; do
+	for cas in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 		echo ${SUPPORTED_TESTCASES} | grep -sqw $cas
 		if [ $? -ne 0 ]; then
 			echo "testcase [${cas}] not supported."
diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
index 5a8fae1..fe0056c 100755
--- a/programs/python_common/single_run-WIP.sh
+++ b/programs/python_common/single_run-WIP.sh
@@ -997,7 +997,7 @@ fi
 SUPPORTED_TESTCASES="all create_and_open directaio fillverifyholes renamewriterace aiostress\
   filesizelimits mmaptruncate buildkernel splice sendfile mmap reserve_space inline xattr\
   reflink mkfs tunefs backup_super filecheck"
-for cas in ${TESTCASES}; do
+for cas in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 	echo ${SUPPORTED_TESTCASES} | grep -sqw $cas
 	if [ $? -ne 0 ]; then
 		echo "testcase [${cas}] not supported."
-- 
2.6.6
