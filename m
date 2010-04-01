From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 18:30:21 -0700
Subject: [Ocfs2-devel] Fix for online resize with metaecc
Message-ID: <20100401013021.GG28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark figured out what happened with bug 1214 - online resize writes out
the superblocks without calculating metaecc.  Here's a patch to fix it.

Tao, Tiger, Tristan... Can one of you test this quickly?

Joel

From d917c07dd45b16827a207e90a145ae248416c96c Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 31 Mar 2010 18:25:44 -0700
Subject: [PATCH] ocfs2: Compute metaecc for superblocks during online resize.

Online resize writes out the new superblock and its backups directly.
The metaecc data wasn't being recomputed.  Let's do that directly.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Cc: stable at kernel.org
---
 fs/ocfs2/buffer_head_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 21c808f..b18c6d6 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -407,6 +407,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 				struct buffer_head *bh)
 {
 	int ret = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
 	mlog_entry_void();
 
@@ -426,6 +427,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 
 	get_bh(bh); /* for end_buffer_write_sync() */
 	bh->b_end_io = end_buffer_write_sync;
+	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &di->i_check);
 	submit_bh(WRITE, bh);
 
 	wait_on_buffer(bh);
-- 
1.7.0.3


-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
