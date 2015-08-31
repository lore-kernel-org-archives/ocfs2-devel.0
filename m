From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 12:50:46 -0700
Subject: [Ocfs2-devel] [patch 15/28] ocfs2: fix race between crashed dio
	and rm
In-Reply-To: <55de39b0.aaGASvWligtEatCU%akpm@linux-foundation.org>
References: <55de39b0.aaGASvWligtEatCU%akpm@linux-foundation.org>
Message-ID: <20150831195046.GU1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:00PM -0700, Andrew Morton wrote:
> From: Joseph Qi <joseph.qi@huawei.com>
> Subject: ocfs2: fix race between crashed dio and rm
> 
> There is a race case between crashed dio and rm, which will lead to
> OCFS2_VALID_FL not set read-only.
> 
> N1                              N2
> ------------------------------------------------------------------------
> dd with direct flag
>                                 rm file
> crashed with an dio entry left
> in orphan dir
>                                 clear OCFS2_VALID_FL in
>                                 ocfs2_remove_inode
>                                 recover N1 and read the corrupted inode,
>                                 and set filesystem read-only
> 
> So we skip the inode deletion this time and wait for dio entry
> recovered first.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
