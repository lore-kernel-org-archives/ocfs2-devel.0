From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sat, 4 Apr 2020 07:45:49 +0800
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Add missing annotation for
	dlm_empty_lockres()
In-Reply-To: <20200403160505.2832-4-jbi.octave@gmail.com>
References: <0/5> <20200403160505.2832-1-jbi.octave@gmail.com>
	<20200403160505.2832-4-jbi.octave@gmail.com>
Message-ID: <5408edd7-87a9-ac56-5c52-c2a19c308311@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jules Irenge <jbi.octave@gmail.com>, linux-kernel@vger.kernel.org
Cc: boqun.feng@gmail.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Gang He <ghe@suse.com>, Richard Fontana <rfontana@redhat.com>, Allison Randal <allison@lohutok.net>, Thomas Gleixner <tglx@linutronix.de>, Aditya Pakki <pakki001@umn.edu>, ChenGang <cg.chen@huawei.com>, Masahiro Yamada <masahiroy@kernel.org>, "moderated list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@oss.oracle.com>



On 2020/4/4 00:05, Jules Irenge wrote:
> Sparse reports a warning at dlm_empty_lockres()
> 
> warning: context imbalance in dlm_purge_lockres() - unexpected unlock
> 
> The root cause is the missing annotation at dlm_purge_lockres()
> 
> Add the missing __must_hold(&dlm->spinlock)
> 
Seems this is duplicate with assert_spin_locked()?

Thanks,
Joseph

> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 900f7e466d11..8cbd46b3509a 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2762,6 +2762,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>   * Returns: 1 if dlm->spinlock was dropped/retaken, 0 if never dropped
>   */
>  int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
> +	__must_hold(&dlm->spinlock)
>  {
>  	int ret;
>  	int lock_dropped = 0;
> 
