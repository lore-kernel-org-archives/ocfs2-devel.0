From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 17 Dec 2014 10:31:36 -0800
Subject: [Ocfs2-devel] [patch 05/15] ocfs2/dlm: fix race between
	dispatched_work and	dlm_lockres_grab_inflight_worker
In-Reply-To: <548f65d7.mLvwv5K/G+Eyb58w%akpm@linux-foundation.org>
References: <548f65d7.mLvwv5K/G+Eyb58w%akpm@linux-foundation.org>
Message-ID: <20141217183136.GP7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:51:03PM -0800, Andrew Morton wrote:
> From: Joseph Qi <joseph.qi@huawei.com>
> Subject: ocfs2/dlm: fix race between dispatched_work and dlm_lockres_grab_inflight_worker
> 
> ac4fef4d23ed ("ocfs2/dlm: do not purge lockres that is queued for assert
> master") may have the following possible race case:
> 
> dlm_dispatch_assert_master       dlm_wq
> ========================================================================
> queue_work(dlm->quedlm_worker,
> 	&dlm->dispatched_work);
>                                  dispatch work,
> 				 dlm_lockres_drop_inflight_worker
> 				 *BUG_ON(res->inflight_assert_workers == 0)*
> dlm_lockres_grab_inflight_worker
> inflight_assert_workers++
> 
> So ensure inflight_assert_workers to be increased first.

Good catch, thank you Joseph.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
