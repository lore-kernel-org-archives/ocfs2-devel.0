From: Joel Becker <joel.becker@oracle.com>
Date: Wed,  7 Jul 2010 04:16:04 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Tail zeroing fixes.
In-Reply-To: <20100703213219.GB21262@mail.oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
Message-ID: <1278501367-7710-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

	This is version 3 of the ocfs2 tail zeroing fixes.  This version
has some major changes.  Tao correctly pointed out that we can have
multiple extents past i_size due to unwritten extents.  I've reworked
the zeroing code to walk them all.  Since I had to do that, and I had to
handle refcounted extents, I end up fixing a refcount bug with
non-sparse extentds.
	There are now three patches.  The first changes our zeroing
code to go page-by-page at the high level.  The second actually changes
the zeroing code.  The final patch, limiting zeroing to the end of a
write, is unchanged from v2.

Joel
