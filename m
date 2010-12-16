From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 16 Dec 2010 00:52:03 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: make existing convertion
 precedent over new lock
In-Reply-To: <201012081237.oB7Ibeoo012391@acsinet15.oracle.com>
References: <201012081237.oB7Ibeoo012391@acsinet15.oracle.com>
Message-ID: <20101216085202.GN15545@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 08, 2010 at 08:34:39PM +0800, Wengang Wang wrote:
> Make existing convertion precedent over new lock. It makes o2dlm locking more
> like fair locking.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This is now in the merge-window branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dlm/dlmlock.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 69cf369..7009292 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -106,6 +106,9 @@ static int dlm_can_grant_new_lock(struct dlm_lock_resource *res,
>  
>  		if (!dlm_lock_compatible(tmplock->ml.type, lock->ml.type))
>  			return 0;
> +		if (!dlm_lock_compatible(tmplock->ml.convert_type,
> +					 lock->ml.type))
> +			return 0;
>  	}
>  
>  	return 1;
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
