From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:17 2008
Subject: [Ocfs2-devel] [PATCH 04/18] ocfs2: Fix writeout in
	ocfs2_data_convert_worker()
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 1044e401af9a309637828aa3cc8f3b6409fcbf4e
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 28 Feb 2008 17:16:03 -0800

Mainline commit f1f540688eae66c274ff1c1133b5d9c687b28f58 "optimized"
ocfs2_data_convert_worker() to "only do work for regular files".
Unfortunately, I left out a '!', which casued it to *skip* regular files.
This was hidden from testing until recently because the default data
journaling mode (data=ordered) doesn't exercise this code.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0ff457c..c8bcba4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3050,7 +3050,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;
 
-	if (S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		goto out;
 
 	/*
-- 
1.5.3.4
