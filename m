From: tristan <tristan.ye@oracle.com>
Date: Wed, 27 Jan 2010 19:36:19 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] Ocfs2: Optimize ocfs2 truncating codes.
Message-ID: <4B602533.9090107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Optimization for ocfs2 truncating including following three patches, our 
main goal is to generalize truncating codes by using
common ocfs2_remove_btree_range() together with punching holes codes, 
besides, refcount supporting codes will be transfered from
ocfs2_commit_truncate() to ocfs2_remove_btree_range() to let it be more 
generic, which will also benefit our punching holes codes
as well.

Such patches has been tested slightly(with normal and corner testcases), 
heavier workload are going to be expected.

We're going to optimize the punching holes codes in next series, on one 
hand, to truncate records as truncting codes did(from hole_end to 
hole_start),
on the other hand, add refcount supporting for it.


Regards,
Tristan.
