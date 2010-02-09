From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 8 Feb 2010 16:47:56 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <1265366732-15895-1-git-send-email-tristan.ye@oracle.com>
References: <1265366732-15895-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100209004756.GF1832@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 06:45:31PM +0800, Tristan Ye wrote:
> I merge the following steps into one patch since they may be logically doing one thing,
> Though I knew it looks a little bit fat to review.
> 
> 1). Remove redundant codes used by ocfs2_commit_truncate before, since we're moving to
>     ocfs2_remove_btree_range anyway.
> 
> 2). Add a new func ocfs2_reserve_blocks_for_rec_trunc() for purpose of accepting  some
>     extra blocks to reserve.
> 
> 3). Change ocfs2_prepare_refcount_change_for_del() a bit to fit our needs, it's safe to
>     do this since it's only being called by truncating codes.
> 
> 4). Change ocfs2_remove_btree_range() a bit to take refcount case into account.
> 
> 5). Finally, we change ocfs2_commit_truncate() to call ocfs2_remove_btree_range() in
>     a proper way.

	I was going to be mad that these 5 things weren't five patches,
but actually it reads pretty well as a patch.  I'm OK with it being one
patch.
	Mark, can I get an Ack?

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
