From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 19 Mar 2010 15:04:23 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Increase name_offset for the
	removed xattr.
Message-ID: <1268982264-28121-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When replacing a xattr's value, in some case we wipe
its name/value first and then adding them. The wipe
is done by ocfs2_xa_block_wipe_namevalue when xattr
is in inode or block. we decrease name_offset for all
the entries which have offset < name_offset. This isn't
enough in case the replaced one has the smallest offset.
So the next time we will find the wrong free_start in
ocfs2_xa_get_free_start and we will overflow finally.
The solution is to increase the name_offset for the
replaced one also so that we can survive.

The following script can trigger a kernel panic easily.

echo 'y'|mkfs.ocfs2 --fs-features=local,xattr -b 4K $DEVICE
mount -t ocfs2 $DEVICE $MNT_DIR
FILE=$MNT_DIR/$RANDOM
for((i=0;i<76;i++))
do
string_76="a$string_76"
done
string_78="aa$string_76"
string_82="aaaa$string_78"

touch $FILE
setfattr -n 'user.test1234567890' -v $string_76 $FILE
setfattr -n 'user.test1234567890' -v $string_78 $FILE
setfattr -n 'user.test1234567890' -v $string_82 $FILE

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d1b0d38..82c2a0b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1622,7 +1622,7 @@ static void ocfs2_xa_block_wipe_namevalue(struct ocfs2_xa_loc *loc)
 	/* Now tell xh->xh_entries about it */
 	for (i = 0; i < count; i++) {
 		offset = le16_to_cpu(xh->xh_entries[i].xe_name_offset);
-		if (offset < namevalue_offset)
+		if (offset <= namevalue_offset)
 			le16_add_cpu(&xh->xh_entries[i].xe_name_offset,
 				     namevalue_size);
 	}
-- 
1.5.5
