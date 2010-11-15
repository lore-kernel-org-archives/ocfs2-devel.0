From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 15 Nov 2010 21:39:09 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Stop tracking a negative dentry
	after dentry_iput().
Message-ID: <1289828349-24098-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I suddenly hit the problem during 2.6.37-rc1 regression test, which was
introduced by commit '5e98d492406818e6a94c0ba54c61f59d40cefa4a'(Track
negative entries v3), following scenario reproduces the issue easily:

Node A			Node B
================	============
$touch 	testfile	
			$ls testfile
$rm -rf testfile
$touch 	testfile	
			$ls testfile
			ls: cannot access testfile: No such file or directory

This patch stops tracking the dentry which was negativated by a inode deletion,
so as to force the revaliation in next lookup, in case we'll touch the inode
again in the same node.

It didn't hurt the performance of multiple lookup for none-existed files anyway,
while regresses a bit in the first try after a file deletion.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/dcache.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index edaded4..895532a 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -476,7 +476,6 @@ static void ocfs2_dentry_iput(struct dentry *dentry, struct inode *inode)
 
 out:
 	iput(inode);
-	ocfs2_dentry_attach_gen(dentry);
 }
 
 /*
-- 
1.5.5
