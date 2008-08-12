From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 11 Aug 2008 17:19:01 -0700
Subject: [Ocfs2-devel] [PATCH 09/15] ocfs2: Add extended attribute
	support v3
In-Reply-To: <1218093115-8608-1-git-send-email-tiger.yang@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218093115-8608-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080812001901.GG21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 03:11:55PM +0800, Tiger Yang wrote:
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 390a855..5e89818 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -40,6 +40,9 @@ struct ocfs2_inode_info
>  	/* protects allocation changes on this inode. */
>  	struct rw_semaphore		ip_alloc_sem;
>  
> +	/* protects extended attribute changes on this inode */
> +	struct rw_semaphore		xattr_sem;
> +

ip_xattr_sem please. Every other field in that structure is similarly
prefixed. Xattrs don't get to be special in that regard   ;)
	--Mark

--
Mark Fasheh
