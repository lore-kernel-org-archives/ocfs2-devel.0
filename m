From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jul 28 16:07:01 2004
Subject: [Ocfs2-devel] A patch to fix a typo error in ocfs_file_read(),
	which causes performance drop.
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E04C6FCE0@pdsmsx403>
References: <37FBBA5F3A361C41AB7CE44558C3448E04C6FCE0@pdsmsx403>
Message-ID: <20040728210031.GA8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

heh, can't believe we missed that!
	--Mark

On Wed, Jul 28, 2004 at 03:08:28PM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	I found a typo error in ocfs_file_read(), which causes
> performance drop.
> 	See my patch. 
> 
> 	Thanks.
> 
> 
> --------------------------------------
> --- file.c.old	2004-07-28 14:58:00.018535576 +0800
> +++ file.c	2004-07-28 14:58:32.835546632 +0800
> @@ -853,11 +853,9 @@
>  			filp->f_flags |= O_DIRECT;
>  		else
>  			filp->f_flags &= ~O_DIRECT;
> -		ret = generic_file_write (filp, buf, count, ppos);
> +		ret = generic_file_read (filp, buf, count, ppos);
>  		filp->f_flags = savedflags;
>  	}
> -
> -	ret = generic_file_read (filp, buf, count, ppos);
>  #else
>  	if (do_direct_io) 
>  		ret = ocfs_rw_direct (READ, filp, buf, count, ppos);
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
