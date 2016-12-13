From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:21 +0800
Subject: [Ocfs2-devel] [PATCH 03/17] Trivial: better not to depend on where
	we issue testing
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-4-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If we issue testing outsides directory where executives
are, error likes the below may occur:
    "./config.sh No such file or directory".
So let's depend on PATH environment rather that.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/dirop_fileop_racer/racer.sh               | 48 +++++++++++-----------
 programs/dx_dirs_tests/index_dir_run.sh            |  2 +-
 programs/dx_dirs_tests/multi_index_dir_run.sh      |  2 +-
 programs/inline-data/multi-inline-run.sh           |  2 +-
 programs/inline-data/single-inline-run.sh          |  2 +-
 .../inode_alloc_perf_tests/inode_alloc_perf.sh     |  2 +-
 .../multi_inode_alloc_perf.sh                      |  2 +-
 .../multi_inode_alloc_perf_runner.sh               |  2 +-
 .../iozone/iozone3_263/src/current/Generate_Graphs | 26 ++++++------
 programs/logwriter/enospc.sh                       |  2 +-
 programs/logwriter/rename_write_race.sh            |  2 +-
 programs/python_common/o2tf.sh                     |  2 +-
 programs/python_common/single_run-WIP.sh           |  4 +-
 programs/python_common/single_run.sh               |  2 +-
 .../tunefs-test/remove-slot/corrupt_remove_slot.sh |  2 +-
 programs/xattr_tests/xattr-multi-run.sh            |  2 +-
 programs/xattr_tests/xattr-single-run.sh           |  2 +-
 17 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/programs/dirop_fileop_racer/racer.sh b/programs/dirop_fileop_racer/racer.sh
index 819efa8..7e83b7a 100755
--- a/programs/dirop_fileop_racer/racer.sh
+++ b/programs/dirop_fileop_racer/racer.sh
@@ -37,37 +37,37 @@ DIR="race"
 #
 
 [ -e $DIR ] || mkdir $DIR
-./file_create.sh $DIR $MAX_FILES &
-./file_create.sh $DIR $MAX_FILES &
-./file_create.sh $DIR $MAX_FILES &
+file_create.sh $DIR $MAX_FILES &
+file_create.sh $DIR $MAX_FILES &
+file_create.sh $DIR $MAX_FILES &
 
-./dir_create.sh $DIR $MAX_FILES &
-./dir_create.sh $DIR $MAX_FILES &
-./dir_create.sh $DIR $MAX_FILES &
+dir_create.sh $DIR $MAX_FILES &
+dir_create.sh $DIR $MAX_FILES &
+dir_create.sh $DIR $MAX_FILES &
 
-./file_rename.sh $DIR $MAX_FILES &
-./file_rename.sh $DIR $MAX_FILES &
-./file_rename.sh $DIR $MAX_FILES &
+file_rename.sh $DIR $MAX_FILES &
+file_rename.sh $DIR $MAX_FILES &
+file_rename.sh $DIR $MAX_FILES &
 
-./file_link.sh $DIR $MAX_FILES &
-./file_link.sh $DIR $MAX_FILES &
-./file_link.sh $DIR $MAX_FILES &
+file_link.sh $DIR $MAX_FILES &
+file_link.sh $DIR $MAX_FILES &
+file_link.sh $DIR $MAX_FILES &
 
-./file_symlink.sh $DIR $MAX_FILES &
-./file_symlink.sh $DIR $MAX_FILES &
-./file_symlink.sh $DIR $MAX_FILES &
+file_symlink.sh $DIR $MAX_FILES &
+file_symlink.sh $DIR $MAX_FILES &
+file_symlink.sh $DIR $MAX_FILES &
 
-./file_concat.sh $DIR $MAX_FILES &
-./file_concat.sh $DIR $MAX_FILES &
-./file_concat.sh $DIR $MAX_FILES &
+file_concat.sh $DIR $MAX_FILES &
+file_concat.sh $DIR $MAX_FILES &
+file_concat.sh $DIR $MAX_FILES &
 
-./file_list.sh $DIR &
-./file_list.sh $DIR &
-./file_list.sh $DIR &
+file_list.sh $DIR &
+file_list.sh $DIR &
+file_list.sh $DIR &
 
-./file_rm.sh $DIR $MAX_FILES &
-./file_rm.sh $DIR $MAX_FILES &
-./file_rm.sh $DIR $MAX_FILES &
+file_rm.sh $DIR $MAX_FILES &
+file_rm.sh $DIR $MAX_FILES &
+file_rm.sh $DIR $MAX_FILES &
 
 echo "CTRL-C to exit"
 trap "
diff --git a/programs/dx_dirs_tests/index_dir_run.sh b/programs/dx_dirs_tests/index_dir_run.sh
index 381d144..bbd2fdc 100755
--- a/programs/dx_dirs_tests/index_dir_run.sh
+++ b/programs/dx_dirs_tests/index_dir_run.sh
@@ -43,7 +43,7 @@
 ################################################################################
 # Global Variables
 ################################################################################
