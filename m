From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 02 Sep 2009 12:59:43 +0800
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
 ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <20090902015158.GA9165@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com>
	<20090901202111.GH3826@mail.oracle.com>
	<20090902015158.GA9165@mail.oracle.com>
Message-ID: <4A9DFBBF.1010102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Tue, Sep 01, 2009 at 01:21:12PM -0700, Joel Becker wrote:
> There are multiple problems to have.
> 
> 1) We have trouble allocating space for a new xattr.  This leaves us
>    with an empty xattr.
> 2) We overwrote an existing local xattr with a value root, and now we
>    have an error allocating the storage.  This leaves us an empty xattr.
>    where there used to be a value.  The value is lost.
> 3) We have trouble truncating a reused value.  This leaves us with the
>    original entry pointing to the truncated original value.  The value
>    is lost.
> 4) We have trouble extending the storage on a reused value.  This leaves
>    us with the original value safely in place, but with more storage
>    allocated when needed.
> 
> This doesn't consider storing local xattrs (values that don't require a
> btree).  Those only fail when the journal fails.
> 
> Case (1) is easy.  We just remove the xattr we added.  We leak the
> storage because we can't safely remove it, but otherwise everything is
> happy.  We'll print a warning about the leak.
> 
> Case (4) is easy.  We still have the original value in place.  We can
> just leave the extra storage attached to this xattr.  We return the
> error, but the old value is untouched.  We print a warning about the
> storage.
> 
> Case (2) and (3) are hard because we've lost the original values.  In
> the old code, we ended up with values that could be partially read.
> That's not good.  Instead, we just wipe the xattr entry and leak the
> storage.  It stinks that the original value is lost, but now there isn't
> a partial value to be read.  We'll print a big fat warning.
actually case (2) is rarely to happen since we should have already 
reserved enough clusters before we start the transaction. As for (3), 
the only chance is that the b-tree is corrupted. And in this case, I 
think remove the corrupted b-tree root is OK for me.

small comments for the patch.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |  141 +++++++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 125 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index f62985a..20323bb 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1897,17 +1908,87 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>  	}
>  }
>  
> + * If the value tree grew, it obviously didn't grow enough for the
> + * new entry.  We're not going to try and reclaim those clusters either.
> + * If there was already an external value there (orig_clusters != 0),
> + * the new clusters are attached safely and we can just leave the old
> + * value in place.  If there was no external value there, we remove
> + * then entry.
the entry.
> + *
> + * This way, the xattr block we store in the journal will be consistent.
> + * If the size change broke because of the journal, no changes will hit
> + * disk anyway.
> + */
> +static void ocfs2_xa_cleanup_value_truncate(struct ocfs2_xa_loc *loc,
> +					    const char *what,
> +					    unsigned int orig_clusters)
> +{
> +	unsigned int new_clusters = ocfs2_xa_value_clusters(loc);
> +	char *nameval_buf = ocfs2_xa_offset_pointer(loc,
> +				le16_to_cpu(loc->xl_entry->xe_name_offset));
> +
> +	if (new_clusters < orig_clusters) {
> +		mlog(ML_ERROR,
> +		     "Partial truncate while %s xattr %.*s.  Leaking "
> +		     "%u clusters and removing the entry\n",
> +		     what, loc->xl_entry->xe_name_len, nameval_buf,
> +		     orig_clusters - new_clusters);
> +		ocfs2_xa_remove_entry(loc);
> +	} else if (!orig_clusters) {
> +		mlog(ML_ERROR,
> +		     "Unable to allocate an external value for xattr "
> +		     "%.*s safely.  Leaking %u clusters and removing the "
> +		     "entry\n",
> +		     loc->xl_entry->xe_name_len, nameval_buf,
> +		     new_clusters - orig_clusters);
> +		ocfs2_xa_remove_entry(loc);
> +	} else if (new_clusters > orig_clusters)
> +		mlog(ML_ERROR,
> +		     "Unable to grow xattr %.*s safely.  %u new clusters "
> +		     "have been added, but the value will not be "
> +		     "modified\n",
> +		     loc->xl_entry->xe_name_len, nameval_buf,
> +		     new_clusters - orig_clusters);
> +}
> +
>  static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
>  			   struct ocfs2_xattr_set_ctxt *ctxt)
>  {
>  	int rc;
> +	unsigned int orig_clusters;
>  
>  	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
> +		orig_clusters = ocfs2_xa_value_clusters(loc);
>  		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
>  		if (rc) {
>  			mlog_errno(rc);
> -			goto out;
> +			/*
> +			 * Since this is remove, we can return 0 if
> +			 * ocfs2_xa_cleanup_value_truncate() is going to
> +			 * wipe the entry anyway.  So we check the
> +			 * cluster count as well.
> +			 */
> +			if (orig_clusters != ocfs2_xa_value_clusters(loc))
> +				rc = 0;
> +			ocfs2_xa_cleanup_value_truncate(loc, "removing",
> +							orig_clusters);
>  		}
> +
> +		if (rc)
> +			goto out;
move this after ocfs2_xa_cleanup_value_truncate. No need to check it 
twice. And even if you set rc = 0 above, in 
ocfs2_xa_cleanup_value_truncate(new_clusters < orig_clusters) we will 
remove the entry I think. So we don't need to call ocfs2_xa_remove_entry 
below.

OK, I think I have finished reviewing the whole patch set. Thanks for 
the work. You can add my ACK to this set now. And once it get merged 
into merge-window, I can ask tristan to run it with his xattr test case.

Regards,
Tao
