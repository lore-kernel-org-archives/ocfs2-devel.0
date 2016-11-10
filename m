From: Eric Ren <zren@suse.com>
Date: Thu, 10 Nov 2016 13:47:50 +0800
Subject: [Ocfs2-devel] ocfs2: A race about mle is unlinked and freed for
 the dead node, BUG
In-Reply-To: <E3535A62B291B54FBD1D003696CCB53771FB9FCE@H3CMLB12-EX.srv.huawei-3com.com>
References: <mailman.3.1478635201.364.ocfs2-devel@oss.oracle.com>
	<E3535A62B291B54FBD1D003696CCB53771FB9FCE@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <62470697-904d-8d5a-241a-bbb44ce3e79b@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I am not familiar with ocfs2/dlm code, but I am trying to...

On 11/09/2016 06:17 PM, Zhangguanghui wrote:
> Hi All,
>
> when the mle have been used in dlm_get_lock_resouce, other nodes dead at the same time,
> the mle that is block type may be unlinked and freed repeatedly for dead nodes.
> so it is a BUG  about mle->mle_refs.refcount in __dlm_put_mle  in dlm_get_lock_resouce.
May I suggest you give a big picture and background of what is going on before deep into 
code details, for someone like me
who don't know much about the code? As a stupid reader, what I would like see here are:

1) What is going on before this trouble?
2) Why does it ran into this trouble?  what do you expect and don't expect? maybe a 
simplified sequence diagram can make
it much more descriptive because we need to know: is this problem that happens on single or 
multiple node(s)? how do they interact
with each other if multiple nodes? For example:
----
commit 86b652b93adb57d8fed8edd532ed2eb8a791950d
Author: piaojun <piaojun@huawei.com>
Date:   Tue Aug 2 14:02:13 2016 -0700

     ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF is cleared before 
dlm_deref_lockres_done_handler

     We found a BUG situation in which DLM_LOCK_RES_DROPPING_REF is cleared
     unexpected that described below.  To solve the bug, we disable the
     BUG_ON and purge lockres in dlm_do_local_recovery_cleanup.

     Node 1                               Node 2(master)
     dlm_purge_lockres
                                          dlm_deref_lockres_handler

                                          DLM_LOCK_RES_SETREF_INPROG is set
                                          response DLM_DEREF_RESPONSE_INPROG

     receive DLM_DEREF_RESPONSE_INPROG
     stop puring in dlm_purge_lockres
     and wait for DLM_DEREF_RESPONSE_DONE

                                          dispatch dlm_deref_lockres_worker
                                          response DLM_DEREF_RESPONSE_DONE

     receive DLM_DEREF_RESPONSE_DONE and
     prepare to purge lockres

                                          Node 2 goes down

     find Node2 down and do local
     clean up for Node2:
     dlm_do_local_recovery_cleanup
       -> clear DLM_LOCK_RES_DROPPING_REF

     when purging lockres, BUG_ON happens
     because DLM_LOCK_RES_DROPPING_REF is clear:
     dlm_deref_lockres_done_handler
       ->BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));
---

3) Paste the back trace if it hits a BUG_ON(xxx);
4) Then you can deep into more details with code if necessary;
5) Explain how you fix this problem, and any side effects you can think of?

OK, back to you description, could you please explain to me:
1)  "the mle that is block type" - what's "block type"?
2) "may be " - when does it happen definitely? when doesn't?

> Finally, any feedback about this process (positive or negative) would be  greatly appreciated.
>
> *** linux-4.1.35/fs/ocfs2/dlm/dlmmaster.c 2016-11-09 17:39:02.230163503 +0800
> --- dlmmaster.c.update 2016-11-09 17:41:39.210166752 +0800
> ***************
> *** 3229,3248 ****
> --- 3229,3261 ----
> struct dlm_master_list_entry *mle, u8 dead_node)
> {
> int bit;
> + int next_bit = O2NM_MAX_NODES;
> BUG_ON(mle->type != DLM_MLE_BLOCK);
Please use git to make your patch even if it's a draft patch, and add this:
```
[diff "default"]
    xfuncname = "^[[:alpha:]$_].*[^:]$"
```
to your ~/.gitconfig to show in which function the changes are made.

Eric
>
> spin_lock(&mle->spinlock);
> bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, 0);
> + if (bit != O2NM_MAX_NODES)
> + next_bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, bit+1);
> +
> if (bit != dead_node) {
> mlog(0, "mle found, but dead node %u would not have been "
> "master\n", dead_node);
> spin_unlock(&mle->spinlock);
> + } else if (mle->inuse && next_bit != O2NM_MAX_NODES) {
> + /*Ignore it, the mle is used, other nodes dead now.
> + *as it is unlinked and freed for the dead node, it's a BUG*/
> + mlog(ML_ERROR, "the mle is used, but inuse %d, dead node %u, "
> + "master %u\n", mle->inuse, dead_node, mle->master);
> + clear_bit(bit, mle->maybe_map);
> + spin_unlock(&mle->spinlock);
> +
> } else {
> /* Must drop the refcount by one since the assert_master will
> * never arrive. This may result in the mle being unlinked and
> * freed, but there may still be a process waiting in the
> * dlmlock path which is fine. */
> mlog(0, "node %u was expected master\n", dead_node);
> + clear_bit(bit, mle->maybe_map);
> atomic_set(&mle->woken, 1);
> spin_unlock(&mle->spinlock);
> wake_up(&mle->wq);
>
> ________________________________
> All the best wishes for you.
> zhangguanghui
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
