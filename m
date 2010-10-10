From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 10 Oct 2010 03:51:11 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add a mount option
 "coherency=*" for O_DIRECT writes.
In-Reply-To: <1286623602-7559-1-git-send-email-tristan.ye@oracle.com>
References: <1286623602-7559-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101010105110.GS13876@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 09, 2010 at 07:26:41PM +0800, Tristan Ye wrote:
> Currently, default behavior of O_DIRECT writes was allowing
> concurrent writing among nodes, no cluster coherency guaranteed
> (no EX locks was taken), it hurts buffered reads on other nodes
> by reading stale data from cache.
> 
> The new mount option introduce a chance to choose two different
> behaviors for O_DIRECT writes:
> 
>     * coherency=full, as the default value, will disallow
> 		      concurrent O_DIRECT writes by taking
> 		      EX locks.
> 
>     * coherency=buffered, allow concurrent O_DIRECT writes
> 			  without EX lock among nodes, which
> 			  gains high performance at risk of
> 			  getting stale data on other nodes.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	I think these two patches should be combined into one.  It's not
a lot of change, and it makes sense as one unit.

> @@ -631,6 +635,14 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
>  		goto out;
>  	}
>  
> +	if ((osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED) !=
> +	    (parsed_options.mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED)) {
> +		ret = -EINVAL;
> +		mlog(ML_ERROR, "Cannot change cluster coherency mode on "
> +		     "remount\n");
> +		goto out;
> +	}

	Don't include this.  I think it's a feature to allow coherency
mode to be changed on the fly.  It doesn't hurt us any; it is a safe
thing to change.

Joel

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
