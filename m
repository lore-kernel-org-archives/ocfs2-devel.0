From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 16 Feb 2009 09:16:00 +0800
Subject: [Ocfs2-devel] [PATCH 06/40] ocfs2: Pass struct
 ocfs2_caching_info to the journal functions.
In-Reply-To: <1234563387-17101-7-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
	<1234563387-17101-7-git-send-email-joel.becker@oracle.com>
Message-ID: <4998BE50.7060505@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

love this patch very much. :)

Regards,
Tao

Joel Becker wrote:
> The next step in divorcing metadata I/O management from struct inode is
> to pass struct ocfs2_caching_info to the journal functions.  Thus the
> journal locks a metadata cache with the cache io_lock function.  It also
> can compare ci_last_trans and ci_created_trans directly.
> 
> This is a large patch because of all the places we change
> ocfs2_journal_access..(handle, inode, ...) to
> ocfs2_journal_access..(handle, INODE_CACHE(inode), ...).
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
