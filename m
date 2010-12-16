From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 16 Dec 2010 00:41:38 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Hold ip_lock when set/clear flags
 for indexed dir.
In-Reply-To: <1292401800-14014-1-git-send-email-tm@tao.ma>
References: <1292401800-14014-1-git-send-email-tm@tao.ma>
Message-ID: <20101216084137.GK15545@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 15, 2010 at 04:30:00PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we set/clear the dyn_features for an inode we hold the ip_lock.
> So do it when we set/clear OCFS2_INDEXED_DIR_FL also.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

This is now in the fixes branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dir.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index c49f6de..d417b3f 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -2461,8 +2461,10 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
>  
>  	di->i_dx_root = cpu_to_le64(dr_blkno);
>  
> +	spin_lock(&OCFS2_I(dir)->ip_lock);
>  	OCFS2_I(dir)->ip_dyn_features |= OCFS2_INDEXED_DIR_FL;
>  	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
> +	spin_unlock(&OCFS2_I(dir)->ip_lock);
>  
>  	ocfs2_journal_dirty(handle, di_bh);
>  
> @@ -4466,8 +4468,10 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
>  		goto out_commit;
>  	}
>  
> +	spin_lock(&OCFS2_I(dir)->ip_lock);
>  	OCFS2_I(dir)->ip_dyn_features &= ~OCFS2_INDEXED_DIR_FL;
>  	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
> +	spin_unlock(&OCFS2_I(dir)->ip_lock);
>  	di->i_dx_root = cpu_to_le64(0ULL);
>  
>  	ocfs2_journal_dirty(handle, di_bh);
> -- 
> 1.7.0.4
> 

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
