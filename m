From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 09 Jun 2009 23:50:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: timer to queue scan of all
 orphan slots
In-Reply-To: <4A2F46B1.5090301@oracle.com>
References: <1244073776-18748-1-git-send-email-srinivas.eeda@oracle.com>
	<1244073776-18748-2-git-send-email-srinivas.eeda@oracle.com>
	<4A2F46B1.5090301@oracle.com>
Message-ID: <4A2F57AA.8090209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> Hi Srini/Joel/Sunil,
>     I also have some thoughts for it. Wish it isn't too late.
>
>     Currently, orphan scan just iterate all the slots and call 
> ocfs2_queue_recovery_completion, but I don't think it is proper for a 
> node to query another mounted one since that node will query it by 
> itself.    What's more, it will affect reflink greatly.
> In my current implementation of reflink, It will work like this:
> 1. create a inode in orphan dir
> 2. reflink all the extents.
> 3. move the inode from orphan dir to the destination.
>
> For efficiency, I just lock orphan dir in step 1 and 3, and release 
> the lock in step 2 in case reflink will take a long time and we don't 
> block other "unlink" process. And in step 1, the created inode looks 
> really like a deleted one so that any crash in step 2 won't prevent it 
> from being deleted by fsck or recovery.
>
> But with your patch, we may have a race in step 2 that your recovery 
> will delete the inode created in step 1. So my suggestion is that your 
> orphan scan just skip the mounted node so it won't affect other nodes' 
> ongoing reflink. As for the node itself, it is very easy to postpone 
> the orphan scan by setting a flag in ocfs2_super when reflink is 
> ongoing(I will do it).
>
> Make sense?
Yes, I can restrict the node to recover it's own and offline slots. I 
can make the node to recover it's own slot every time the timer fires 
and offline slots in round robin way(current way)
>
> Regards,
> Tao
>
> Srinivas Eeda wrote:
>> When a dentry is unlinked, the unlinking node takes an EX on the 
>> dentry lock
>> before moving the dentry to the orphan directory. The other nodes, 
>> that all had
>> a PR on the same dentry lock, flag the corresponding inode as 
>> MAYBE_ORPHANED
>> during the downconvert. The inode is finally deleted when the last 
>> node to iput
>> the inode notices the MAYBE_ORPHANED flag.
>>
>> A problem arises if a node is forced to free dentry locks because of 
>> memory
>> pressure. If this happens, the node will no longer get downconvert 
>> notifications
>> for the dentries that have been unlinked on another node. If it also 
>> happens
>> that node is actively using the corresponding inode and happens to be 
>> the one
>> performing the last iput on that inode, it will fail to delete the 
>> inode as it
>> will not have the MAYBE_ORPHANED flag set.
>>
>> This patch fixes this shortcoming by introducing a periodic scan of 
>> the orphan
>> directories to delete such inodes. Care has been taken to distribute the
>> workload across the cluster so that no one node has to perform the 
>> task all the
>> time.
>>
>> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
>> ---
>>  fs/ocfs2/dlmglue.c      |   51 ++++++++++++++++++++++
>>  fs/ocfs2/dlmglue.h      |   11 +++++
>>  fs/ocfs2/journal.c      |  106 
>> +++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/journal.h      |    4 ++
>>  fs/ocfs2/ocfs2.h        |   10 ++++
>>  fs/ocfs2/ocfs2_lockid.h |    5 ++
>>  fs/ocfs2/super.c        |    9 ++++
>>  7 files changed, 196 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index e15fc7d..0f35b83 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -248,6 +248,10 @@ static struct ocfs2_lock_res_ops 
>> ocfs2_nfs_sync_lops = {
>>      .flags        = 0,
>>  };
>>  
>> +static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
>> +    .flags        = LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
>> +};
>> +
>>  static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
>>      .get_osb    = ocfs2_get_dentry_osb,
>>      .post_unlock    = ocfs2_dentry_post_unlock,
>> @@ -637,6 +641,19 @@ static void ocfs2_nfs_sync_lock_res_init(struct 
>> ocfs2_lock_res *res,
>>                     &ocfs2_nfs_sync_lops, osb);
>>  }
>>  
>> +static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
>> +                        struct ocfs2_super *osb)
>> +{
>> +    struct ocfs2_orphan_scan_lvb *lvb;
>> +
>> +    ocfs2_lock_res_init_once(res);
>> +    ocfs2_build_lock_name(OCFS2_LOCK_TYPE_ORPHAN_SCAN, 0, 0, 
>> res->l_name);
>> +    ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_ORPHAN_SCAN,
>> +                   &ocfs2_orphan_scan_lops, osb);
>> +    lvb = ocfs2_dlm_lvb(&res->l_lksb);
>> +    lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
>> +}
>> +
>>  void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
>>                    struct ocfs2_file_private *fp)
>>  {
>> @@ -2352,6 +2369,37 @@ void ocfs2_inode_unlock(struct inode *inode,
>>      mlog_exit_void();
>>  }
>>  
>> +int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
>> +{
>> +    struct ocfs2_lock_res *lockres;
>> +    struct ocfs2_orphan_scan_lvb *lvb;
>> +    int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
>> +    int status = 0;
>> +
>> +    lockres = &osb->osb_orphan_scan.os_lockres;
>> +    status = ocfs2_cluster_lock(osb, lockres, level, 0, 0); +    if 
>> (status < 0)
>> +        return status;
>> +
>> +    lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +    if (lvb->lvb_version == OCFS2_ORPHAN_LVB_VERSION)
>> +        *seqno = be32_to_cpu(lvb->lvb_os_seqno); +    return status;
>> +}
>> +
>> +void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, 
>> int ex)
>> +{
>> +    struct ocfs2_lock_res *lockres;
>> +    struct ocfs2_orphan_scan_lvb *lvb;
>> +    int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
>> +
>> +    lockres = &osb->osb_orphan_scan.os_lockres;
>> +    lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +    lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
>> +    lvb->lvb_os_seqno = cpu_to_be32(seqno);
>> +    ocfs2_cluster_unlock(osb, lockres, level); +}
>> +
>>  int ocfs2_super_lock(struct ocfs2_super *osb,
>>               int ex)
>>  {
>> @@ -2842,6 +2890,7 @@ local:
>>      ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
>>      ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
>>      ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
>> +    
>> ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
>>  
>>      osb->cconn = conn;
>>  
>> @@ -2878,6 +2927,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>>      ocfs2_lock_res_free(&osb->osb_super_lockres);
>>      ocfs2_lock_res_free(&osb->osb_rename_lockres);
>>      ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
>> +    ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
>>  
>>      ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
>>      osb->cconn = NULL;
>> @@ -3061,6 +3111,7 @@ static void ocfs2_drop_osb_locks(struct 
>> ocfs2_super *osb)
>>      ocfs2_simple_drop_lockres(osb, &osb->osb_super_lockres);
>>      ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
>>      ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
>> +    ocfs2_simple_drop_lockres(osb, &osb->osb_orphan_scan.os_lockres);
>>  }
>>  
>>  int ocfs2_drop_inode_locks(struct inode *inode)
>> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
>> index e1fd572..31b90d7 100644
>> --- a/fs/ocfs2/dlmglue.h
>> +++ b/fs/ocfs2/dlmglue.h
>> @@ -62,6 +62,14 @@ struct ocfs2_qinfo_lvb {
>>      __be32    lvb_free_entry;
>>  };
>>  
>> +#define OCFS2_ORPHAN_LVB_VERSION 1
>> +
>> +struct ocfs2_orphan_scan_lvb {
>> +    __u8    lvb_version;
>> +    __u8    lvb_reserved[3];
>> +    __be32    lvb_os_seqno;
>> +};
>> +
>>  /* ocfs2_inode_lock_full() 'arg_flags' flags */
>>  /* don't wait on recovery. */
>>  #define OCFS2_META_LOCK_RECOVERY    (0x01)
>> @@ -113,6 +121,9 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
>>               int ex);
>>  void ocfs2_super_unlock(struct ocfs2_super *osb,
>>              int ex);
>> +int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int 
>> ex);
>> +void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, 
>> int ex);
>> +
>>  int ocfs2_rename_lock(struct ocfs2_super *osb);
>>  void ocfs2_rename_unlock(struct ocfs2_super *osb);
>>  int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index a20a0f1..dc7cea3 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -28,6 +28,8 @@
>>  #include <linux/slab.h>
>>  #include <linux/highmem.h>
>>  #include <linux/kthread.h>
>> +#include <linux/time.h>
>> +#include <linux/random.h>
>>  
>>  #define MLOG_MASK_PREFIX ML_JOURNAL
>>  #include <cluster/masklog.h>
>> @@ -52,6 +54,8 @@
>>  
>>  DEFINE_SPINLOCK(trans_inc_lock);
>>  
>> +#define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
>> +
>>  static int ocfs2_force_read_journal(struct inode *inode);
>>  static int ocfs2_recover_node(struct ocfs2_super *osb,
>>                    int node_num, int slot_num);
>> @@ -1841,6 +1845,108 @@ bail:
>>      return status;
>>  }
>>  
>> +/*
>> + * Scan timer should get fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT. 
>> Add some
>> + * randomness to the timeout to minimize multple nodes firing the 
>> timer at the
>> + * same time.
>> + */
>> +static inline unsigned long ocfs2_orphan_scan_timeout(void)
>> +{
>> +    unsigned long time;
>> +
>> +    get_random_bytes(&time, sizeof(time));
>> +    time = ORPHAN_SCAN_SCHEDULE_TIMEOUT + (time % 5000);
>> +    return msecs_to_jiffies(time);
>> +}
>> +
>> +/*
>> + * ocfs2_queue_orphan_scan calls ocfs2_queue_recovery_completion for
>> + * every slot which queues a recovery of slot on ocfs2_wq thread. 
>> This is done
>> + * to cleanup any orphans that are left over in orphan slots.
>> + *
>> + * ocfs2_queue_orphan_scan gets called every 
>> ORPHAN_SCAN_SCHEDULE_TIMEOUT seconds
>> + * It gets an EX lock on os_lockres and checks sequence number 
>> stored in LVB. If
>> + * the sequence number is changed it means some node has done the 
>> scan. Skip the
>> + * scan and tracks the sequence number. If the sequence number 
>> didn't change,
>> + * means a scan didn't happen, so the node queues a scan and 
>> increments the
>> + * sequence number in LVB.
>> + */ +void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
>> +{
>> +    struct ocfs2_orphan_scan *os;
>> +    int status, i;
>> +    u32 seqno = 0;
>> +
>> +    os = &osb->osb_orphan_scan;
>> +
>> +    status = ocfs2_orphan_scan_lock(osb, &seqno, DLM_LOCK_EX);
>> +    if (status < 0) {
>> +        if (status != -EAGAIN)
>> +            mlog_errno(status);
>> +        goto out;
>> +    }
>> +
>> +    if (os->os_seqno != seqno) {
>> +        os->os_seqno = seqno;
>> +        goto unlock;
>> +    }
>> +
>> +    for (i = 0; i < osb->max_slots; i++)
>> +        ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
>> +                        NULL);
>> +    /*
>> +     * We queued a recovery on orphan slots, increment the sequence
>> +     * number and update LVB so other node will skip the scan for a 
>> while
>> +     */
>> +    seqno++;
>> +unlock:
>> +    ocfs2_orphan_scan_unlock(osb, seqno, DLM_LOCK_EX);
>> +out:
>> +    return;
>> +}
>> +
>> +/* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT 
>> millsec */
>> +void ocfs2_orphan_scan_work(struct work_struct *work)
>> +{
>> +    struct ocfs2_orphan_scan *os;
>> +    struct ocfs2_super *osb;
>> +
>> +    os = container_of(work, struct ocfs2_orphan_scan,
>> +              os_orphan_scan_work.work);
>> +    osb = os->os_osb;
>> +
>> +    mutex_lock(&os->os_lock);
>> +    ocfs2_queue_orphan_scan(osb);
>> +    schedule_delayed_work(&os->os_orphan_scan_work,
>> +                  ocfs2_orphan_scan_timeout());
>> +    mutex_unlock(&os->os_lock);
>> +}
>> +
>> +void ocfs2_orphan_scan_stop(struct ocfs2_super *osb)
>> +{
>> +    struct ocfs2_orphan_scan *os;
>> +
>> +    os = &osb->osb_orphan_scan;
>> +    mutex_lock(&os->os_lock);
>> +    cancel_delayed_work(&os->os_orphan_scan_work);
>> +    mutex_unlock(&os->os_lock);
>> +}
>> +
>> +int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
>> +{
>> +    struct ocfs2_orphan_scan *os;
>> +
>> +    os = &osb->osb_orphan_scan;
>> +    os->os_osb = osb;
>> +    mutex_init(&os->os_lock);
>> +
>> +    INIT_DELAYED_WORK(&os->os_orphan_scan_work,
>> +              ocfs2_orphan_scan_work);
>> +    schedule_delayed_work(&os->os_orphan_scan_work,
>> +                  ocfs2_orphan_scan_timeout());
>> +    return 0;
>> +}
>> +
>>  struct ocfs2_orphan_filldir_priv {
>>      struct inode        *head;
>>      struct ocfs2_super    *osb;
>> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
>> index 619dd7f..3483202 100644
>> --- a/fs/ocfs2/journal.h
>> +++ b/fs/ocfs2/journal.h
>> @@ -144,6 +144,10 @@ static inline void ocfs2_inode_set_new(struct 
>> ocfs2_super *osb,
>>  }
>>  
>>  /* Exported only for the journal struct init code in super.c. Do not 
>> call. */
>> +int ocfs2_orphan_scan_init(struct ocfs2_super *osb);
>> +void ocfs2_orphan_scan_stop(struct ocfs2_super *osb);
>> +void ocfs2_orphan_scan_exit(struct ocfs2_super *osb);
>> +
>>  void ocfs2_complete_recovery(struct work_struct *work);
>>  void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
>>  
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 1386281..373fb1c 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -151,6 +151,14 @@ struct ocfs2_lock_res {
>>  #endif
>>  };
>>  
>> +struct ocfs2_orphan_scan {
>> +    struct mutex         os_lock;
>> +    struct ocfs2_super     *os_osb;
>> +    struct ocfs2_lock_res     os_lockres;     /* lock to synchronize 
>> scans */
>> +    struct delayed_work     os_orphan_scan_work;
>> +    u32              os_seqno;       /* incremented on every scan */
>> +};
>> +
>>  struct ocfs2_dlm_debug {
>>      struct kref d_refcnt;
>>      struct dentry *d_locking_state;
>> @@ -341,6 +349,8 @@ struct ocfs2_super
>>      unsigned int            *osb_orphan_wipes;
>>      wait_queue_head_t        osb_wipe_event;
>>  
>> +    struct ocfs2_orphan_scan     osb_orphan_scan; +
>>      /* used to protect metaecc calculation check of xattr. */
>>      spinlock_t osb_xattr_lock;
>>  
>> diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
>> index a53ce87..fcdba09 100644
>> --- a/fs/ocfs2/ocfs2_lockid.h
>> +++ b/fs/ocfs2/ocfs2_lockid.h
>> @@ -48,6 +48,7 @@ enum ocfs2_lock_type {
>>      OCFS2_LOCK_TYPE_FLOCK,
>>      OCFS2_LOCK_TYPE_QINFO,
>>      OCFS2_LOCK_TYPE_NFS_SYNC,
>> +    OCFS2_LOCK_TYPE_ORPHAN_SCAN,
>>      OCFS2_NUM_LOCK_TYPES
>>  };
>>  
>> @@ -85,6 +86,9 @@ static inline char ocfs2_lock_type_char(enum 
>> ocfs2_lock_type type)
>>          case OCFS2_LOCK_TYPE_NFS_SYNC:
>>              c = 'Y';
>>              break;
>> +        case OCFS2_LOCK_TYPE_ORPHAN_SCAN:
>> +            c = 'P';
>> +            break;
>>          default:
>>              c = '\0';
>>      }
>> @@ -104,6 +108,7 @@ static char *ocfs2_lock_type_strings[] = {
>>      [OCFS2_LOCK_TYPE_OPEN] = "Open",
>>      [OCFS2_LOCK_TYPE_FLOCK] = "Flock",
>>      [OCFS2_LOCK_TYPE_QINFO] = "Quota",
>> +    [OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
>>  };
>>  
>>  static inline const char *ocfs2_lock_type_string(enum 
>> ocfs2_lock_type type)
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 79ff8d9..44ac27e 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1802,6 +1802,8 @@ static void ocfs2_dismount_volume(struct 
>> super_block *sb, int mnt_err)
>>  
>>      ocfs2_truncate_log_shutdown(osb);
>>  
>> +    ocfs2_orphan_scan_stop(osb);
>> +
>>      /* This will disable recovery and flush any recovery work. */
>>      ocfs2_recovery_exit(osb);
>>  
>> @@ -1957,6 +1959,13 @@ static int ocfs2_initialize_super(struct 
>> super_block *sb,
>>          goto bail;
>>      }
>>  
>> +    status = ocfs2_orphan_scan_init(osb);
>> +    if (status) {
>> +        mlog(ML_ERROR, "Unable to initialize delayed orphan scan\n");
>> +        mlog_errno(status);
>> +        goto bail;
>> +    }
>> +
>>      init_waitqueue_head(&osb->checkpoint_event);
>>      atomic_set(&osb->needs_checkpoint, 0);
>>  
