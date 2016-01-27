From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Jan 2016 09:33:37 +0800
Subject: [Ocfs2-devel] ocfs2/dlm: fix a race between refmap setting and
	clearing
In-Reply-To: <56A73ED8.6000908@huawei.com>
References: <56A73ED8.6000908@huawei.com>
Message-ID: <56A81E71.3010307@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jiufei,
Thanks very much for your effort.

Thanks,
Joseph

On 2016/1/26 17:39, xuejiufei wrote:
> Hi,
> This serial of patches is to fix the dis-order issue of
> setting/clearing refmap bit described below.
> 
> Node 1                               Node 2(master)
> dlmlock
> dlm_do_master_request
>                                 dlm_master_request_handler
>                                 -> dlm_lockres_set_refmap_bit
> dlmlock succeed
> dlmunlock succeed
> 
> dlm_purge_lockres
>                                 dlm_deref_handler
>                                 -> find lock resource is in
>                                    DLM_LOCK_RES_SETREF_INPROG state,
>                                    so dispatch a deref work
> dlm_purge_lockres succeed.
> 
> call dlmlock again
> dlm_do_master_request
>                                 dlm_master_request_handler
>                                 -> dlm_lockres_set_refmap_bit
> 
>                                 deref work trigger, call
>                                 dlm_lockres_clear_refmap_bit
>                                 to clear Node 1 from refmap
> 
>                                 dlm_purge_lockres succeed
> 
> dlm_send_remote_lock_request
>                                 return DLM_IVLOCKID because
>                                 the lockres is not exist
> BUG if the lockres is $RECOVERY
> 
> This serial of patches add a new message to keep the order of set and
> clear. Other nodes can purge the lock resource only after the refmap
> bit on master is cleared.
> 
> Jiufei Xue (4):
>     ocfs2/dlm: add DEREF_DONE message
>     ocfs2/dlm: return in progress if master can not clear the refmap
>                bit right now
>     ocfs2/dlm: clear DROPPING_REF flag when the master down
>     ocfs2/dlm: return EINVAL when the lockres on migration target is
>                in DROPPING_REF state
> 
>  dlmcommon.h   |   17 +++++++
>  dlmdomain.c   |   11 ++++-
>  dlmmaster.c   |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  dlmrecovery.c |   32 ++++++++++----
>  dlmthread.c   |    7 +++
>  5 files changed, 178 insertions(+), 13 deletions(-)
> 
> Thanks,
> Jiufei Xue
> 
> 
> .
> 
