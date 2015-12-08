From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 7 Dec 2015 19:44:21 -0500
Subject: [Ocfs2-devel] [PATCH V2] jbd2: fix null committed data return
	in undo_access
In-Reply-To: <1449039255-21833-1-git-send-email-junxiao.bi@oracle.com>
References: <1449039255-21833-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20151208004421.GE3094@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, ocfs2-devel@oss.oracle.com

On Wed, Dec 02, 2015 at 02:54:15PM +0800, Junxiao Bi wrote:
> commit de92c8caf16c ("jbd2: speedup jbd2_journal_get_[write|undo]_access()")
> introduced jbd2_write_access_granted() to improve write|undo_access
> speed, but missed to check the status of b_committed_data which caused
> a kernel panic on ocfs2.

Thanks, applied.  (And already upstream).

						- Ted
