Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B6AC43334
	for <ocfs2-devel@archiver.kernel.org>; Sun, 12 Jun 2022 02:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+s0Dn5yCJ5FCbQayRpWgYAo+Glnhn0oU3ilFmgTDpbQ=;
 b=o2tl11AA/HMRgzpxCGxxImOLICiLkX1qgxCCPR5tLRMmECU5capYSaUBZrS/5qiNhtSc1u8yt73+
   gwxnTxR+RbV8H5xcJr2G9y9/Wo4hmHL3QqMMLKUCt6AaAElEhQXHmzmlKh0fSSo0OzSloaYKeyJb
   qbp2pIMtGPWnA2efuab3vypdLED39UpOCkPMa7flMvUwGrTozD3YntpX2jj1I2EZcEgmz07TjX/+
   qhGu8+DBLbuuDypqvKYsZEGUtiHW4mjqJU7OzjOSTEo8HrkZVhCtExAJ0trkno557TKSjOa6Tzzv
   kFFTiz+i31HU0TGOcnqvHRScCZLuUObmfOo9Eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+s0Dn5yCJ5FCbQayRpWgYAo+Glnhn0oU3ilFmgTDpbQ=;
 b=PpnjJKS7lzmjDY6L0ZINtkrNIZqXvTVaOTIDlYBHk92S6hCCtgMq70JQe47EQuExaJQ31HEvauKk
   zFlmR4WcHRjZbrlj79+I/8zMhhQMYem4zs3Q4/z/LIbWauTXmuyPJ0vzJKCHs3x9zqBVdlAYHgJ1
   FkoIOhsJTDtXPEeCnxWaqyFiBfanzj1pGSNiFy3SC+x6YccC3+/ak/xkVT1UZ7/9XqSWQqPGAHJH
   4bS+C7WTV/y8/28VpM3D1w4U5zQa9WF8uVSefMB9YHOg3qqfEwpIzjPZN4hPKQfm11HrwWsac6Rw
   1aHneQ5a1vuk6Vjg+DOH//+duFgt8Tp96K1esA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDC00MOGG7ZG340@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 12 Jun 2022 02:57:35 +0000 (GMT)
Message-id: <b7970a54-2c81-780d-966f-05995acdd813@linux.alibaba.com>
Date: Sun, 12 Jun 2022 10:57:18 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220521101416.29793-1-heming.zhao@suse.com>
 <20220521101416.29793-2-heming.zhao@suse.com>
In-reply-to: <20220521101416.29793-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10375
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 spamscore=0 adultscore=0 clxscore=182 bulkscore=0 mlxlogscore=999
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206120011 domainage_hfrom=8459
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix for local alloc window
 restore unconditionally
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VG5-ukE_1655002638;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: W2DaYnGJgiCZH7di99u7lXoYhlYCeb8x
X-Proofpoint-ORIG-GUID: W2DaYnGJgiCZH7di99u7lXoYhlYCeb8x
Reporting-Meta:
 AAEMc6KhhgzaUItfuCOPaudh648vVNhZr/A6TcAwiPFYw795anejep70o+WrDIGE
 ZiFXlDTs/5HhhW8fuJ8xt9b1RlKXVcL2ikMLUN6uo7YowRA86LbGOCcv26UCAA3O
 ouM7M3+U9sSLH/egB9MlVgzvnTdTRzA6z1/DW2RGAoqkjtJl8UoF29oUI1qeLkh1
 wGh8xl3FzUqik+oX4ulfzMqQ5bnXiMZ0uFhTykXEWAKDuHbJX+lpYsuBoRnLUp30
 PHCVs6K67piPMGab2karsVVxo4Aj2e2FjgBSffXoGjJX+o8gY5v9QUXG8b5Hu3o1
 mb9KlmpV03yNBpYPcUbWiW7+CIP+fJP0hYH+4iAKxG0j4FGLiPxQc91DJ8FDUZ/2
 XTxBMXnPPpcpT9eHU+CeLVSa7uUYAm0L2BUf8aQlNgVNtwjw5piA/fq47X20gJWJ
 ZnUKY/EaoKuPUB+MTy55pywSQlqWJLQgR4ij3faRYyO5HE4yM5MvNXHmxvwUg4/l
 HygL3HcsX9TJsJcqnJRudIusXhg/eSc0yAYLHDPcGuuo



