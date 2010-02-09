From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 8 Feb 2010 17:06:39 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a refcount condition checking
In-Reply-To: <201002041330.o145sMME005597@acsinet15.oracle.com>
References: <201002041330.o145sMME005597@acsinet15.oracle.com>
Message-ID: <20100209010639.GI1832@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 04, 2010 at 04:20:18PM -0500, Wengang Wang wrote:
> index 06ccf6a..77ebb6e 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1775,7 +1775,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  					 int *direct_io,
>  					 int *has_refcount)
>  {
> -	int ret = 0, meta_level = 0;
> +	int ret = 0, meta_level = 0, refcount = 0;
>  	struct inode *inode = dentry->d_inode;
>  	loff_t saved_pos, end;
>  
> @@ -1834,6 +1834,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  							       saved_pos,
>  							       count,
>  							       &meta_level);
> +			refcount = 1;
>  			if (has_refcount)
>  				*has_refcount = 1;
>  		}

	Tao is right that this is redundant - we're setting two refcount
bits, which is pointless.
	Here's the thing: we know that refcounted extents mean no direct
io.  Instead of adding your 'refcount' bit or Tao's comment, why not
just clear direct_io right here?

@@ -1834,6 +1834,8 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 							       saved_pos,
 							       count,
 							       &meta_level);
 			if (has_refcount)
 				*has_refcount = 1;
+			if (direct_io)
+				*direct_io = 0;
 		}

It's safe to clear if it exists - whether it was zero before, it must be
zero now.

Joel

-- 

"War doesn't determine who's right; war determines who's left."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
