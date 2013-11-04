From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 3 Nov 2013 17:10:00 -0800
Subject: [Ocfs2-devel] [PATCH 5/6] Framework for version LVB
In-Reply-To: <20131018144608.GA4594@shrek.lan>
References: <20131018144608.GA4594@shrek.lan>
Message-ID: <20131104011000.GM29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 18, 2013 at 09:46:12AM -0500, Goldwyn Rodrigues wrote:
> Use the native DLM locks for version control negotiation. Most
> of the framework is taken from gfs2/lock_dlm.c
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/stack_user.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 5660e6d..f417d5e 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -118,6 +118,9 @@ struct ocfs2_live_connection {
>  	enum ocfs2_connection_type	oc_type;
>  	atomic_t                        oc_this_node;
>  	int                             oc_our_slot;
> +	struct dlm_lksb                 oc_version_lksb;
> +	char                            oc_lvb[DLM_LVB_LEN];
> +	struct completion               oc_sync_wait;
>  };
>  
>  struct ocfs2_control_private {
> @@ -796,6 +799,105 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
>  	return 0;
>  }
>  
> +static int lvb_to_version(char *lvb, struct ocfs2_protocol_version *ver)
> +{
> +	struct ocfs2_protocol_version pv;
> +	struct ocfs2_protocol_version *max =
> +		&ocfs2_user_plugin.sp_max_proto;
> +
> +	memcpy(&pv, lvb, sizeof(struct ocfs2_protocol_version));
> +	if ((pv.pv_major == LONG_MIN) || (pv.pv_major == LONG_MAX) ||
> +	    (pv.pv_major > (u8)-1) || (pv.pv_major < 1))
> +		return -ERANGE;
> +	if ((pv.pv_minor == LONG_MIN) || (pv.pv_minor == LONG_MAX) ||
> +	    (pv.pv_minor > (u8)-1) || (pv.pv_minor < 0))
> +		return -ERANGE;
> +	if ((pv.pv_major != max->pv_major) ||
> +	    (pv.pv_minor > max->pv_minor))
> +		return -EINVAL;
> +	ver->pv_major = pv.pv_major;
> +	ver->pv_minor = pv.pv_minor;
> +	return 0;
> +}

I don't like that lvb_to_version() can return error - I would prefer that
validation of the lvb contents happen _outside_ the conversion function.
There should actually never be a reason to fail converting an lvb and any
corruptions, etc should be caught afterwards.


> +static void version_to_lvb(struct ocfs2_protocol_version *ver, char *lvb)
> +{
> +	memcpy(lvb, ver, sizeof(struct ocfs2_protocol_version));
> +}

You'll need to account for mixed-endian clusters here and above. Look at
ocfs_stuff_meta_lvb() and ocfs2_refresh_inode_from_lvb() to see what I'm
talking about. Since the lvb goes over the network we chose a big-endian
representation there.


> +static void sync_wait_cb(void *arg)
> +{
> +	struct ocfs2_cluster_connection *conn = arg;
> +	struct ocfs2_live_connection *lc = conn->cc_private;
> +	complete(&lc->oc_sync_wait);
> +}
> +
> +static int sync_unlock(struct ocfs2_cluster_connection *conn,
> +		struct dlm_lksb *lksb, char *name)
> +{
> +	int error;
> +	struct ocfs2_live_connection *lc = conn->cc_private;
> +
> +	error = dlm_unlock(conn->cc_lockspace, lksb->sb_lkid, 0, lksb, conn);
> +	if (error) {
> +		printk(KERN_ERR "%s lkid %x error %d\n",
> +				name, lksb->sb_lkid, error);
> +		return error;
> +	}
> +
> +	wait_for_completion(&lc->oc_sync_wait);
> +
> +	if (lksb->sb_status != -DLM_EUNLOCK) {
> +		printk(KERN_ERR "%s lkid %x status %d\n",
> +				name, lksb->sb_lkid, lksb->sb_status);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static int sync_lock(struct ocfs2_cluster_connection *conn,
> +		int mode, uint32_t flags, 
> +		struct dlm_lksb *lksb, char *name)
> +{
> +	int error, status;
> +	struct ocfs2_live_connection *lc = conn->cc_private;
> +
> +	error = dlm_lock(conn->cc_lockspace, mode, lksb, flags,
> +			name, strlen(name),
> +			0, sync_wait_cb, conn, NULL);
> +	if (error) {
> +		printk(KERN_ERR "%s lkid %x flags %x mode %d error %d\n",
> +				name, lksb->sb_lkid, flags, mode, error);
> +		return error;
> +	}
> +
> +	wait_for_completion(&lc->oc_sync_wait);
> +
> +	status = lksb->sb_status;
> +
> +	if (status && status != -EAGAIN) {
> +		printk(KERN_ERR "%s lkid %x flags %x mode %d status %d\n",
> +				name, lksb->sb_lkid, flags, mode, status);
> +	}
> +
> +	return status;
> +}
> +
> +
> +static int version_lock(struct ocfs2_cluster_connection *conn, int mode,
> +		int flags)
> +{
> +	struct ocfs2_live_connection *lc = conn->cc_private;
> +	return sync_lock(conn, mode, flags, 
> +			&lc->oc_version_lksb, "version_lock");
> +}

#define	VERSION_LOCK_NAME	"version_lock"

and take the "name" argument out of sync_lock().
	--Mark

--
Mark Fasheh
