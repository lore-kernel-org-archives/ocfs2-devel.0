From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 14:51:31 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Init meta_ac properly in
 ocfs2_create_empty_xattr_block.
In-Reply-To: <1268982264-28121-2-git-send-email-tao.ma@oracle.com>
References: <1268982264-28121-1-git-send-email-tao.ma@oracle.com>
	<1268982264-28121-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20100319215131.GD15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 03:04:24PM +0800, Tao Ma wrote:
> Init ctxt.meta_ac properly in ocfs2_create_empty_xattr_block.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 82c2a0b..3e77730 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6528,13 +6528,11 @@ static int ocfs2_create_empty_xattr_block(struct inode *inode,
>  					  int indexed)
>  {
>  	int ret;
> -	struct ocfs2_alloc_context *meta_ac;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct ocfs2_xattr_set_ctxt ctxt = {
> -		.meta_ac = meta_ac,
> -	};

	This patch is now in the fixes branch of ocfs2.git.  And I'm a
moron.  I can't believe I did this.

Joel

-- 

"Hell is oneself, hell is alone, the other figures in it, merely projections."
        - T. S. Eliot

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
