From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 30 Mar 2014 19:05:46 -0700
Subject: [Ocfs2-devel] [patch 4/8] ocfs2: call
	ocfs2_update_inode_fsync_trans when	updating any inode
In-Reply-To: <20140319211002.D199A5A4217@corp2gmr1-2.hot.corp.google.com>
References: <20140319211002.D199A5A4217@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140331020546.GD4488@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 19, 2014 at 02:10:02PM -0700, Andrew Morton wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> Subject: ocfs2: call ocfs2_update_inode_fsync_trans when updating any inode
> 
> Ensure that ocfs2_update_inode_fsync_trans() is called any time we touch
> an inode in a given transaction.  This is a follow-on to the previous
> patch to reduce lock contention and deadlocking during an fsync operation.

This looks fine but I have a question - what happens if a future patch adds
some disk structure change but forgets to call
ocfs2_update_inode_fsync_trans(). Could we wind up skipping some blocks to
sync in that case?
	--Mark

--
Mark Fasheh
