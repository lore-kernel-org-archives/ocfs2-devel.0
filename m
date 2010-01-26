From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 25 Jan 2010 19:52:46 -0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2/trivial: Remove trailing
	whitespaces
In-Reply-To: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
References: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100126035246.GF15982@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 25, 2010 at 04:57:38PM -0800, Sunil Mushran wrote:
> Patch removes trailing whitespaces.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This patch is now part of the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/aops.c                 |    4 ++--
>  fs/ocfs2/buffer_head_io.c       |    2 +-
>  fs/ocfs2/cluster/heartbeat.c    |    6 +++---
>  fs/ocfs2/cluster/tcp.c          |    4 ++--
>  fs/ocfs2/cluster/tcp_internal.h |    4 ++--
>  fs/ocfs2/dlm/dlmapi.h           |    2 +-
>  fs/ocfs2/dlm/dlmast.c           |    2 +-
>  fs/ocfs2/dlm/dlmconvert.c       |    2 +-
>  fs/ocfs2/dlm/dlmdomain.c        |    2 +-
>  fs/ocfs2/dlm/dlmlock.c          |    2 +-
>  fs/ocfs2/dlm/dlmmaster.c        |   38 +++++++++++++++++++-------------------
>  fs/ocfs2/dlm/dlmrecovery.c      |   38 +++++++++++++++++++-------------------
>  fs/ocfs2/dlm/dlmunlock.c        |    8 ++++----
>  fs/ocfs2/dlmglue.c              |    2 +-
>  fs/ocfs2/export.c               |    2 +-
>  fs/ocfs2/file.c                 |   14 +++++++-------
>  fs/ocfs2/inode.c                |    4 ++--
>  fs/ocfs2/journal.c              |    2 +-
>  fs/ocfs2/super.c                |    2 +-
>  fs/ocfs2/uptodate.c             |    4 ++--
>  20 files changed, 72 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 3dae4a1..7e9df11 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -599,7 +599,7 @@ bail:
>  	return ret;
>  }
>  
> -/* 
> +/*
>   * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
>   * particularly interested in the aio/dio case.  Like the core uses
>   * i_alloc_sem, we use the rw_lock DLM lock to protect io on one node from
> @@ -670,7 +670,7 @@ static ssize_t ocfs2_direct_IO(int rw,
>  
>  	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
>  					    inode->i_sb->s_bdev, iov, offset,
> -					    nr_segs, 
> +					    nr_segs,
>  					    ocfs2_direct_IO_get_blocks,
>  					    ocfs2_dio_end_io);
>  
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index d43d34a..21c808f 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -368,7 +368,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  	}
>  	ocfs2_metadata_cache_io_unlock(ci);
>  
> -	mlog(ML_BH_IO, "block=(%llu), nr=(%d), cached=%s, flags=0x%x\n", 
> +	mlog(ML_BH_IO, "block=(%llu), nr=(%d), cached=%s, flags=0x%x\n",
>  	     (unsigned long long)block, nr,
>  	     ((flags & OCFS2_BH_IGNORE_CACHE) || ignore_cache) ? "no" : "yes",
>  	     flags);
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index eda5b8b..5c98900 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -78,7 +78,7 @@ static struct o2hb_callback *hbcall_from_type(enum o2hb_callback_type type);
>  
>  unsigned int o2hb_dead_threshold = O2HB_DEFAULT_DEAD_THRESHOLD;
>  
> -/* Only sets a new threshold if there are no active regions. 
> +/* Only sets a new threshold if there are no active regions.
>   *
>   * No locking or otherwise interesting code is required for reading
>   * o2hb_dead_threshold as it can't change once regions are active and
> @@ -170,7 +170,7 @@ static void o2hb_write_timeout(struct work_struct *work)
>  
>  	mlog(ML_ERROR, "Heartbeat write timeout to device %s after %u "
>  	     "milliseconds\n", reg->hr_dev_name,
> -	     jiffies_to_msecs(jiffies - reg->hr_last_timeout_start)); 
> +	     jiffies_to_msecs(jiffies - reg->hr_last_timeout_start));
>  	o2quo_disk_timeout();
>  }
>  
> @@ -624,7 +624,7 @@ static int o2hb_check_slot(struct o2hb_region *reg,
>  	     "seq %llu last %llu changed %u equal %u\n",
>  	     slot->ds_node_num, (long long)slot->ds_last_generation,
>  	     le32_to_cpu(hb_block->hb_cksum),
> -	     (unsigned long long)le64_to_cpu(hb_block->hb_seq), 
> +	     (unsigned long long)le64_to_cpu(hb_block->hb_seq),
>  	     (unsigned long long)slot->ds_last_time, slot->ds_changed_samples,
>  	     slot->ds_equal_samples);
>  
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 334f231..938ba18 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -930,7 +930,7 @@ static void o2net_sendpage(struct o2net_sock_container *sc,
>  			cond_resched();
>  			continue;
>  		}
> -		mlog(ML_ERROR, "sendpage of size %zu to " SC_NODEF_FMT 
> +		mlog(ML_ERROR, "sendpage of size %zu to " SC_NODEF_FMT
>  		     " failed with %zd\n", size, SC_NODEF_ARGS(sc), ret);
>  		o2net_ensure_shutdown(nn, sc, 0);
>  		break;
> @@ -1483,7 +1483,7 @@ static void o2net_idle_timer(unsigned long data)
>  	mlog(ML_NOTICE, "here are some times that might help debug the "
>  	     "situation: (tmr %ld.%ld now %ld.%ld dr %ld.%ld adv "
>  	     "%ld.%ld:%ld.%ld func (%08x:%u) %ld.%ld:%ld.%ld)\n",
> -	     sc->sc_tv_timer.tv_sec, (long) sc->sc_tv_timer.tv_usec, 
> +	     sc->sc_tv_timer.tv_sec, (long) sc->sc_tv_timer.tv_usec,
>  	     now.tv_sec, (long) now.tv_usec,
>  	     sc->sc_tv_data_ready.tv_sec, (long) sc->sc_tv_data_ready.tv_usec,
>  	     sc->sc_tv_advance_start.tv_sec,
> diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
> index 8d58cfe..96fa7eb 100644
> --- a/fs/ocfs2/cluster/tcp_internal.h
> +++ b/fs/ocfs2/cluster/tcp_internal.h
> @@ -32,10 +32,10 @@
>   * on their number */
>  #define O2NET_QUORUM_DELAY_MS	((o2hb_dead_threshold + 2) * O2HB_REGION_TIMEOUT_MS)
>  
> -/* 
> +/*
>   * This version number represents quite a lot, unfortunately.  It not
>   * only represents the raw network message protocol on the wire but also
> - * locking semantics of the file system using the protocol.  It should 
> + * locking semantics of the file system using the protocol.  It should
>   * be somewhere else, I'm sure, but right now it isn't.
>   *
>   * With version 11, we separate out the filesystem locking portion.  The
> diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
> index b5786a7..3cfa114 100644
> --- a/fs/ocfs2/dlm/dlmapi.h
> +++ b/fs/ocfs2/dlm/dlmapi.h
> @@ -95,7 +95,7 @@ const char *dlm_errname(enum dlm_status err);
>  		mlog(ML_ERROR, "dlm status = %s\n", dlm_errname((st)));	\
>  } while (0)
>  
> -#define DLM_LKSB_UNUSED1           0x01  
> +#define DLM_LKSB_UNUSED1           0x01
>  #define DLM_LKSB_PUT_LVB           0x02
>  #define DLM_LKSB_GET_LVB           0x04
>  #define DLM_LKSB_UNUSED2           0x08
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index 01cf8cc..dccc439 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -123,7 +123,7 @@ static void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  		dlm_lock_put(lock);
>  		/* free up the reserved bast that we are cancelling.
>  		 * guaranteed that this will not be the last reserved
> -		 * ast because *both* an ast and a bast were reserved 
> +		 * ast because *both* an ast and a bast were reserved
>  		 * to get to this point.  the res->spinlock will not be
>  		 * taken here */
>  		dlm_lockres_release_ast(dlm, res);
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index ca96bce..f283bce 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -396,7 +396,7 @@ static enum dlm_status dlm_send_remote_convert_request(struct dlm_ctxt *dlm,
>  			/* instead of logging the same network error over
>  			 * and over, sleep here and wait for the heartbeat
>  			 * to notice the node is dead.  times out after 5s. */
> -			dlm_wait_for_node_death(dlm, res->owner, 
> +			dlm_wait_for_node_death(dlm, res->owner,
>  						DLM_NODE_DEATH_WAIT_MAX);
>  			ret = DLM_RECOVERING;
>  			mlog(0, "node %u died so returning DLM_RECOVERING "
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 0334000..988c905 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -816,7 +816,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  
>  	/* Once the dlm ctxt is marked as leaving then we don't want
> -	 * to be put in someone's domain map. 
> +	 * to be put in someone's domain map.
>  	 * Also, explicitly disallow joining at certain troublesome
>  	 * times (ie. during recovery). */
>  	if (dlm && dlm->dlm_state != DLM_CTXT_LEAVING) {
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 437698e..7333377 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -269,7 +269,7 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
>  		}
>  		dlm_revert_pending_lock(res, lock);
>  		dlm_lock_put(lock);
> -	} else if (dlm_is_recovery_lock(res->lockname.name, 
> +	} else if (dlm_is_recovery_lock(res->lockname.name,
>  					res->lockname.len)) {
>  		/* special case for the $RECOVERY lock.
>  		 * there will never be an AST delivered to put
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 03ccf9a..a659606 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -366,7 +366,7 @@ void dlm_hb_event_notify_attached(struct dlm_ctxt *dlm, int idx, int node_up)
>  	struct dlm_master_list_entry *mle;
>  
>  	assert_spin_locked(&dlm->spinlock);
> -	
> +
>  	list_for_each_entry(mle, &dlm->mle_hb_events, hb_events) {
>  		if (node_up)
>  			dlm_mle_node_up(dlm, mle, NULL, idx);
> @@ -833,7 +833,7 @@ lookup:
>  		__dlm_insert_mle(dlm, mle);
>  
>  		/* still holding the dlm spinlock, check the recovery map
> -		 * to see if there are any nodes that still need to be 
> +		 * to see if there are any nodes that still need to be
>  		 * considered.  these will not appear in the mle nodemap
>  		 * but they might own this lockres.  wait on them. */
>  		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
> @@ -883,7 +883,7 @@ redo_request:
>  				msleep(500);
>  			}
>  			continue;
> -		} 
> +		}
>  
>  		dlm_kick_recovery_thread(dlm);
>  		msleep(1000);
> @@ -939,8 +939,8 @@ wait:
>  		     res->lockname.name, blocked);
>  		if (++tries > 20) {
>  			mlog(ML_ERROR, "%s:%.*s: spinning on "
> -			     "dlm_wait_for_lock_mastery, blocked=%d\n", 
> -			     dlm->name, res->lockname.len, 
> +			     "dlm_wait_for_lock_mastery, blocked=%d\n",
> +			     dlm->name, res->lockname.len,
>  			     res->lockname.name, blocked);
>  			dlm_print_one_lock_resource(res);
>  			dlm_print_one_mle(mle);
> @@ -1029,7 +1029,7 @@ recheck:
>  		ret = dlm_restart_lock_mastery(dlm, res, mle, *blocked);
>  		b = (mle->type == DLM_MLE_BLOCK);
>  		if ((*blocked && !b) || (!*blocked && b)) {
> -			mlog(0, "%s:%.*s: status change: old=%d new=%d\n", 
> +			mlog(0, "%s:%.*s: status change: old=%d new=%d\n",
>  			     dlm->name, res->lockname.len, res->lockname.name,
>  			     *blocked, b);
>  			*blocked = b;
> @@ -1602,7 +1602,7 @@ send_response:
>  		}
>  		mlog(0, "%u is the owner of %.*s, cleaning everyone else\n",
>  			     dlm->node_num, res->lockname.len, res->lockname.name);
> -		ret = dlm_dispatch_assert_master(dlm, res, 0, request->node_idx, 
> +		ret = dlm_dispatch_assert_master(dlm, res, 0, request->node_idx,
>  						 DLM_ASSERT_MASTER_MLE_CLEANUP);
>  		if (ret < 0) {
>  			mlog(ML_ERROR, "failed to dispatch assert master work\n");
> @@ -1701,7 +1701,7 @@ again:
>  
>  		if (r & DLM_ASSERT_RESPONSE_REASSERT) {
>  			mlog(0, "%.*s: node %u create mles on other "
> -			     "nodes and requests a re-assert\n", 
> +			     "nodes and requests a re-assert\n",
>  			     namelen, lockname, to);
>  			reassert = 1;
>  		}
> @@ -1812,7 +1812,7 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
>  				spin_unlock(&dlm->master_lock);
>  				spin_unlock(&dlm->spinlock);
>  				goto done;
> -			}	
> +			}
>  		}
>  	}
>  	spin_unlock(&dlm->master_lock);
> @@ -1883,7 +1883,7 @@ ok:
>  		int extra_ref = 0;
>  		int nn = -1;
>  		int rr, err = 0;
> -		
> +
>  		spin_lock(&mle->spinlock);
>  		if (mle->type == DLM_MLE_BLOCK || mle->type == DLM_MLE_MIGRATION)
>  			extra_ref = 1;
> @@ -1891,7 +1891,7 @@ ok:
>  			/* MASTER mle: if any bits set in the response map
>  			 * then the calling node needs to re-assert to clear
>  			 * up nodes that this node contacted */
> -			while ((nn = find_next_bit (mle->response_map, O2NM_MAX_NODES, 
> +			while ((nn = find_next_bit (mle->response_map, O2NM_MAX_NODES,
>  						    nn+1)) < O2NM_MAX_NODES) {
>  				if (nn != dlm->node_num && nn != assert->node_idx)
>  					master_request = 1;
> @@ -2002,7 +2002,7 @@ kill:
>  	__dlm_print_one_lock_resource(res);
>  	spin_unlock(&res->spinlock);
>  	spin_unlock(&dlm->spinlock);
> -	*ret_data = (void *)res; 
> +	*ret_data = (void *)res;
>  	dlm_put(dlm);
>  	return -EINVAL;
>  }
> @@ -2040,10 +2040,10 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
>  	item->u.am.request_from = request_from;
>  	item->u.am.flags = flags;
>  
> -	if (ignore_higher) 
> -		mlog(0, "IGNORE HIGHER: %.*s\n", res->lockname.len, 
> +	if (ignore_higher)
> +		mlog(0, "IGNORE HIGHER: %.*s\n", res->lockname.len,
>  		     res->lockname.name);
> -		
> +
>  	spin_lock(&dlm->work_lock);
>  	list_add_tail(&item->list, &dlm->work_list);
>  	spin_unlock(&dlm->work_lock);
> @@ -2133,7 +2133,7 @@ put:
>   * think that $RECOVERY is currently mastered by a dead node.  If so,
>   * we wait a short time to allow that node to get notified by its own
>   * heartbeat stack, then check again.  All $RECOVERY lock resources
> - * mastered by dead nodes are purged when the hearbeat callback is 
> + * mastered by dead nodes are purged when the hearbeat callback is
>   * fired, so we can know for sure that it is safe to continue once
>   * the node returns a live node or no node.  */
>  static int dlm_pre_master_reco_lockres(struct dlm_ctxt *dlm,
> @@ -2174,7 +2174,7 @@ static int dlm_pre_master_reco_lockres(struct dlm_ctxt *dlm,
>  				ret = -EAGAIN;
>  			}
>  			spin_unlock(&dlm->spinlock);
> -			mlog(0, "%s: reco lock master is %u\n", dlm->name, 
> +			mlog(0, "%s: reco lock master is %u\n", dlm->name,
>  			     master);
>  			break;
>  		}
> @@ -2602,7 +2602,7 @@ fail:
>  
>  			mlog(0, "%s:%.*s: timed out during migration\n",
>  			     dlm->name, res->lockname.len, res->lockname.name);
> -			/* avoid hang during shutdown when migrating lockres 
> +			/* avoid hang during shutdown when migrating lockres
>  			 * to a node which also goes down */
>  			if (dlm_is_node_dead(dlm, target)) {
>  				mlog(0, "%s:%.*s: expected migration "
> @@ -2738,7 +2738,7 @@ static int dlm_migration_can_proceed(struct dlm_ctxt *dlm,
>  	can_proceed = !!(res->state & DLM_LOCK_RES_MIGRATING);
>  	spin_unlock(&res->spinlock);
>  
> -	/* target has died, so make the caller break out of the 
> +	/* target has died, so make the caller break out of the
>  	 * wait_event, but caller must recheck the domain_map */
>  	spin_lock(&dlm->spinlock);
>  	if (!test_bit(mig_target, dlm->domain_map))
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 2f9e4e1..57736d3 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1050,7 +1050,7 @@ static void dlm_move_reco_locks_to_list(struct dlm_ctxt *dlm,
>  				if (lock->ml.node == dead_node) {
>  					mlog(0, "AHA! there was "
>  					     "a $RECOVERY lock for dead "
> -					     "node %u (%s)!\n", 
> +					     "node %u (%s)!\n",
>  					     dead_node, dlm->name);
>  					list_del_init(&lock->list);
>  					dlm_lock_put(lock);
> @@ -1839,7 +1839,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>  				 * the lvb. */
>  				memcpy(res->lvb, mres->lvb, DLM_LVB_LEN);
>  			} else {
> -				/* otherwise, the node is sending its 
> +				/* otherwise, the node is sending its
>  				 * most recent valid lvb info */
>  				BUG_ON(ml->type != LKM_EXMODE &&
>  				       ml->type != LKM_PRMODE);
> @@ -2114,7 +2114,7 @@ static void dlm_revalidate_lvb(struct dlm_ctxt *dlm,
>  	assert_spin_locked(&res->spinlock);
>  
>  	if (res->owner == dlm->node_num)
> -		/* if this node owned the lockres, and if the dead node 
> +		/* if this node owned the lockres, and if the dead node
>  		 * had an EX when he died, blank out the lvb */
>  		search_node = dead_node;
>  	else {
> @@ -2152,7 +2152,7 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  
>  	/* this node is the lockres master:
>  	 * 1) remove any stale locks for the dead node
> -	 * 2) if the dead node had an EX when he died, blank out the lvb 
> +	 * 2) if the dead node had an EX when he died, blank out the lvb
>  	 */
>  	assert_spin_locked(&dlm->spinlock);
>  	assert_spin_locked(&res->spinlock);
> @@ -2260,7 +2260,7 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>  				}
>  				spin_unlock(&res->spinlock);
>  				continue;
> -			}			
> +			}
>  			spin_lock(&res->spinlock);
>  			/* zero the lvb if necessary */
>  			dlm_revalidate_lvb(dlm, res, dead_node);
> @@ -2411,7 +2411,7 @@ static void dlm_reco_unlock_ast(void *astdata, enum dlm_status st)
>   * this function on each node racing to become the recovery
>   * master will not stop attempting this until either:
>   * a) this node gets the EX (and becomes the recovery master),
> - * or b) dlm->reco.new_master gets set to some nodenum 
> + * or b) dlm->reco.new_master gets set to some nodenum
>   * != O2NM_INVALID_NODE_NUM (another node will do the reco).
>   * so each time a recovery master is needed, the entire cluster
>   * will sync at this point.  if the new master dies, that will
> @@ -2424,7 +2424,7 @@ static int dlm_pick_recovery_master(struct dlm_ctxt *dlm)
>  
>  	mlog(0, "starting recovery of %s at %lu, dead=%u, this=%u\n",
>  	     dlm->name, jiffies, dlm->reco.dead_node, dlm->node_num);
> -again:	
> +again:
>  	memset(&lksb, 0, sizeof(lksb));
>  
>  	ret = dlmlock(dlm, LKM_EXMODE, &lksb, LKM_NOQUEUE|LKM_RECOVERY,
> @@ -2437,8 +2437,8 @@ again:
>  	if (ret == DLM_NORMAL) {
>  		mlog(0, "dlm=%s dlmlock says I got it (this=%u)\n",
>  		     dlm->name, dlm->node_num);
> -		
> -		/* got the EX lock.  check to see if another node 
> +
> +		/* got the EX lock.  check to see if another node
>  		 * just became the reco master */
>  		if (dlm_reco_master_ready(dlm)) {
>  			mlog(0, "%s: got reco EX lock, but %u will "
> @@ -2451,12 +2451,12 @@ again:
>  			/* see if recovery was already finished elsewhere */
>  			spin_lock(&dlm->spinlock);
>  			if (dlm->reco.dead_node == O2NM_INVALID_NODE_NUM) {
> -				status = -EINVAL;	
> +				status = -EINVAL;
>  				mlog(0, "%s: got reco EX lock, but "
>  				     "node got recovered already\n", dlm->name);
>  				if (dlm->reco.new_master != O2NM_INVALID_NODE_NUM) {
>  					mlog(ML_ERROR, "%s: new master is %u "
> -					     "but no dead node!\n", 
> +					     "but no dead node!\n",
>  					     dlm->name, dlm->reco.new_master);
>  					BUG();
>  				}
> @@ -2468,7 +2468,7 @@ again:
>  		 * set the master and send the messages to begin recovery */
>  		if (!status) {
>  			mlog(0, "%s: dead=%u, this=%u, sending "
> -			     "begin_reco now\n", dlm->name, 
> +			     "begin_reco now\n", dlm->name,
>  			     dlm->reco.dead_node, dlm->node_num);
>  			status = dlm_send_begin_reco_message(dlm,
>  				      dlm->reco.dead_node);
> @@ -2501,7 +2501,7 @@ again:
>  		mlog(0, "dlm=%s dlmlock says another node got it (this=%u)\n",
>  		     dlm->name, dlm->node_num);
>  		/* another node is master. wait on
> -		 * reco.new_master != O2NM_INVALID_NODE_NUM 
> +		 * reco.new_master != O2NM_INVALID_NODE_NUM
>  		 * for at most one second */
>  		wait_event_timeout(dlm->dlm_reco_thread_wq,
>  					 dlm_reco_master_ready(dlm),
> @@ -2599,7 +2599,7 @@ retry:
>  		}
>  		if (ret < 0) {
>  			struct dlm_lock_resource *res;
> -			/* this is now a serious problem, possibly ENOMEM 
> +			/* this is now a serious problem, possibly ENOMEM
>  			 * in the network stack.  must retry */
>  			mlog_errno(ret);
>  			mlog(ML_ERROR, "begin reco of dlm %s to node %u "
> @@ -2612,7 +2612,7 @@ retry:
>  			} else {
>  				mlog(ML_ERROR, "recovery lock not found\n");
>  			}
> -			/* sleep for a bit in hopes that we can avoid 
> +			/* sleep for a bit in hopes that we can avoid
>  			 * another ENOMEM */
>  			msleep(100);
>  			goto retry;
> @@ -2664,7 +2664,7 @@ int dlm_begin_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  	if (dlm->reco.dead_node != O2NM_INVALID_NODE_NUM) {
>  		mlog(ML_NOTICE, "%s: dead_node previously set to %u, "
> -		     "node %u changing it to %u\n", dlm->name, 
> +		     "node %u changing it to %u\n", dlm->name,
>  		     dlm->reco.dead_node, br->node_idx, br->dead_node);
>  	}
>  	dlm_set_reco_master(dlm, br->node_idx);
> @@ -2730,8 +2730,8 @@ stage2:
>  		if (ret < 0) {
>  			mlog_errno(ret);
>  			if (dlm_is_host_down(ret)) {
> -				/* this has no effect on this recovery 
> -				 * session, so set the status to zero to 
> +				/* this has no effect on this recovery
> +				 * session, so set the status to zero to
>  				 * finish out the last recovery */
>  				mlog(ML_ERROR, "node %u went down after this "
>  				     "node finished recovery.\n", nodenum);
> @@ -2768,7 +2768,7 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>  	mlog(0, "%s: node %u finalizing recovery stage%d of "
>  	     "node %u (%u:%u)\n", dlm->name, fr->node_idx, stage,
>  	     fr->dead_node, dlm->reco.dead_node, dlm->reco.new_master);
> - 
> +
>  	spin_lock(&dlm->spinlock);
>  
>  	if (dlm->reco.new_master != fr->node_idx) {
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index 00f53b2..49e29ec 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -190,8 +190,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  			actions &= ~(DLM_UNLOCK_REMOVE_LOCK|
>  				     DLM_UNLOCK_REGRANT_LOCK|
>  				     DLM_UNLOCK_CLEAR_CONVERT_TYPE);
> -		} else if (status == DLM_RECOVERING || 
> -			   status == DLM_MIGRATING || 
> +		} else if (status == DLM_RECOVERING ||
> +			   status == DLM_MIGRATING ||
>  			   status == DLM_FORWARD) {
>  			/* must clear the actions because this unlock
>  			 * is about to be retried.  cannot free or do
> @@ -661,14 +661,14 @@ retry:
>  	if (call_ast) {
>  		mlog(0, "calling unlockast(%p, %d)\n", data, status);
>  		if (is_master) {
> -			/* it is possible that there is one last bast 
> +			/* it is possible that there is one last bast
>  			 * pending.  make sure it is flushed, then
>  			 * call the unlockast.
>  			 * not an issue if this is a mastered remotely,
>  			 * since this lock has been removed from the
>  			 * lockres queues and cannot be found. */
>  			dlm_kick_thread(dlm, NULL);
> -			wait_event(dlm->ast_wq, 
> +			wait_event(dlm->ast_wq,
>  				   dlm_lock_basts_flushed(dlm, lock));
>  		}
>  		(*unlockast)(data, status);
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index c5e4a49..172f4c6 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3155,7 +3155,7 @@ out:
>  /* Mark the lockres as being dropped. It will no longer be
>   * queued if blocking, but we still may have to wait on it
>   * being dequeued from the downconvert thread before we can consider
> - * it safe to drop. 
> + * it safe to drop.
>   *
>   * You can *not* attempt to call cluster_lock on this lockres anymore. */
>  void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> index 15713cb..19ad145 100644
> --- a/fs/ocfs2/export.c
> +++ b/fs/ocfs2/export.c
> @@ -239,7 +239,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
>  		mlog(0, "Encoding parent: blkno: %llu, generation: %u\n",
>  		     (unsigned long long)blkno, generation);
>  	}
> -	
> +
>  	*max_len = len;
>  
>  bail:
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 06ccf6a..65e9375 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -749,7 +749,7 @@ static int ocfs2_write_zero_page(struct inode *inode,
>  	int ret;
>  
>  	offset = (size & (PAGE_CACHE_SIZE-1)); /* Within page */
> -	/* ugh.  in prepare/commit_write, if from==to==start of block, we 
> +	/* ugh.  in prepare/commit_write, if from==to==start of block, we
>  	** skip the prepare.  make sure we never send an offset for the start
>  	** of a block
>  	*/
> @@ -1779,7 +1779,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  	struct inode *inode = dentry->d_inode;
>  	loff_t saved_pos, end;
>  
> -	/* 
> +	/*
>  	 * We start with a read level meta lock and only jump to an ex
>  	 * if we need to make modifications here.
>  	 */
> @@ -2033,7 +2033,7 @@ out_dio:
>  						      pos + count - 1);
>  	}
>  
> -	/* 
> +	/*
>  	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
>  	 * function pointer which is called when o_direct io completes so that
>  	 * it can unlock our rw lock.  (it's the clustered equivalent of
> @@ -2198,7 +2198,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
>  		goto bail;
>  	}
>  
> -	/* 
> +	/*
>  	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
>  	 * need locks to protect pending reads from racing with truncate.
>  	 */
> @@ -2220,10 +2220,10 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
>  	 * We're fine letting folks race truncates and extending
>  	 * writes with read across the cluster, just like they can
>  	 * locally. Hence no rw_lock during read.
> -	 * 
> +	 *
>  	 * Take and drop the meta data lock to update inode fields
>  	 * like i_size. This allows the checks down below
> -	 * generic_file_aio_read() a chance of actually working. 
> +	 * generic_file_aio_read() a chance of actually working.
>  	 */
>  	ret = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
>  	if (ret < 0) {
> @@ -2248,7 +2248,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
>  bail:
>  	if (have_alloc_sem)
>  		up_read(&inode->i_alloc_sem);
> -	if (rw_level != -1) 
> +	if (rw_level != -1)
>  		ocfs2_rw_unlock(inode, rw_level);
>  	mlog_exit(ret);
>  
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 0297fb8..88459bd 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -475,7 +475,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  	if (args->fi_flags & OCFS2_FI_FLAG_ORPHAN_RECOVERY) {
>  		status = ocfs2_try_open_lock(inode, 0);
>  		if (status) {
> -			make_bad_inode(inode);	
> +			make_bad_inode(inode);
>  			return status;
>  		}
>  	}
> @@ -684,7 +684,7 @@ bail:
>  	return status;
>  }
>  
> -/* 
> +/*
>   * Serialize with orphan dir recovery. If the process doing
>   * recovery on this orphan dir does an iget() with the dir
>   * i_mutex held, we'll deadlock here. Instead we detect this
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index bf34c49..9336c60 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -2034,7 +2034,7 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
>  		status = -ENOENT;
>  		mlog_errno(status);
>  		return status;
> -	}	
> +	}
>  
>  	mutex_lock(&orphan_dir_inode->i_mutex);
>  	status = ocfs2_inode_lock(orphan_dir_inode, NULL, 0);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 2606991..755cd49 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1062,7 +1062,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  				     "file system, but write access is "
>  				     "unavailable.\n");
>  			else
> -				mlog_errno(status);			
> +				mlog_errno(status);
>  			goto read_super_error;
>  		}
>  
> diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
> index c613693..a0a120e 100644
> --- a/fs/ocfs2/uptodate.c
> +++ b/fs/ocfs2/uptodate.c
> @@ -267,8 +267,8 @@ static int ocfs2_buffer_cached(struct ocfs2_caching_info *ci,
>  }
>  
>  /* Warning: even if it returns true, this does *not* guarantee that
> - * the block is stored in our inode metadata cache. 
> - * 
> + * the block is stored in our inode metadata cache.
> + *
>   * This can be called under lock_buffer()
>   */
>  int ocfs2_buffer_uptodate(struct ocfs2_caching_info *ci,
> -- 
> 1.5.6.5
> 

-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
