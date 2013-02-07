From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 6 Feb 2013 19:55:34 -0800
Subject: [Ocfs2-devel] + ocfs2-convert-to-idr_alloc.patch added to -mm
	tree
In-Reply-To: <20130206223933.2832D31C1FF@corp2gmr1-1.hot.corp.google.com>
References: <20130206223933.2832D31C1FF@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20130207035533.GA26760@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 06, 2013 at 02:39:32PM -0800, akpm at linux-foundation.org wrote:
> 
> The patch titled
>      Subject: ocfs2: convert to idr_alloc()
> has been added to the -mm tree.  Its filename is
>      ocfs2-convert-to-idr_alloc.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Tejun Heo <tj@kernel.org>
> Subject: ocfs2: convert to idr_alloc()
> 
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
> 
>  fs/ocfs2/cluster/tcp.c |   32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-convert-to-idr_alloc fs/ocfs2/cluster/tcp.c
> --- a/fs/ocfs2/cluster/tcp.c~ocfs2-convert-to-idr_alloc
> +++ a/fs/ocfs2/cluster/tcp.c
> @@ -304,28 +304,22 @@ static u8 o2net_num_from_nn(struct o2net
>  
>  static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
>  {
> -	int ret = 0;
> -
> -	do {
> -		if (!idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC)) {
> -			ret = -EAGAIN;
> -			break;
> -		}
> -		spin_lock(&nn->nn_lock);
> -		ret = idr_get_new(&nn->nn_status_idr, nsw, &nsw->ns_id);
> -		if (ret == 0)
> -			list_add_tail(&nsw->ns_node_item,
> -				      &nn->nn_status_list);
> -		spin_unlock(&nn->nn_lock);
> -	} while (ret == -EAGAIN);
> +	int ret;
>  
> -	if (ret == 0)  {
> -		init_waitqueue_head(&nsw->ns_wq);
> -		nsw->ns_sys_status = O2NET_ERR_NONE;
> -		nsw->ns_status = 0;
> +	spin_lock(&nn->nn_lock);
> +	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
> +	if (ret >= 0) {
> +		nsw->ns_id = ret;
> +		list_add_tail(&nsw->ns_node_item, &nn->nn_status_list);
>  	}
> +	spin_unlock(&nn->nn_lock);
> +	if (ret < 0)
> +		return ret;
>  
> -	return ret;
> +	init_waitqueue_head(&nsw->ns_wq);
> +	nsw->ns_sys_status = O2NET_ERR_NONE;
> +	nsw->ns_status = 0;
> +	return 0;
>  }
>  
>  static void o2net_complete_nsw_locked(struct o2net_node *nn,
> _
> 
> Patches currently in -mm which might be from tj at kernel.org are
> 
> linux-next.patch
> cfq-fix-lock-imbalance-with-failed-allocations.patch
> block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
> memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
> memcg-clean-up-swap-accounting-initialization-code.patch
> memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
> memcg-split-part-of-memcg-creation-to-css_online.patch
> memcg-fast-hierarchy-aware-child-test.patch
> memcg-fast-hierarchy-aware-child-test-fix.patch
> memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
> memcg-increment-static-branch-right-after-limit-set.patch
> memcg-avoid-dangling-reference-count-in-creation-failure.patch
> idr-fix-a-subtle-bug-in-idr_get_next.patch
> idr-make-idr_destroy-imply-idr_remove_all.patch
> atm-nicstar-dont-use-idr_remove_all.patch
> block-loop-dont-use-idr_remove_all.patch
> firewire-dont-use-idr_remove_all.patch
> drm-dont-use-idr_remove_all.patch
> dm-dont-use-idr_remove_all.patch
> remoteproc-dont-use-idr_remove_all.patch
> rpmsg-dont-use-idr_remove_all.patch
> dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
> dlm-dont-use-idr_remove_all.patch
> nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
> inotify-dont-use-idr_remove_all.patch
> cgroup-dont-use-idr_remove_all.patch
> idr-deprecate-idr_remove_all.patch
> idr-cosmetic-updates-to-struct-initializer-definitions.patch
> idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
> idr-remove-_idr_rc_to_errno-hack.patch
> idr-refactor-idr_get_new_above.patch
> idr-implement-idr_preload-and-idr_alloc.patch
> block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
> block-convert-to-idr_alloc.patch
> block-loop-convert-to-idr_alloc.patch
> atm-nicstar-convert-to-idr_alloc.patch
> drbd-convert-to-idr_alloc.patch
> dca-convert-to-idr_alloc.patch
> dmaengine-convert-to-idr_alloc.patch
> firewire-add-minor-number-range-check-to-fw_device_init.patch
> firewire-convert-to-idr_alloc.patch
> gpio-convert-to-idr_alloc.patch
> drm-convert-to-idr_alloc.patch
> drm-exynos-convert-to-idr_alloc.patch
> drm-i915-convert-to-idr_alloc.patch
> drm-sis-convert-to-idr_alloc.patch
> drm-via-convert-to-idr_alloc.patch
> drm-vmwgfx-convert-to-idr_alloc.patch
> i2c-convert-to-idr_alloc.patch
> ib-core-convert-to-idr_alloc.patch
> ib-amso1100-convert-to-idr_alloc.patch
> ib-cxgb3-convert-to-idr_alloc.patch
> ib-cxgb4-convert-to-idr_alloc.patch
> ib-ehca-convert-to-idr_alloc.patch
> ib-ipath-convert-to-idr_alloc.patch
> ib-mlx4-convert-to-idr_alloc.patch
> ib-ocrdma-convert-to-idr_alloc.patch
> ib-qib-convert-to-idr_alloc.patch
> dm-convert-to-idr_alloc.patch
> memstick-convert-to-idr_alloc.patch
> mfd-convert-to-idr_alloc.patch
> misc-c2port-convert-to-idr_alloc.patch
> misc-tifm_core-convert-to-idr_alloc.patch
> mmc-convert-to-idr_alloc.patch
> mtd-convert-to-idr_alloc.patch
> macvtap-convert-to-idr_alloc.patch
> ppp-convert-to-idr_alloc.patch
> power-convert-to-idr_alloc.patch
> pps-convert-to-idr_alloc.patch
> remoteproc-convert-to-idr_alloc.patch
> rpmsg-convert-to-idr_alloc.patch
> scsi-bfa-convert-to-idr_alloc.patch
> scsi-convert-to-idr_alloc.patch
> target-iscsi-convert-to-idr_alloc.patch
> scsi-lpfc-convert-to-idr_alloc.patch
> thermal-convert-to-idr_alloc.patch
> uio-convert-to-idr_alloc.patch
> vfio-convert-to-idr_alloc.patch
> dlm-convert-to-idr_alloc.patch
> inotify-convert-to-idr_alloc.patch
> ocfs2-convert-to-idr_alloc.patch
> ipc-convert-to-idr_alloc.patch
> cgroup-convert-to-idr_alloc.patch
> events-convert-to-idr_alloc.patch
> posix-timers-convert-to-idr_alloc.patch
> net-9p-convert-to-idr_alloc.patch
> mac80211-convert-to-idr_alloc.patch
> sctp-convert-to-idr_alloc.patch
> nfs4client-convert-to-idr_alloc.patch
> 

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

			http://www.jlbec.org/
			jlbec at evilplan.org
