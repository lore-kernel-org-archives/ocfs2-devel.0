From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 28 Jul 2016 15:23:59 -0700
Subject: [Ocfs2-devel] [patch 5/5] ocfs2/dlm: continue to purge recovery
 lockres when recovery master goes down
In-Reply-To: <579a73c0.oJg/IWMTrvYSga3x%akpm@linux-foundation.org>
References: <579a73c0.oJg/IWMTrvYSga3x%akpm@linux-foundation.org>
Message-ID: <20160728222359.GE5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2016 at 02:06:08PM -0700, Andrew Morton wrote:
> From: piaojun <piaojun@huawei.com>
> Subject: ocfs2/dlm: continue to purge recovery lockres when recovery master goes down
> 
> We found a dlm-blocked situation caused by continuous breakdown of
> recovery masters described below.  To solve this problem, we should purge
> recovery lock once detecting recovery master goes down.
> 
> N3                      N2                   N1(reco master)
>                         go down
>                                              pick up recovery lock and
>                                              begin recoverying for N2
> 
>                                              go down
> 
> pick up recovery
> lock failed, then
> purge it:
> dlm_purge_lockres
>   ->DROPPING_REF is set
> 
> send deref to N1 failed,
> recovery lock is not purged
> 
> find N1 go down, begin
> recoverying for N1, but
> blocked in dlm_do_recovery
> as DROPPING_REF is set:
> dlm_do_recovery
>   ->dlm_pick_recovery_master
>     ->dlmlock
>       ->dlm_get_lock_resource
>         ->__dlm_wait_on_lockres_flags(tmpres,
> 	  	DLM_LOCK_RES_DROPPING_REF);
> 
> Fixes: 8c0343968163 ("ocfs2/dlm: clear DROPPING_REF flag when the master goes down")
> Link: http://lkml.kernel.org/r/578453AF.8030404 at huawei.com
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
