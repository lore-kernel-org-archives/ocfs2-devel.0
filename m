From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:28 -0700
Subject: [Ocfs2-devel] [PATCH 0/6] Refactor ocfs2_read_blocks()
Message-ID: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_read_blocks() is a complex kitchen sink for almost all block
reading in ocfs2.  Before I add logic to let callers key on whether a
block was in cache or not, Mark and I decided it could use some cleaning
up.

First, synchronous reads are moved to a separate function.  The main
logic of ocfs2_read_blocks() is really about cached reads.  Next, we can
make the inode a requirement and simplify the function call.  After
that, ocfs2_read_block() becomes an always-cached operation.  We move
ocfs2_bread() to dir.c where it is used and make sure dir.c isn't using
naked bh functions.  Finally, we make cached I/O the common case.

Joel
