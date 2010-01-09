From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sun, 10 Jan 2010 01:59:56 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: add freeze/thaw support
Message-ID: <201001091800.o09I0rw0002807@rcsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

limitations:
1) only the THAW from the node from which FREEZE is issued takes effect.
those from other nodes are ignored.

2) a nested cross cluster FREEZE is not supported. that means if a FREEZE
is requested when the cluster is in frozen state(frozen from node A in
the cluster) from a node other than node A, the request its self can
succeed but it can't ensure ocfs2 volume consistency.

the following 3 patches are based on tiger's patch for freeze/thaw.
since there are lots of differences, please review carefully ;)
