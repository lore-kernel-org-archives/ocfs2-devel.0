From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 14 Oct 2008 17:25:35 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Morph the haphazard
	OCFS2_IS_VALID_DINODE() checks.
Message-ID: <20081015002535.GN15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 14, 2008 at 01:49:02PM -0700, Joel Becker wrote:
> Random places in the code would check a dinode bh to see if it was
> valid.  Not only did they do different levels of validation, they
> handled errors in different ways.
> 
> The previous commit unified inode block reads, validating all block
> reads in the same place.  Thus, these haphazard checks are no longer
> necessary.  Rather than eliminate them, however, we change them to
> BUG_ON() checks.  This ensures the assumptions remain true.  All of the
> code paths to these checks have been audited to ensure they come from a
> validated inode read.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c    |   50 +++++++++++++++++++++-----------------------------
>  fs/ocfs2/journal.c  |   17 +++++------------
>  fs/ocfs2/resize.c   |   10 ++++------
>  fs/ocfs2/suballoc.c |   36 ++++++++++++++++--------------------
>  4 files changed, 46 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index b163b79..ddbb567 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -187,20 +187,12 @@ static int ocfs2_dinode_insert_check(struct inode *inode,
>  static int ocfs2_dinode_sanity_check(struct inode *inode,
>  				     struct ocfs2_extent_tree *et)
>  {
> -	int ret = 0;
> -	struct ocfs2_dinode *di;
> +	struct ocfs2_dinode *di = et->et_object;
>  
>  	BUG_ON(et->et_ops != &ocfs2_dinode_et_ops);
> +	BUG_ON(!OCFS2_IS_VALID_DINODE(di));


This all looks good to me. It should be pretty easy for us later on to
search on 'BUG_ON(!OCFS2_IS_VALID_DINODE' to remove these redundant checks
once we're confident the conversion went ok.
	--Mark

--
Mark Fasheh
