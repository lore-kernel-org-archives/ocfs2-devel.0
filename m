From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 27 Jul 2015 11:27:23 +0300
Subject: [Ocfs2-devel] [patch -next] ocfs2: scheduling in atomic in
	ocfs2_filecheck_store()
Message-ID: <20150727082723.GA3310@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We're hold "spin_lock(&ent->fs_fcheck->fc_lock)" so the allocation has
to be GFP_ATOMIC.

I changed the sizeof() because otherwise the line goes over the 80
character limit and also the new way is prefered kernel style.

Fixes: e467fe5da718 ('ocfs2: sysfile interfaces for online file check')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 3332af1..9613663 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -544,7 +544,7 @@ static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
 			BUG_ON(!ocfs2_filecheck_erase_entry(ent));
 		}
 
-		entry = kmalloc(sizeof(struct ocfs2_filecheck_entry), GFP_NOFS);
+		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 		if (entry) {
 			entry->fe_ino = args.fa_ino;
 			entry->fe_type = args.fa_type;
