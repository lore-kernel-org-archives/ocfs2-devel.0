Received: from out199-15.us.a.mail.aliyun.com (out199-15.us.a.mail.aliyun.com [47.90.199.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233CD64B
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Nov 2023 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VvIuXn3_1698801206;
Received: from 30.221.128.154(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0VvIuXn3_1698801206)
          by smtp.aliyun-inc.com;
          Wed, 01 Nov 2023 09:13:27 +0800
Message-ID: <204108bc-8d74-6bab-a8fd-5598aa3e5cdd@linux.alibaba.com>
Date: Wed, 1 Nov 2023 09:13:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] ocfs2: call ocfs2_abort when journal abort
Content-Language: en-US
To: Srivathsa Dara <srivathsa.d.dara@oracle.com>, mark@fasheh.com,
 jlbec@evilplan.org
Cc: rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20231030120057.928280-1-srivathsa.d.dara@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20231030120057.928280-1-srivathsa.d.dara@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/23 8:00 PM, Srivathsa Dara wrote:
> From: Ryan Ding <ryan.ding@oracle.com>
> 
> 
> journal can not recover from abort state, so we should take following 
> action to prevent file system from corruption:
> 
> 1. change to readonly filesystem when local mount. We can not afford 
>    further write, so change to RO state is reasonable.
> 
> 2. panic when cluster mount. Because we can not release lock resource in
>    this state, other node will hung when it require a lock owned by this
>    node. So panic and remaster is a reasonable choise.
> 
> ocfs2_abort() will do all the above work.
> 
> Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
> Signed-off-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
> ---
>  fs/ocfs2/journal.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index ce215565d061..6dace475f019 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -14,7 +14,6 @@
>  #include <linux/kthread.h>
>  #include <linux/time.h>
>  #include <linux/random.h>
> -#include <linux/delay.h>
>  #include <linux/writeback.h>
>  
>  #include <cluster/masklog.h>
> @@ -2326,7 +2325,7 @@ static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota)
>  
>  static int ocfs2_commit_thread(void *arg)
>  {
> -	int status;
> +	int status = 0;
>  	struct ocfs2_super *osb = arg;
>  	struct ocfs2_journal *journal = osb->journal;
>  
> @@ -2340,21 +2339,25 @@ static int ocfs2_commit_thread(void *arg)
>  		wait_event_interruptible(osb->checkpoint_event,
>  					 atomic_read(&journal->j_num_trans)
>  					 || kthread_should_stop());
> +		if (status < 0) {
> +			/* As we can not terminate by ourself, just enter an
> +			 * empty loop to wait for stop.
> +			 */
> +			continue;
> +		}
>  
>  		status = ocfs2_commit_cache(osb);
>  		if (status < 0) {
> -			static unsigned long abort_warn_time;
> -
> -			/* Warn about this once per minute */
> -			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
> -				mlog(ML_ERROR, "status = %d, journal is "
> -						"already aborted.\n", status);
>  			/*
> -			 * After ocfs2_commit_cache() fails, j_num_trans has a
> -			 * non-zero value.  Sleep here to avoid a busy-wait
> -			 * loop.
> +			 * journal can not recover from abort state, there is
> +			 * no need to keep commit cache. So we should either
> +			 * change to readonly(local mount) or just panic
> +			 * (cluster mount).
> +			 * We should also clear j_num_trans to prevent further
> +			 * commit.
>  			 */
> -			msleep_interruptible(1000);
> +			atomic_set(&journal->j_num_trans, 0);

Unconditionally clear 'j_num_trans' here seems buggy.
This may cause other nodes corrupt filesystem.

Thanks,
Joseph

> +			ocfs2_abort(osb->sb, "Detected aborted journal");
>  		}
>  
>  		if (kthread_should_stop() && atomic_read(&journal->j_num_trans)){
