From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 16 Mar 2010 17:19:25 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: use allocation reservations
 during file write
In-Reply-To: <1268188148-5253-3-git-send-email-mfasheh@suse.com>
References: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
	<1268188148-5253-3-git-send-email-mfasheh@suse.com>
Message-ID: <4B9F4D1D.7010009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
Mark Fasheh wrote:
> Add a per-inode reservations structure and pass it through to the
> reservations code.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/ocfs2/alloc.c |    2 ++
>  fs/ocfs2/aops.c  |    2 ++
>  fs/ocfs2/file.c  |    3 +++
>  fs/ocfs2/inode.c |    4 ++++
>  fs/ocfs2/inode.h |    2 ++
>  fs/ocfs2/super.c |    2 ++
>  6 files changed, 15 insertions(+), 0 deletions(-)
<snip>
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 7e9df11..137d460 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1734,6 +1734,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  			goto out;
>  		}
>  
> +		data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
> +
Here is a bug. In case, we are writing the unwritten extents, we don't 
have a valid data_ac.
>  		credits = ocfs2_calc_extend_credits(inode->i_sb,
>  						    &di->id2.i_list,
>  						    clusters_to_alloc);

Regards,
Tao
