From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 23 Oct 2012 01:54:48 -0700
Subject: [Ocfs2-devel] [PATCH 06/21] ocfs2: drop vmtruncate
In-Reply-To: <508296B4.60508@gmail.com>
References: <508296B4.60508@gmail.com>
Message-ID: <20121023085448.GM5635@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> Removed vmtruncate
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

Do you want me to pull this, or are you going to send it with your set?

Joel

> ---
>  fs/ocfs2/file.c |   19 +------------------
>  1 files changed, 1 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 5a4ee77..eb16e44 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1172,6 +1172,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  			status = -ENOSPC;
>  			goto bail_unlock;
>  		}
> +		truncate_setsize(inode, attr->ia_size);
>  	}
>  
>  	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
> @@ -1218,24 +1219,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		}
>  	}
>  
> -	/*
> -	 * This will intentionally not wind up calling truncate_setsize(),
> -	 * since all the work for a size change has been done above.
> -	 * Otherwise, we could get into problems with truncate as
> -	 * ip_alloc_sem is used there to protect against i_size
> -	 * changes.
> -	 *
> -	 * XXX: this means the conditional below can probably be removed.
> -	 */
> -	if ((attr->ia_valid & ATTR_SIZE) &&
> -	    attr->ia_size != i_size_read(inode)) {
> -		status = vmtruncate(inode, attr->ia_size);
> -		if (status) {
> -			mlog_errno(status);
> -			goto bail_commit;
> -		}
> -	}
> -
>  	setattr_copy(inode, attr);
>  	mark_inode_dirty(inode);
>  
> -- 
> 1.7.3.4

-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

			http://www.jlbec.org/
			jlbec at evilplan.org