-. ./o2tf.sh
+. `dirname ${0}`/o2tf.sh
 
 BLOCKSIZE=
 CLUSTERSIZE=
diff --git a/programs/dx_dirs_tests/multi_index_dir_run.sh b/programs/dx_dirs_tests/multi_index_dir_run.sh
index eb72a7d..c83b9f7 100755
--- a/programs/dx_dirs_tests/multi_index_dir_run.sh
+++ b/programs/dx_dirs_tests/multi_index_dir_run.sh
@@ -41,7 +41,7 @@
 ################################################################################
 # Global Variables
 ################################################################################
-. ./o2tf.sh
+. `dirname ${0}`/o2tf.sh
 
 BLOCKSIZE=
 CLUSTERSIZE=
diff --git a/programs/inline-data/multi-inline-run.sh b/programs/inline-data/multi-inline-run.sh
index 30e2e6a..1d51443 100755
--- a/programs/inline-data/multi-inline-run.sh
+++ b/programs/inline-data/multi-inline-run.sh
@@ -19,7 +19,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 #MPIRUN="`which mpirun`"
 
diff --git a/programs/inline-data/single-inline-run.sh b/programs/inline-data/single-inline-run.sh
index 938f461..5a176cd 100755
--- a/programs/inline-data/single-inline-run.sh
+++ b/programs/inline-data/single-inline-run.sh
@@ -19,7 +19,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 USERNAME=`id -un`
 GROUPNAME=`id -gn`
diff --git a/programs/inode_alloc_perf_tests/inode_alloc_perf.sh b/programs/inode_alloc_perf_tests/inode_alloc_perf.sh
index 2ca738a..c561bd2 100755
--- a/programs/inode_alloc_perf_tests/inode_alloc_perf.sh
+++ b/programs/inode_alloc_perf_tests/inode_alloc_perf.sh
@@ -33,7 +33,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 SUDO="`which sudo` -u root"
 RM_BIN="`which rm`"
diff --git a/programs/inode_alloc_perf_tests/multi_inode_alloc_perf.sh b/programs/inode_alloc_perf_tests/multi_inode_alloc_perf.sh
index c54e80f..45944a5 100755
--- a/programs/inode_alloc_perf_tests/multi_inode_alloc_perf.sh
+++ b/programs/inode_alloc_perf_tests/multi_inode_alloc_perf.sh
@@ -33,7 +33,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 #BINDIR=./
 
 SUDO="`which sudo` -u root"
diff --git a/programs/inode_alloc_perf_tests/multi_inode_alloc_perf_runner.sh b/programs/inode_alloc_perf_tests/multi_inode_alloc_perf_runner.sh
index 39265d9..ab82ced 100755
--- a/programs/inode_alloc_perf_tests/multi_inode_alloc_perf_runner.sh
+++ b/programs/inode_alloc_perf_tests/multi_inode_alloc_perf_runner.sh
@@ -31,7 +31,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 SUDO="`which sudo` -u root"
 RM_BIN="`which rm`"
diff --git a/programs/iozone/iozone3_263/src/current/Generate_Graphs b/programs/iozone/iozone3_263/src/current/Generate_Graphs
index 7c14a9a..0127ac0 100755
--- a/programs/iozone/iozone3_263/src/current/Generate_Graphs
+++ b/programs/iozone/iozone3_263/src/current/Generate_Graphs
@@ -12,19 +12,19 @@
 
 # Generate data base for all of the operation types.
 
-./gengnuplot.sh $1 write
-./gengnuplot.sh $1 rewrite
-./gengnuplot.sh $1 read
-./gengnuplot.sh $1 reread
-./gengnuplot.sh $1 randread
-./gengnuplot.sh $1 randwrite
-./gengnuplot.sh $1 bkwdread
-./gengnuplot.sh $1 recrewrite
-./gengnuplot.sh $1 strideread
-./gengnuplot.sh $1 fwrite
-./gengnuplot.sh $1 frewrite
-./gengnuplot.sh $1 fread
-./gengnuplot.sh $1 freread
+gengnuplot.sh $1 write
+gengnuplot.sh $1 rewrite
+gengnuplot.sh $1 read
+gengnuplot.sh $1 reread
+gengnuplot.sh $1 randread
+gengnuplot.sh $1 randwrite
+gengnuplot.sh $1 bkwdread
+gengnuplot.sh $1 recrewrite
+gengnuplot.sh $1 strideread
+gengnuplot.sh $1 fwrite
+gengnuplot.sh $1 frewrite
+gengnuplot.sh $1 fread
+gengnuplot.sh $1 freread
 
 # Produce graphs and postscript results.
 gnuplot gnu3d.dem
