From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 13:10:21 -0700
Subject: [Ocfs2-devel] [patch 18/28] ocfs2: avoid access invalid address
 when read o2dlm debug messages
In-Reply-To: <55de39b9.MBCx0fXNJOuDOCFO%akpm@linux-foundation.org>
References: <55de39b9.MBCx0fXNJOuDOCFO%akpm@linux-foundation.org>
Message-ID: <20150831201021.GX1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:09PM -0700, Andrew Morton wrote:
> From: Yiwen Jiang <jiangyiwen@huawei.com>
> Subject: ocfs2: avoid access invalid address when read o2dlm debug messages
> 
> The following case will lead to a lockres is freed but is still in use.
> 
> cat /sys/kernel/debug/o2dlm/locking_state	dlm_thread
> lockres_seq_start
>     -> lock dlm->track_lock
>     -> get resA
>                                                 resA->refs decrease to 0,
>                                                 call dlm_lockres_release,
>                                                 and wait for "cat" unlock.
> Although resA->refs is already set to 0,
> increase resA->refs, and then unlock
>                                                 lock dlm->track_lock
>                                                     -> list_del_init()
>                                                     -> unlock
>                                                     -> free resA
> 
> In such a race case, invalid address access may occurs.  So we should
> delete list res->tracking before resA->refs decrease to 0.
> 
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I _think_ this is now correct.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
