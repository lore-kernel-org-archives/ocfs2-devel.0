From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sun, 11 Dec 2016 13:53:22 -0800
Subject: [Ocfs2-devel] [PATCH 6/7] reflink: don't test disjoint block
	sharing sets
In-Reply-To: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
Message-ID: <148149320283.31093.5997149744213850055.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

Unlike xfs/btrfs which store refcounting information as part of the
space metadata, ocfs2 implements block sharing (reflink) by creating
refcount btrees that are shared between subsets of files.  Effectively,
this means that a ocfs2 can have multiple disjoint sets of files that
share blocks, which also means that blocks cannot be reflinked between
two disjoint refcounted-file-sets.  generic/119 tests the ability to do
this, so we cannot run it for ocfs2.  Create a _require helper to check
for this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink    |    9 +++++++++
 tests/generic/119 |    1 +
 2 files changed, 10 insertions(+)


diff --git a/common/reflink b/common/reflink
index d048045..55d82ac 100644
--- a/common/reflink
+++ b/common/reflink
@@ -28,6 +28,15 @@ _require_cp_reflink()
                _notrun "This test requires a cp with --reflink support."
 }
 
+# Can we reflink between arbitrary file sets?
+# i.e. if we reflink a->b and c->d, can we later share
+# blocks between b & c?
+_require_arbitrary_fileset_reflink()
+{
+	test "$FSTYP" = "ocfs2" && \
+		_notrun "reflink between arbitrary file groups not supported in $FSTYP"
+}
+
 # Given 2 files, verify that they have the same mapping but different
 # inodes - i.e. an undisturbed reflink
 # Silent if so, make noise if not
diff --git a/tests/generic/119 b/tests/generic/119
index e6a6f59..b28e044 100755
--- a/tests/generic/119
+++ b/tests/generic/119
@@ -47,6 +47,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_test_reflink
+_require_arbitrary_fileset_reflink
 
 rm -f $seqres.full
 
