From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 Nov 2008 14:55:07 -0800
Subject: [Ocfs2-devel] ocfs2: initialize stack_user lvbptr
In-Reply-To: <20081110222457.GE17894@redhat.com>
References: <20081110222457.GE17894@redhat.com>
Message-ID: <20081110225507.GC12445@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 10, 2008 at 04:24:57PM -0600, David Teigland wrote:
> commit 3d48397962cdad2aa32df75cfdae980af9bce8cc
> Author: David Teigland <teigland@redhat.com>
> Date:   Mon Nov 10 16:16:07 2008 -0600
> 
>     ocfs2: initialize stack_user lvbptr
>     
>     The locking_state dump, ocfs2_dlm_seq_show, reads the lvb on locks
>     where it has not yet been initialized by a lock call.
>     
>     Signed-off-by: David Teigland <teigland@redhat.com>

Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index faec2d8..9b76d41 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -740,6 +740,9 @@ static int user_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
>  
>  static void *user_dlm_lvb(union ocfs2_dlm_lksb *lksb)
>  {
> +	if (!lksb->lksb_fsdlm.sb_lvbptr)
> +		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
> +					     sizeof(struct dlm_lksb);
>  	return (void *)(lksb->lksb_fsdlm.sb_lvbptr);
>  }
>  

-- 

"What does it say about a society's priorities when the time you
 spend in meetings on Monday is greater than the total number of
 hours you spent sleeping over the weekend?"
	- Nat Friedman

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
