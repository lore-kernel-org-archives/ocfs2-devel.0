From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 29 Aug 2013 16:56:52 +0800
Subject: [Ocfs2-devel] [PATCH] [RESEND] ocfs2: fix the end cluster offset of
	FIEMAP
Message-ID: <521F0CD4.4010406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

Call fiemap ioctl(2) with given start offset as well as an desired
mapping range should show extents if possible.  However, we somehow
figure out the end offset of mapping via 'mapping_end -= cpos' before
iterating the extent records which would cause problems if the given
fiemap length is too small to a cluster size, e.g,

Cluster size 4096:
debugfs.ocfs2 1.6.3
        Block Size Bits: 12   Cluster Size Bits: 12

The extended fiemap test utility From David:
https://gist.github.com/anonymous/6172331

# dd if=/dev/urandom of=/ocfs2/test_file bs=1M count=1000
# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 0 extents:
#	Logical          Physical         Length           Flags
	^^^^^ <-- No extent is shown

In this case, at ocfs2_fiemap(): cpos == mapping_end == 1. Hence the
loop of searching extent records was not executed at all.

This patch remove the in question 'mapping_end -= cpos', and loops
until the cpos is larger than the mapping_end as usual.

# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000056a01000 0000000006a00000 0000

Cc: stable at vger.kernel.org
Reported-by: David Weber <wb@munzinger.de>
Tested-by: David Weber <wb@munzinger.de>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fashen <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/extent_map.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 2487116..8460647 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -781,7 +781,6 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
 					       map_start + map_len);
-	mapping_end -= cpos;
 	is_last = 0;
 	while (cpos < mapping_end && !is_last) {
 		u32 fe_flags;
-- 1.7.9.5 
