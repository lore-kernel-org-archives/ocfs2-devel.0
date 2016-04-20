From: Gang He <ghe@suse.com>
Date: Wed, 20 Apr 2016 00:36:28 -0600
Subject: [Ocfs2-devel] linux-4.6-rc2/fs/ocfs2/refcounttree.c:987]:
 (style) Redundant condition
In-Reply-To: <DUB128-W561D1B4C5EA0D014C351739C9F0@phx.gbl>
References: <DUB128-W561D1B4C5EA0D014C351739C9F0@phx.gbl>
Message-ID: <571793EC020000F900032FC9@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes, "!eb || !eb.h_next_leaf_blk" looks more readable.

Thanks
Gang



>>> 
> Hello there,
> 
> linux-4.6-rc2/fs/ocfs2/refcounttree.c:987]: (style) Redundant condition: eb. 
> '!eb || (eb && !eb.h_next_leaf_blk)' is equivalent to '!eb || 
> !eb.h_next_leaf_blk'
> 
> Source code is
> 
>         if (!eb || (eb && !eb->h_next_leaf_blk)) {
> 
> Also,
> 
> linux-4.6-rc2/fs/ocfs2/refcounttree.c:1011] -> 
> [linux-4.6-rc2/fs/ocfs2/refcounttree.c:987]: (warning) Either the condition 
> 'eb' is redundant or there is possible null pointer dereference: eb.
> 
> 
> Regards
> 
> David Binderman
> 
>  		 	   		  
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
