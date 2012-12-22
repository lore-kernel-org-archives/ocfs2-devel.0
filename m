From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 21 Dec 2012 22:52:51 -0500
Subject: [Ocfs2-devel] [PATCH 2/2] ext4: Fix deadlock in
	journal_unmap_buffer()
In-Reply-To: <20121221230347.GB23652@quack.suse.cz>
References: <1355345416-13565-1-git-send-email-jack@suse.cz>
	<1355345416-13565-2-git-send-email-jack@suse.cz>
	<20121221195220.GF31731@thunk.org>
	<20121221230347.GB23652@quack.suse.cz>
Message-ID: <20121222035251.GA5778@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

On Sat, Dec 22, 2012 at 12:03:47AM +0100, Jan Kara wrote:
>   I should have commented on this in the changelog :).
> jbd2_journal_invalidatepage() gets called only for file pagecache pages.
> Because ocfs2 doesn't do data journalling it never sees buffers that are
> part of a transaction in jbd2_journal_invalidatepage() (similarly to ext4
> except for data=journal case). I'll send a patch to just stop calling
> jbd2_journal_invalidatepage() for ocfs2... But you are safe to merge this
> patch in the mean time.

Ok, so if ocfs2 never tries journalling data blocks, then buffer_jbd()
will always be NULL, which reduces jbd2_journal_invalidate() to be
equivalent in functionality to block_invalidatepage(), and so it will
never abort and return EBUSY.
  
Thanks for the explanation, I'll apply the patch.

						- Ted