On 5/21/22 6:14 PM, Heming Zhao wrote:
> When la state is ENABLE, ocfs2_recalc_la_window restores la window
> unconditionally. The logic is wrong.
> 
> Let's image below path.
> 
> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
> 
> 2. About 30s (OCFS2_LA_ENABLE_INTERVAL), delayed work is triggered,
>    ocfs2_la_enable_worker set la state to ENABLED directly.
> 
> 3. a write IOs thread run:
> 
>    ```
>    ocfs2_write_begin
>     ...
>      ocfs2_lock_allocators
>       ocfs2_reserve_clusters
>        ocfs2_reserve_clusters_with_limit
>         ocfs2_reserve_local_alloc_bits
>          ocfs2_local_alloc_slide_window // [1]
>           + ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_SLIDE) // [2]
>           + ...
>           + ocfs2_local_alloc_new_window
>              ocfs2_claim_clusters // [3]
>    ```
> 
> [1]: will be called when la window bits used up.
> [2]: under la state is ENABLED (eg OCFS2_LA_ENABLE_INTERVAL delayed work
>      happened), it unconditionally restores la window to default value.
> [3]: will use default la window size to search clusters. IMO the timing
>      is O(n^4). The timing O(n^4) will cost huge time to scan global
>      bitmap. It makes write IOs (eg user space 'dd') become dramatically
>      slow.
> 
> i.e.
> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
> la window default size: 106MB.
> The partition is fragmentation by creating & deleting huge mount of
> small file.
> 
> the timing should be (the number got from real world):
> - la window size change order (size: MB):
>   106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>   only 0.8MB succeed, 0.8MB also triggers la window to disable.
>   ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>   runs in worst case.
> - group chain number: 242
>   ocfs2_claim_suballoc_bits calls for-loop 242 times
> - each chain has 49 block group
>   ocfs2_search_chain calls while-loop 49 times
> - each bg has 32256 blocks
>   ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>   for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>   (32256/64) for timing calucation.
> 
> So the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
> 
> In the worst case, user space writes 100MB data will trigger 42M scanning
> times, and if the write can't finish within 30s (OCFS2_LA_ENABLE_INTERVAL),
> the write IO will suffer another 42M scanning times. It makes the ocfs2
> partition keep pool performance all the time.
> 
> The fix method:
> 
> 1.  la restores double la size once.
> 
> current code logic decrease la window with half size once, but directly
> restores default_bits one time. It bounces the la window between '<1M'
> and default_bits. This patch makes restoring process more smoothly.
> eg.
> la default window is 106MB, current la window is 13MB.
> when there is a free action to release one block group space, la should
> roll back la size to 26MB (by 13*2).
> if there are many free actions to release many block group space, la
> will smoothly roll back to default window (106MB).
> 
> 2. introduced a new state: OCFS2_LA_RESTORE.
> 
> Current code uses OCFS2_LA_ENABLED to mark a new big space available.
> the state overwrite OCFS2_LA_THROTTLED, it makes la window forget
> it's already in throttled status.
> '->local_alloc_state' should keep OCFS2_LA_THROTTLED until la window
> restore to default_bits.

Since now we have enough free space, why not restore to default la
window?

This is an issue happened in a corner case, which blames current restore
window is too large. I agree with your method that restoring double la
size once instead of default directly. So why not just change the logic
of ocfs2_recalc_la_window() to do this?

Thanks,
Joseph

> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/localalloc.c | 30 +++++++++++++++++++++---------
>  fs/ocfs2/ocfs2.h      | 18 +++++++++++-------
>  fs/ocfs2/suballoc.c   |  2 +-
>  3 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c4426d12a2ad..28acea717d7f 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -205,20 +205,21 @@ void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
>  
>  static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
>  {
> -	return (osb->local_alloc_state == 	 ||
> -		osb->local_alloc_state == OCFS2_LA_ENABLED);
> +	return osb->local_alloc_state & OCFS2_LA_ACTIVE;
>  }
>  
>  void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
>  				      unsigned int num_clusters)
>  {
>  	spin_lock(&osb->osb_lock);
> -	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
> -	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
> +	if (osb->local_alloc_state & (OCFS2_LA_DISABLED |
> +		OCFS2_LA_THROTTLED | OCFS2_LA_RESTORE)) {
>  		if (num_clusters >= osb->local_alloc_default_bits) {
>  			cancel_delayed_work(&osb->la_enable_wq);
> -			osb->local_alloc_state = OCFS2_LA_ENABLED;
> +			osb->local_alloc_state &= ~OCFS2_LA_DISABLED;
> +			osb->local_alloc_state |= OCFS2_LA_RESTORE;
>  		}
> +	}
>  	spin_unlock(&osb->osb_lock);
>  }
>  
> @@ -228,7 +229,10 @@ void ocfs2_la_enable_worker(struct work_struct *work)
>  		container_of(work, struct ocfs2_super,
>  			     la_enable_wq.work);
>  	spin_lock(&osb->osb_lock);
> -	osb->local_alloc_state = OCFS2_LA_ENABLED;
> +	if (osb->local_alloc_state & OCFS2_LA_DISABLED) {
> +		osb->local_alloc_state &= ~OCFS2_LA_DISABLED;
> +		osb->local_alloc_state |= OCFS2_LA_ENABLED;
> +	}
>  	spin_unlock(&osb->osb_lock);
>  }
>  
> @@ -1067,7 +1071,7 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
>  			 * reason to assume the bitmap situation might
>  			 * have changed.
>  			 */
> -			osb->local_alloc_state = OCFS2_LA_THROTTLED;
> +			osb->local_alloc_state |= OCFS2_LA_THROTTLED;
>  			osb->local_alloc_bits = bits;
>  		} else {
>  			osb->local_alloc_state = OCFS2_LA_DISABLED;
> @@ -1083,8 +1087,16 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
>  	 * risk bouncing around the global bitmap during periods of
>  	 * low space.
>  	 */
> -	if (osb->local_alloc_state != OCFS2_LA_THROTTLED)
> -		osb->local_alloc_bits = osb->local_alloc_default_bits;
> +	if (osb->local_alloc_state & OCFS2_LA_RESTORE) {
> +		bits = osb->local_alloc_bits * 2;
> +		if (bits > osb->local_alloc_default_bits) {
> +			osb->local_alloc_bits = osb->local_alloc_default_bits;
> +			osb->local_alloc_state = OCFS2_LA_ENABLED;
> +		} else {
> +			/* keep RESTORE state & set new bits */
> +			osb->local_alloc_bits = bits;
> +		}
> +	}
>  
>  out_unlock:
>  	state = osb->local_alloc_state;
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 337527571461..1764077e3229 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -245,14 +245,18 @@ struct ocfs2_alloc_stats
>  
>  enum ocfs2_local_alloc_state
>  {
> -	OCFS2_LA_UNUSED = 0,	/* Local alloc will never be used for
> -				 * this mountpoint. */
> -	OCFS2_LA_ENABLED,	/* Local alloc is in use. */
> -	OCFS2_LA_THROTTLED,	/* Local alloc is in use, but number
> -				 * of bits has been reduced. */
> -	OCFS2_LA_DISABLED	/* Local alloc has temporarily been
> -				 * disabled. */
> +	/* Local alloc will never be used for this mountpoint. */
> +	OCFS2_LA_UNUSED = 1 << 0,
> +	/* Local alloc is in use. */
> +	OCFS2_LA_ENABLED = 1 << 1,
> +	/* Local alloc is in use, but number of bits has been reduced. */
> +	OCFS2_LA_THROTTLED = 1 << 2,
> +	/* In throttle state, Local alloc meets contig big space. */
> +	OCFS2_LA_RESTORE = 1 << 3,
> +	/* Local alloc has temporarily been disabled. */
> +	OCFS2_LA_DISABLED = 1 << 4,
>  };
> +#define OCFS2_LA_ACTIVE (OCFS2_LA_ENABLED | OCFS2_LA_THROTTLED | OCFS2_LA_RESTORE)
>  
>  enum ocfs2_mount_options
>  {
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 166c8918c825..b0df1ab2d6dd 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1530,7 +1530,7 @@ static int ocfs2_cluster_group_search(struct inode *inode,
>  		 * of bits. */
>  		if (min_bits <= res->sr_bits)
>  			search = 0; /* success */
> -		else if (res->sr_bits) {
> +		if (res->sr_bits) {
>  			/*
>  			 * Don't show bits which we'll be returning
>  			 * for allocation to the local alloc bitmap.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
