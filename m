From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sat, 10 Dec 2016 12:42:55 -0800
Subject: [Ocfs2-devel] [PATCH v4 00/11] ocfs2: wire up {clone, copy,
	dedupe}_range
Message-ID: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

Hi all,

This is the fourth submission of a series of patches that wire up the
existing ocfs2 reflinking capabilities to the new(ish) VFS
{copy,clone,dedupe}_range interface.  The first few patches hoist some
of the reflink/dedupe prep functions into the VFS since the code is
common to XFS and ocfs2.  Then there are fixes for some ocfs2 bugs that
I found; and finally the last kernel patch contains the new code.

A few minor fixes to xfstests are needed to make more of the tests run;
those have been sent separately to the fstests lists.  Some of the
xfstests will fail because ocfs2's design does not allow sharing of
blocks between disjoint sets of files with shared blocks.  That is to
say, if A shares with B and C shares with D, B and C cannot be made to
share blocks.

Andrew, could you please queue these up for testing?  I'd like to get
them into 4.10 if possible.

--D

[1] https://github.com/djwong/linux/tree/ocfs2-vfs-reflink-6
