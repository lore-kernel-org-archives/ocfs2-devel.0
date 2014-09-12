From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 12 Sep 2014 14:05:52 +0800
Subject: [Ocfs2-devel] May be deadlock for wrong locking order,
 patch request reviewed, thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA42EC6B8CB@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA42EC6B8CB@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <54128D40.9010806@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Zhonghua
On 2014/9/11 19:28, Guozhonghua wrote:
> As we test the ocfs2 cluster, the cluster is sometime hangs up.
> 
>  
> 
> I got some information about the dead lock, which cause the cluster hangs up, the sys dir / lock is held and the node did not release it which cause the cluster hangs up.
> 
>     root at cvknode-21:~# ps -e -o pid,stat,comm,wchan=WIDE-WCHAN-COLUMN | grep D
> 
>       PID STAT COMMAND WIDE-WCHAN-COLUMN
> 
>      7489 D jbd2/sdh-621 jbd2_journal_commit_transaction
> 
>     16218 D ls iterate_dir
> 
>     16533 D mkdir dlm_wait_for_lock_mastery
> 
>     31195 D+ ls iterate_dir
> 
>  
> 
> So the code reviewed, and I found the order of the lock may wrong.
> 
> In the function dlm_master_request_handler, the resource lock is held and so after the lock of &dlm->master_lock is locked.
> 
> But in the function dlm_get_lock_resource, the &dlm->master_lock is locked first and so resource lock.

Resource lock is not required in dlm_get_lock_resouce() because it
is a new lock resource.
commit 8d400b81cc83 add this spinlock when cleanup code, I think we can
remove this spinlock.

Thanks
Xue Jiufei

> 
> They are different order in different function.
> 
> If there are two task, one holds the res->lock waiting for the dlm->master_lock, with the function dlm_master_request_handler.
> 
> Another task holds the &dlm->master_lock waiting for the res->lock with dlm_get_lock_resource.
> 
> So the deadlock may be up.
> 
>  
> 
> I changed some code, and the patch request reviews.
> 
>  
> 
>  
> 
>  
> 
> *** ocfs2-ko-3.16/dlm/dlmmaster.c      2014-09-11 12:45:45.821657634 +0800
> 
> --- ocfs2-ko-3.16_compared/dlm/dlmmaster.c      2014-09-11 18:54:34.970243238 +0800
> 
> *************** way_up_top:
> 
> *** 1506,1512 ****
> 
> --- 1506,1515 ----
> 
>               }
> 
>  
> 
>               // mlog(0, "lockres is in progress...\n");
> 
> +             spin_unlock(&res->spinlock);
> 
> +        
> 
>               spin_lock(&dlm->master_lock);
> 
> +             spin_lock(&res->spinlock);
> 
>               found = dlm_find_mle(dlm, &tmpmle, name, namelen);
> 
>               if (!found) {
> 
>                       mlog(ML_ERROR, "no mle found for this lock!\n");
> 
> *************** way_up_top:
> 
> *** 1551,1558 ****
> 
>                       set_bit(request->node_idx, tmpmle->maybe_map);
> 
>               spin_unlock(&tmpmle->spinlock);
> 
>  
> 
> -              spin_unlock(&dlm->master_lock);
> 
>               spin_unlock(&res->spinlock);
> 
> +             spin_unlock(&dlm->master_lock);
> 
>  
> 
>               /* keep the mle attached to heartbeat events */
> 
>               dlm_put_mle(tmpmle);
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
