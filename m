From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 26 Jan 2020 09:48:41 +0800
Subject: [Ocfs2-devel] [PATCH] OCFS2: remove dlm_lock_is_remote
In-Reply-To: <1579578203-254451-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1579578203-254451-1-git-send-email-alex.shi@linux.alibaba.com>
Message-ID: <c1096f77-6c5a-2f3d-e11f-a93173e3ff31@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Richard Fontana <rfontana@redhat.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 20/1/21 11:43, Alex Shi wrote:
> This macros is also not used from it was introduced. better to remove
> it.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com> 
> Cc: Joel Becker <jlbec@evilplan.org> 
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com> 
> Cc: Kate Stewart <kstewart@linuxfoundation.org> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
> Cc: Thomas Gleixner <tglx@linutronix.de> 
> Cc: Richard Fontana <rfontana@redhat.com> 
> Cc: ocfs2-devel at oss.oracle.com 
> Cc: linux-kernel at vger.kernel.org

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com> 
> ---
>  fs/ocfs2/dlm/dlmthread.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 2dd9727537fe..0da9ffc40a88 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -39,8 +39,6 @@
>  static int dlm_thread(void *data);
>  static void dlm_flush_asts(struct dlm_ctxt *dlm);
>  
> -#define dlm_lock_is_remote(dlm, lock)     ((lock)->ml.node != (dlm)->node_num)
> -
>  /* will exit holding res->spinlock, but may drop in function */
>  /* waits until flags are cleared on res->state */
>  void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags)
> 
