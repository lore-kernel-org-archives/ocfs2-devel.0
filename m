From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 28 Jul 2016 15:01:45 -0700
Subject: [Ocfs2-devel] [patch 3/5] ocfs2/dlm: disable BUG_ON when
 DLM_LOCK_RES_DROPPING_REF is cleared before dlm_deref_lockres_done_handler
In-Reply-To: <579a73ba.w6r/vSvvhIAjJAxY%akpm@linux-foundation.org>
References: <579a73ba.w6r/vSvvhIAjJAxY%akpm@linux-foundation.org>
Message-ID: <20160728220145.GC5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2016 at 02:06:02PM -0700, Andrew Morton wrote:
> From: piaojun <piaojun@huawei.com>
> Subject: ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF is cleared before dlm_deref_lockres_done_handler
> 
> We found a BUG situation in which DLM_LOCK_RES_DROPPING_REF is cleared
> unexpected that described below.  To solve the bug, we disable the BUG_ON
> and purge lockres in dlm_do_local_recovery_cleanup.
> 
> Node 1                               Node 2(master)
> dlm_purge_lockres
>                                      dlm_deref_lockres_handler
> 
>                                      DLM_LOCK_RES_SETREF_INPROG is set
>                                      response DLM_DEREF_RESPONSE_INPROG
> 
> receive DLM_DEREF_RESPONSE_INPROG
> stop puring in dlm_purge_lockres
> and wait for DLM_DEREF_RESPONSE_DONE
> 
>                                      dispatch dlm_deref_lockres_worker
>                                      response DLM_DEREF_RESPONSE_DONE
> 
> receive DLM_DEREF_RESPONSE_DONE and
> prepare to purge lockres
> 
>                                      Node 2 goes down
> 
> find Node2 down and do local
> clean up for Node2:
> dlm_do_local_recovery_cleanup
>   -> clear DLM_LOCK_RES_DROPPING_REF
> 
> when purging lockres, BUG_ON happens
> because DLM_LOCK_RES_DROPPING_REF is clear:
> dlm_deref_lockres_done_handler
>   ->BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));

Thanks Piaojun,

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