diff --git a/programs/logwriter/enospc.sh b/programs/logwriter/enospc.sh
index b4665bf..08c5d6a 100755
--- a/programs/logwriter/enospc.sh
+++ b/programs/logwriter/enospc.sh
@@ -4,7 +4,7 @@
 #
 if [ `dirname ${0}` == '.' ]; then
 	if [ -f config.sh ]; then
-		. ./config.sh;
+		. `dirname ${0}`/config.sh
 	fi;
 else
 	if [ -f `dirname ${0}`/config.sh ]; then
diff --git a/programs/logwriter/rename_write_race.sh b/programs/logwriter/rename_write_race.sh
index 4910963..fd5e6d0 100755
--- a/programs/logwriter/rename_write_race.sh
+++ b/programs/logwriter/rename_write_race.sh
@@ -32,7 +32,7 @@ exit 1;
 }
 if [ `dirname ${0}` == '.' ]; then
 	if [ -f config.sh ]; then
-		. ./config.sh;
+		. `dirname ${0}`/config.sh
 	fi;
 else
 	if [ -f `dirname ${0}`/config.sh ]; then
diff --git a/programs/python_common/o2tf.sh b/programs/python_common/o2tf.sh
index 2f2654b..a7e8b49 100755
--- a/programs/python_common/o2tf.sh
+++ b/programs/python_common/o2tf.sh
@@ -25,7 +25,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 MKFS_BIN="`which sudo` -u root `which mkfs.ocfs2`"
 FSCK_BIN="`which sudo` -u root `which fsck.ocfs2`"
diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
index 61008d8..99f24cc 100755
--- a/programs/python_common/single_run-WIP.sh
+++ b/programs/python_common/single_run-WIP.sh
@@ -858,14 +858,14 @@ run_reflink_test()
 
 	#ordered mount option
 	log_start "reflink_test" "ordered"
-	./reflink_test_run.sh -o ${logdir} -d ${device} ${mountpoint} || {
+	reflink_test_run.sh -o ${logdir} -d ${device} ${mountpoint} || {
 		RC=$?
 		log_end ${RC}
 	}
 
 	#writeback mount option
 	#log_start "reflink_test" "writeback"
-	#./reflink_test_run.sh -W -o ${logdir} -d ${device} ${mountpoint}
+	#reflink_test_run.sh -W -o ${logdir} -d ${device} ${mountpoint}
 	RC=$?
 	log_end ${RC}
 }
diff --git a/programs/python_common/single_run.sh b/programs/python_common/single_run.sh
index 75c626f..e55054e 100755
--- a/programs/python_common/single_run.sh
+++ b/programs/python_common/single_run.sh
@@ -207,7 +207,7 @@ LogRC $?;
 # MAIN
 #
 #
-. ./config.sh
+. `dirname ${0}`/config.sh
 #
 if [ $# -ne 2 ]; then
 	Usage;
diff --git a/programs/tunefs-test/remove-slot/corrupt_remove_slot.sh b/programs/tunefs-test/remove-slot/corrupt_remove_slot.sh
index 26f39a6..24faacb 100755
--- a/programs/tunefs-test/remove-slot/corrupt_remove_slot.sh
+++ b/programs/tunefs-test/remove-slot/corrupt_remove_slot.sh
@@ -128,7 +128,7 @@ function patch_tunefs()
 	cd $CORRUPT_SRC
 	patch -p1 < $pwd/corrupt_remove_slot.patch
 	exit_if_bad $? 0 "Can't patch the src directory."
-	./autogen.sh
+	autogen.sh
 	make
 	if [ ! -x "$CORRUPT_SRC/tunefs.ocfs2/tunefs.ocfs2" ];then
 		echo "Can't build the specified tunefs.ocfs2."
diff --git a/programs/xattr_tests/xattr-multi-run.sh b/programs/xattr_tests/xattr-multi-run.sh
index 7905102..7b0f7e0 100755
--- a/programs/xattr_tests/xattr-multi-run.sh
+++ b/programs/xattr_tests/xattr-multi-run.sh
@@ -36,7 +36,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 RM="`which rm`"
 MKDIR="`which mkdir`"
diff --git a/programs/xattr_tests/xattr-single-run.sh b/programs/xattr_tests/xattr-single-run.sh
index 794205a..09044e1 100755
--- a/programs/xattr_tests/xattr-single-run.sh
+++ b/programs/xattr_tests/xattr-single-run.sh
@@ -35,7 +35,7 @@
 PATH=$PATH:/sbin      # Add /sbin to the path for ocfs2 tools
 export PATH=$PATH:.
 
-. ./config.sh
+. `dirname ${0}`/config.sh
 
 GETXATTR="`which sudo` -u root `which getfattr`"
 SETXATTR="`which sudo` -u root `which setfattr`"
-- 
2.6.6
