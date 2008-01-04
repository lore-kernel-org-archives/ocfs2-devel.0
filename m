From: Tao Ma <tao.ma@oracle.com>
Date: Fri Jan  4 00:33:41 2008
Subject: [Ocfs2-devel] [PATCH 0/2] Unwritten extent merge update,V1
Message-ID: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old extent merging code down underneath "ocfs2_mark_extent_written()"
can't merge extents between leaf blocks. This patch resolve this.
So that a large unwritten extent which has been split up with a bunch of
writes can be merged together once all unwritten regions have been written to.
