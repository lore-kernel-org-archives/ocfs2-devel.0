From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Nov 2010 18:46:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Try to free truncate log when
 meeting ENOSPC in write.
In-Reply-To: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
References: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20101104014623.GC14640@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 26, 2010 at 03:29:08PM +0800, Tao Ma wrote:
> Recently, one of our colleagues meet with a problem that if we
> write/delete a 32mb files repeatly, we will get an ENOSPC in
> the end. And the corresponding bug is 1288.
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288
> 
> The real problem is that although we have freed the clusters,
> they are in truncate log and they will be summed up so that
> we can free them once in a whole.
> 
> So this patch just try to resolve it. In case we see -ENOSPC
> in ocfs2_write_begin_no_lock, we will check whether the truncate
> log has enough clusters for our need, if yes, we will try to
> flush the truncate log at that point and try again. This method
> is inspired by Mark Fasheh <mfasheh@suse.com>. Thanks.

	Ok, this is more like what I was thinking about.  I guess I wish
we could do it inside the allocation routines, but I think we have too
many locks at that point.  This patch doesn't help any place that
allocates other than write() and mmap().  Is this something that could
be added to extending truncate and unwritten allocation?
	I agree that we only care to have one pass.  Have you run it
against the test case from
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288?  If so, modulo
any cleanups you did after others commented, I'm happy ;-)

Joel
  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index d840821..de06558 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -439,6 +439,8 @@ struct ocfs2_super
>  	/* rb tree root for refcount lock. */
>  	struct rb_root	osb_rf_lock_tree;
>  	struct ocfs2_refcount_tree *osb_ref_tree_lru;
> +
> +	unsigned int truncated_clusters;

	Make sure you comment what lock is needed to access
truncated_clusters.



-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
