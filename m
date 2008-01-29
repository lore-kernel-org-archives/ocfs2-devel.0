From: Tao Ma <tao.ma@oracle.com>
Date: Tue Jan 29 22:10:57 2008
Subject: [Ocfs2-devel] [PATCH 0/2] Unwritten extent merge update, V2
Message-ID: <20080130060924.GA9243@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old extent merging code down underneath "ocfs2_mark_extent_written()"
can't merge extents between leaf blocks. This patch resolve this.
So that a large unwritten extent which has been split up with a bunch of
writes can be merged together once all unwritten regions have been written to.

Modification from V1 to V2:
1. Add more comments for some functions which is more complicated than before.
2. move the journal_access() calls to a better place so that we may detect its
   error before we do the real modification to some extent blocks.
3. Using l_next_free_rec instead of l_count to index the extent record array so
   that it's more consistent with other codes.
4. Delete the empty extent block during ocfs2_merge_rec_left when it is needed
   instead of leaving it to ocfs2_rotate_tree_left.
5. Stick to one merge mechanism in CONTIG_LEFTRIGHT. Right merge is always the
   first instead of left one.
