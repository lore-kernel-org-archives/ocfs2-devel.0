From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 4 Feb 2020 19:37:41 +0800
Subject: [Ocfs2-devel] [PATCH] OCFS2: remove unused macros
In-Reply-To: <580ee0d1-edce-3161-dbd9-91c763412681@linux.alibaba.com>
References: <1579577827-251796-1-git-send-email-alex.shi@linux.alibaba.com>
	<a12fc48c-3165-3519-c2b2-399b06c8b5c6@linux.alibaba.com>
	<580ee0d1-edce-3161-dbd9-91c763412681@linux.alibaba.com>
Message-ID: <65a62f56-9ed9-df30-3025-73d9f63eefb6@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 20/2/4 19:08, Alex Shi wrote:
> 
> 
> ? 2020/1/26 ??9:43, Joseph Qi ??:
>>
>>
>> On 20/1/21 11:37, Alex Shi wrote:
>>> O2HB_DEFAULT_BLOCK_BITS/DLM_THREAD_MAX_ASTS/DLM_MIGRATION_RETRY_MS and
>>> OCFS2_MAX_RESV_WINDOW_BITS/OCFS2_MIN_RESV_WINDOW_BITS are
>>> never used from they were introduced to kernel. so better to remove
>>> them.
>>>
>>>  
>>> -#define DLM_MIGRATION_RETRY_MS  100
>>> -
>> It is no longer used since commit 66effd3c6812 ("ocfs2/dlm: Do not
>> migrate resource to a node that is leaving the domain").
> 
> Thanks for point out. how about the following revised patch?
> 
> Since a trival patch don't need much reviewer, I removed some Ccs.
> 
> Thanks
> Alex
> 
> ---
> 
> From 3bf7bf5a82a6a2275db49ba029d48fdd5c09332c Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linux.alibaba.com>
> Date: Tue, 21 Jan 2020 11:14:29 +0800
> Subject: [PATCH v2] OCFS2: remove unused macros
> 
> DLM_MIGRATION_RETRY_MS is no longer used since commit 66effd3c6812
> ("ocfs2/dlm: Do not migrate resource to a node that is leaving the domain").
> 
> And the others are never used since they were introduced. Let's remove
> them.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: ocfs2-devel at oss.oracle.com
> Cc: linux-kernel at vger.kernel.org

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 2 --
>  fs/ocfs2/dlm/dlmmaster.c     | 2 --
>  fs/ocfs2/dlm/dlmthread.c     | 1 -
>  fs/ocfs2/reservations.c      | 3 ---
>  4 files changed, 8 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index a368350d4c27..78cb48d6a596 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -101,8 +101,6 @@ struct o2hb_debug_buf {
>  
>  static struct o2hb_callback *hbcall_from_type(enum o2hb_callback_type type);
>  
> -#define O2HB_DEFAULT_BLOCK_BITS       9
> -
>  enum o2hb_heartbeat_modes {
>  	O2HB_HEARTBEAT_LOCAL		= 0,
>  	O2HB_HEARTBEAT_GLOBAL,
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 74b768ca1cd8..123b6873d9fa 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2751,8 +2751,6 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	return ret;
>  }
>  
> -#define DLM_MIGRATION_RETRY_MS  100
> -
>  /*
>   * Should be called only after beginning the domain leave process.
>   * There should not be any remaining locks on nonlocal lock resources,
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 61c51c268460..2dd9727537fe 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -680,7 +680,6 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
>  
>  #define DLM_THREAD_TIMEOUT_MS (4 * 1000)
>  #define DLM_THREAD_MAX_DIRTY  100
> -#define DLM_THREAD_MAX_ASTS   10
>  
>  static int dlm_thread(void *data)
>  {
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index 0249e8ca1028..bf3842e34fb9 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -33,9 +33,6 @@
>  
>  static DEFINE_SPINLOCK(resv_lock);
>  
> -#define	OCFS2_MIN_RESV_WINDOW_BITS	8
> -#define	OCFS2_MAX_RESV_WINDOW_BITS	1024
> -
>  int ocfs2_dir_resv_allowed(struct ocfs2_super *osb)
>  {
>  	return (osb->osb_resv_level && osb->osb_dir_resv_level);
> 
