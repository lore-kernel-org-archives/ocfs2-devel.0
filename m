From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 30 Apr 2009 11:00:03 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix a missing credit when deleting
	from indexed	directories.
In-Reply-To: <20090430010449.GE27450@mail.oracle.com>
References: <20090430010449.GE27450@mail.oracle.com>
Message-ID: <20090430180003.GJ4585@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 29, 2009 at 06:04:51PM -0700, Joel Becker wrote:
> The ocfs2 directory index updates two blocks when we remove an entry -
> the dx root and the dx leaf.  OCFS2_DELETE_INODE_CREDITS was only
> accounting for the dx leaf.  This shows up when ocfs2_delete_inode()
> runs out of credits in jbd2_journal_dirty_metadata() at
> "J_ASSERT_JH(jh, handle->h_buffer_credits > 0);".
> 
> The test that caught this was running dirop_file_racer from the
> ocfs2-test suite with a 250-character filename PREFIX.  Run on a 512B
> blocksize, it forces the orphan dir index to grow large enough to
> trigger.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

Acked-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
