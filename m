From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 09 Nov 2016 14:51:06 -0800
Subject: [Ocfs2-devel] [PATCH 0/6] ocfs2: wire up {clone, copy, dedupe}_range
Message-ID: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi all,

These patches wire up the existing ocfs2 reflinking capabilities to
the new(ish) VFS {copy,clone,dedupe}_range interface.  The first few
patches clean up some minor bugs that I found; the last kernel patch
contains the new code.

A few minor fixes to xfstests are needed to make more of the tests
run.  I'll tack that patch on the end.

--D

[1] https://github.com/djwong/linux/tree/ocfs2-vfs-reflink
