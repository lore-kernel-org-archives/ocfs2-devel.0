From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Sun, 19 Apr 2015 14:43:03 +0900
Subject: [Ocfs2-devel] [PATCH] ocfs2: use retval instead of status for
	checking error
Message-ID: <20150419054303.GA8548@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, richard@nod.at, akpm@linux-foundation.org, joseph.qi@huawei.com

The use of 'status' in __ocfs2_add_entry() can return wrong
value. Some functions' return value in __ocfs2_add_entry(),
i.e ocfs2_journal_access_di() is saved to 'status'.
But 'status' is not used in 'bail' label for returning result
of __ocfs2_add_entry().

So use retval instead of status.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
This patch was came from 'https://lkml.org/lkml/2015/2/27/655'
This patch was needed to test but I didn't have any environment
for testing ocfs2 filesystem. But I have one, now.
(I'm too busy to make this enviroment. And qemu for this fs is difficult
 for me. :-(, sorry for that)

Briefly how to set my environment for testing this fs with qemu.
1. Getting and building linux kernel with linux-next branch for x86_64 qemu.
   And also options of ocfs2 related are enabled(built-in)
2. Makes own root file system with 'buildroot' project.
3. Getting and building ocfs2-tools.
  Then binaries after building this tool are moved my rootfs.
4. Makes dummy disk image(5G) which will be formatted in qemu.
5. Booting qemu with rootfs image and dummy disk image.
6. mkfs.ocfs2 --fs-feature=local <device>
  this maybe possilbe to mount standalone mode.
7. tunefs.ocfs2  --fs-features=indexed-dirs,noinline-data <device>
8. make a cluster and one node
  use o2cb_ctl tool.
9. o2cb service load and initialize
  # /etc/init.d/o2cb load && /etc/init.d/o2cb configure
  # /etc/init.d/o2cb online
10. mount ocfs2
  # mount.ocfs2 <device> <some directory>

And use GDB for debugging my patch path.
Connect gdb with qemu and add breakpoint in __ocfs2_add_entry() of fs/ocfs2/dir.c

And test my patch.
# cd <some directory mounted with ocfs2>
# mkdir <specific directory>

This how-to is not written all my work, just briefly I said.

 fs/ocfs2/dir.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 990e8f7..a9513ff 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1607,7 +1607,7 @@ int __ocfs2_add_entry(handle_t *handle,
 	struct ocfs2_dir_entry *de, *de1;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)parent_fe_bh->b_data;
 	struct super_block *sb = dir->i_sb;
-	int retval, status;
+	int retval;
 	unsigned int size = sb->s_blocksize;
 	struct buffer_head *insert_bh = lookup->dl_leaf_bh;
 	char *data_start = insert_bh->b_data;
@@ -1685,25 +1685,25 @@ int __ocfs2_add_entry(handle_t *handle,
 			}
 
 			if (insert_bh == parent_fe_bh)
-				status = ocfs2_journal_access_di(handle,
+				retval = ocfs2_journal_access_di(handle,
 								 INODE_CACHE(dir),
 								 insert_bh,
 								 OCFS2_JOURNAL_ACCESS_WRITE);
 			else {
-				status = ocfs2_journal_access_db(handle,
+				retval = ocfs2_journal_access_db(handle,
 								 INODE_CACHE(dir),
 								 insert_bh,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 
-				if (ocfs2_dir_indexed(dir)) {
-					status = ocfs2_dx_dir_insert(dir,
+				if (!retval && ocfs2_dir_indexed(dir))
+					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (status) {
-						mlog_errno(status);
-						goto bail;
-					}
-				}
+			}
+
+			if (retval) {
+				mlog_errno(retval);
+				goto bail;
 			}
 
 			/* By now the buffer is marked for journaling */
-- 
1.7.1
