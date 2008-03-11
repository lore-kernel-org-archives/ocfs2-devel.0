From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:21 2008
Subject: [Ocfs2-devel] [PATCH 12/18] ocfs2: Fix an endian bug in online
	resize
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 4338ab6a750303cbae4cc76cc7de5edba6598ebe
Author: Tao Ma <tao.ma@oracle.com>
Date: Mon, 3 Mar 2008 10:53:02 +0800

In ocfs2_group_add, 'cr' is a disk field of type 'ocfs2_chain_rec', and we
were putting cpu byteorder values into it. Swap things to the right endian
before storing.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 37835ff..8166968 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -597,7 +597,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		memset(cr, 0, sizeof(struct ocfs2_chain_rec));
 	}
 
-	cr->c_blkno = le64_to_cpu(input->group);
+	cr->c_blkno = cpu_to_le64(input->group);
 	le32_add_cpu(&cr->c_total, input->clusters * cl_bpc);
 	le32_add_cpu(&cr->c_free, input->frees * cl_bpc);
 
-- 
1.5.3.4
