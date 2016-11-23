From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 20:36:01 -0800
Subject: [Ocfs2-devel] [PATCH v2 0/7] ocfs2: wire up {clone, copy,
	dedupe}_range
Message-ID: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, darwin.xupt@gmail.com, zren@suse.com, ocfs2-devel@oss.oracle.com

Hi all,

This is the second submission of a series of patches that wire up the
existing ocfs2 reflinking capabilities to the new(ish) VFS
{copy,clone,dedupe}_range interface.  The first few patches clean up
some minor bugs that I found; the last kernel patch contains the new
code.  The last patch is a new; it fixes a quota accounting bug.

A few minor fixes to xfstests are needed to make more of the tests
run; those have been sent separately to the fstests lists.

--D

[1] https://github.com/djwong/linux/tree/ocfs2-vfs-reflink-3
