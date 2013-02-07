From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 7 Feb 2013 09:33:49 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add freeze protection to
 ocfs2_file_splice_write()
In-Reply-To: <1360248739-24836-4-git-send-email-jack@suse.cz>
References: <1360248739-24836-1-git-send-email-jack@suse.cz>
	<1360248739-24836-4-git-send-email-jack@suse.cz>
Message-ID: <20130207173348.GA29575@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Feb 07, 2013 at 03:52:19PM +0100, Jan Kara wrote:
> ocfs2_file_splice_write() was missed when adding freeze protection to all
> write paths. Fix that.
> 
> CC: Joel Becker <jlbec@evilplan.org>
> CC: ocfs2-devel at oss.oracle.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/file.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 3898499..1f6916c 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2468,6 +2468,9 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
>  			out->f_path.dentry->d_name.len,
>  			out->f_path.dentry->d_name.name, len);
>  
> +	if (!sb_start_file_write(out))
> +		return -EAGAIN;
> +
>  	if (pipe->inode)
>  		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
>  
> @@ -2506,6 +2509,7 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
>  
>  		balance_dirty_pages_ratelimited(mapping);
>  	}
> +	sb_end_write(inode->i_sb);
>  
>  	return ret;
>  }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

			http://www.jlbec.org/
			jlbec at evilplan.org
