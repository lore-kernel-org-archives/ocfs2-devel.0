From: Larry Chen <lchen@suse.com>
Date: Tue,  4 Sep 2018 12:16:19 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] fix cluster leakage in ocfs2_defrag_extent
Message-ID: <20180904041621.16874-1-lchen@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

ocfs2_defrag_extent might leak clusters allocated.
When file system has no enough space, the number of claimed clusters
might less than the caller wants. If that happens, the original code
might directly commit trans without returning clusters.

This patch refered a lot to ocfs2_add_clusters_in_btree.

Larry Chen (2):
  add declaration of ocfs2_free_local_alloc_bits
  fix clusters leak in ocfs2_defrag_extent

 fs/ocfs2/alloc.h        |  6 ++++++
 fs/ocfs2/move_extents.c | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)

-- 
2.13.7
