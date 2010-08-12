From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Aug 2010 17:32:16 -0700
Subject: [Ocfs2-devel] Reorganize data elements to reduce struct sizes
In-Reply-To: <AANLkTinl-EuRPsbKhFnEiglxUJKYSInZ4ZGafzkidWtb@mail.gmail.com>
References: <AANLkTinl-EuRPsbKhFnEiglxUJKYSInZ4ZGafzkidWtb@mail.gmail.com>
Message-ID: <20100812003215.GD8985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 10, 2010 at 05:21:36PM -0500, Goldwyn Rodrigues wrote:
> Thanks for the comments. I have incorportated them all.
> 
> CONFIG_OCFS2_FS_STATS is enabled and CONFIG_DEBUG_LOCK_ALLOC is disabled.
> Statistics now look like -
> ocfs2_write_ctxt: 2144 - 2136 = 8
> ocfs2_inode_info: 1960 - 1848 = 112
> ocfs2_journal: 168 - 160 = 8
> ocfs2_lock_res: 336 - 304 = 32
> ocfs2_refcount_tree: 512 - 472 = 40
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

	This patch is now in the merge-window branch of ocfs2.git

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
