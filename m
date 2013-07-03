From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 03 Jul 2013 22:34:38 -0000
Subject: [Ocfs2-devel] [PATCH v3 22/25] ocfs2: Change how dentry's
 d_lock field is accessed
In-Reply-To: <1372882922-23205-1-git-send-email-Waiman.Long@hp.com>
References: <1372882922-23205-1-git-send-email-Waiman.Long@hp.com>
Message-ID: <20130703223414.GA6392@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andi Kleen <andi@firstfloor.org>, "Chandramouleeswaran, Aswin" <aswin@hp.com>, "Norton, Scott J" <scott.norton@hp.com>

On Wed, Jul 03, 2013 at 04:22:02PM -0400, Waiman Long wrote:
> Because of the changes made in dcache.h header file, files that
> use the d_lock field of the dentry structure need to be changed
> accordingly. All the d_lock's spin_lock() and spin_unlock() calls
> are replaced by the corresponding d_lock() and d_unlock() calls.
> There is no change in logic and everything should just work.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

This looks reasonable, but I'll wait for the followup from Linus' review.

Joel

> ---
>  fs/ocfs2/dcache.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index ef99972..4f72906 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -173,17 +173,17 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
>  
>  	spin_lock(&inode->i_lock);
>  	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
> -		spin_lock(&dentry->d_lock);
> +		d_lock(dentry);
>  		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
>  			trace_ocfs2_find_local_alias(dentry->d_name.len,
>  						     dentry->d_name.name);
>  
>  			dget_dlock(dentry);
> -			spin_unlock(&dentry->d_lock);
> +			d_unlock(dentry);
>  			spin_unlock(&inode->i_lock);
>  			return dentry;
>  		}
> -		spin_unlock(&dentry->d_lock);
> +		d_unlock(dentry);
>  	}
>  	spin_unlock(&inode->i_lock);
>  	return NULL;
> -- 
> 1.7.1
> 

-- 

"Where are my angels?
 Where's my golden one?
 And where is my hope
 Now that my heroes are gone?"

			http://www.jlbec.org/
			jlbec at evilplan.org
