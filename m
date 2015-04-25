From: Greg KH <gregkh@linuxfoundation.org>
Date: Sat, 25 Apr 2015 10:09:05 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix race between purge and get
	lock resource
In-Reply-To: <553B3CAB.9020102@huawei.com>
References: <553B3CAB.9020102@huawei.com>
Message-ID: <20150425080905.GB21686@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Apr 25, 2015 at 03:05:15PM +0800, Joseph Qi wrote:
> There is a race between purge and get lock resource, which will lead to
> ast unfinished and system hung. The case is described below:
> 
> mkdir                                  dlm_thread
> -----------------------------------------------------------------------
> o2cb_dlm_lock                        |
> -> dlmlock                           |
>   -> dlm_get_lock_resource           |
>     -> __dlm_lookup_lockres_full     |
>       -> spin_unlock(&dlm->spinlock) |
>                                      | dlm_run_purge_list
>                                      | -> dlm_purge_lockres
>                                      |   -> dlm_drop_lockres_ref
>                                      |   -> spin_lock(&dlm->spinlock)
>                                      |   -> spin_lock(&res->spinlock)
>                                      |   -> ~DLM_LOCK_RES_DROPPING_REF
>                                      |   -> spin_unlock(&res->spinlock)
>                                      |   -> spin_unlock(&dlm->spinlock)
>       -> spin_lock(&tmpres->spinlock)|
>       DLM_LOCK_RES_DROPPING_REF cleared |
>       -> spin_unlock(&tmpres->spinlock) |
>       return the purged lockres         |
> 
> So after this, once ast comes, it will ingore the ast because the
> lockres cannot be found anymore. Thus the OCFS2_LOCK_BUSY won't be
> cleared and corresponding thread hangs.
> The &dlm->spinlock was hold when checking DLM_LOCK_RES_DROPPING_REF at
> the very begining. And commit 7b791d6856 (ocfs2/dlm: Fix race during
> lockres mastery) moved it up because of the possible wait.
> So take the &dlm->spinlock and introduce a new wait function to fix the
> race.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: joyce.xue <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h |  2 ++
>  fs/ocfs2/dlm/dlmmaster.c | 13 +++++++++----
>  fs/ocfs2/dlm/dlmthread.c | 23 +++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 4 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
