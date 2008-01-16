From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:01 2008
Subject: [Ocfs2-devel] [PATCH 03/20] ocfs2: Re-order iput in
	ocfs2_drop_dentry_lock
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 9f70968af3e6e21612e06e153aa71c62dee5a09b
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 18 Oct 2007 12:36:10 -0700

Do this to avoid a theoretical (I haven't seen this in practice) race where
the downconvert thread might drop the dentry lock, allowing a remote unlink
to proceed before dropping the inode locks. This could bounce access to the
orphan dir between nodes.

There doesn't seem to be a need to do the same in ocfs2_dentry_iput() as
that's never called for the last ref drop from the downconvert thread.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 014e739..9e76e3c 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -318,9 +318,9 @@ out_attach:
 static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 				   struct ocfs2_dentry_lock *dl)
 {
+	iput(dl->dl_inode);
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
 	ocfs2_lock_res_free(&dl->dl_lockres);
-	iput(dl->dl_inode);
 	kfree(dl);
 }
 
-- 
1.5.3.4
