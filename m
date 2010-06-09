From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 03:08:39 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
	inode_setattr.
In-Reply-To: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100609100839.GA21239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 04:48:20PM +0800, Tao Ma wrote:
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6a13ea6..06fd85c 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1052,17 +1052,17 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
>  
>  	/*
> -	 * This will intentionally not wind up calling simple_setsize(),
> -	 * since all the work for a size change has been done above.
> -	 * Otherwise, we could get into problems with truncate as
> -	 * ip_alloc_sem is used there to protect against i_size
> -	 * changes.
> +	 * Since all the work for a size change has been done above,
> +	 * we only need to call simple_setsize to update i_size.
>  	 */
> -	status = inode_setattr(inode, attr);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto bail_commit;
> +	if (attr->ia_valid & ATTR_SIZE) {
> +		status = simple_setsize(inode, attr->ia_size);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail_commit;
> +		}

	Boy, this is a bit to think about.  The old code deliberately
used vmtruncate() to update i_size and trim the pagecace, but because we
didn't implement ->truncate() we knew that we wouldn't modify the
(already adjusted) allocation.  Not buggy, Christoph, just a roundabout
way to get the job done.
	The new simple_setsize() does nothing but update i_size and trim
the pagecache, right Nick?  If that's so, that's all we need.

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
