Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1F5C77B75
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Apr 2023 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jHsJWIk9P39/Wo0Wuh3AMIC/8giDymx2GUSavU5gPww=;
 b=zdf4MZx47R6VtqGyRtV8dX+SZrW0KsjAoOKBPiwZi/wl+CtQxa4mqieNL5RDmCvc2emsPJtatZKg
   L4jxJI2RZBD2HpwpCJANE2LlPrsFb1W1u3jE6bMkgs8+x8k0j2DaYdZDjLJEERpN5mJpZF7ge0B+
   RR6pDWRuI3qDwVIcUPMgEdh58WNgfW/rKZ46mMy/pkoFo1Pa5T24ucflqL2izak3Zn5DKUuQBDcH
   pOpG/dxR55doOumcmbsYw9sFA10CPQN7clyW90N5azGHqBQb83jblz6DbnMH16TxZ1y8vPFJOPPM
   TPHk4aY2YnItw+/M9Ohcl9Cd9o4JvjYgpxoXtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jHsJWIk9P39/Wo0Wuh3AMIC/8giDymx2GUSavU5gPww=;
 b=K0DJe8zcVor+m7HITsn/e7jDXY1rgiY6ryQ3K7CDRsiWlTbxKovGkDsE0oOsDSfMMLgnQyKMC5Za
   uHgWSN5FV3R24+MDo5khaC4WJGF696i0YpPG5ziUEdPmAKjHJy6Ro98RHa2CyDd8M6J7wJ+IoJrV
   aJuTTws/csh8UAzfVw8mdUz8RQTbtpwTThv7p+4D7xunL2SM/rUMccqQygH7bSILfss5HIF6GFjJ
   J0YfJ89vwajswwSChLQ+MxcxE7RetikysuHVydngu8KhmQc23vAly8Q5EOcwES7PrFgGlp5FQR4N
   Oz9WMyTJefBrLf9OI1I07hDl2rIsA4zWoNLcsg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTB00KRE1OI1070@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Apr 2023 09:43:30 +0000 (GMT)
Message-id: <5c4d05e2-988b-93a5-aadd-28eaf49ade5e@linux.alibaba.com>
Date: Tue, 18 Apr 2023 17:43:06 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20230406154052.9863-1-heming.zhao@suse.com>
In-reply-to: <20230406154052.9863-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.111
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10683
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=60
 lowpriorityscore=0 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=188
 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180083 domainage_hfrom=8769
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix wrong search logic in
	__ocfs2_resv_find_window
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R821e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VgPT0n3_1681810986;
X-ServerName: out30-111.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: d0Px-8J3RCKYMGVXAUi8Vr9r_3SciZbP
X-Proofpoint-ORIG-GUID: d0Px-8J3RCKYMGVXAUi8Vr9r_3SciZbP
Reporting-Meta:
 AAGrCvn1+1LWlztgdN3YqXrHS7Pv51gKNwWkUyLAqFv7lUUT6k7XZO5AzDbnAviI
 JMGfAr6ew21FF9uWd3XGQgG5+ySTTr6x254sHyCnjkMTeDSk1hUHJzm55Yy6BdRm
 gysT8Jnz+mR7M0Ob/A6+wAA4rqltF81P+wFMDZgl9Vz0jDRgHahHN9xMDsL+qPOC
 hKMIRs/QuOQQ9BhySzTQI74KpPgMEzUYqwqfwYv2uiBG8aMbhDbAQk5jlj9ht25Q
 pujhESFtdG/z88ybtibM2jaggpz2LAU2t4czGiLTXWhgLVy8Btepm0ghDbL+KLnW
 v6ArOVWgHBSmguh6aBFcozsXZiL+5vEOSL4x+Vh6mgIt2vQCzj3edWlBzbk1oREg
 fNNxgyqgE1V1kZ7pBodUXu+sGhMDZx0DMqu7QzHXPkJifJeeRiA9TeNdcyoWICnS
 ijTapDcDWi3bEdLlmIhGXtcD3ZwuxNfqAg9zD+EHTsG+K/NoXM1tz2FWoLJglLgZ
 eEpmypFe9Rb1WK3unDKBImil4PCsTBZl/8fo3lYbPe6atg==

Sorry for the late replay since I was busy with other projects these
days. Will take a look at this patch this weekend.

Thanks,
Joseph

On 4/6/23 11:40 PM, Heming Zhao wrote:
> ** problem **
> 
> Current code triggers a defragfs bug [1]:
> 
> ```
> tw-tst:~ # defragfs.ocfs2 /mnt/test_from_dd1
> defragfs.ocfs2 1.8.7
> [ERROR]Move extent failed:"/mnt/test_from_dd1" - No space left on device
> [ERROR]"/mnt/test_from_dd1":No space left on device
> ```
> 
> I added some debug messages in relevant functions. When above error
> messages appeared, the la-window still had enough continuous bitmap
> to use, the -ENOSPC is wrong.
> 
> ** analysis **
> 
> __ocfs2_resv_find_window should use resv node from rb-tree to do linear
> search. But current code logic uses un-managered area between two resvs.
> The searching logic deviates from this func job, which should only focus
> on reservation areas (when rb_root is non NULL). Another issue of
> __ocfs2_resv_find_window is more inclined to generate inner fragment.
> It doesn't search & consume existing reservations but be apt to create
> new reservation item.
> 
> This patch pulls this func (__ocfs2_resv_find_window) to do what it
> should do: search & consume resev. if this func fails to get suitable
> bitmap area, caller ocfs2_resv_find_window fallbacks to use oldest
> resv from LRU to do the final search.
> 
> [1]: https://bugzilla.suse.com/show_bug.cgi?id=1131931
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/reservations.c | 48 +++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index a9d1296d736d..eda672622d1d 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -458,10 +458,11 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>  {
>  	struct rb_root *root = &resmap->m_reservations;
>  	unsigned int gap_start, gap_end, gap_len;
> -	struct ocfs2_alloc_reservation *prev_resv, *next_resv;
> +	struct ocfs2_alloc_reservation *prev_resv, *next_resv, *best_resv;
>  	struct rb_node *prev, *next;
>  	unsigned int cstart, clen;
>  	unsigned int best_start = 0, best_len = 0;
> +	int create_new = 0;
>  
>  	/*
>  	 * Nasty cases to consider:
> @@ -540,8 +541,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>  		if (clen) {
>  			best_len = clen;
>  			best_start = cstart;
> +			create_new = 1;
>  			if (best_len == wanted)
> -				goto out_insert;
> +				goto out_create;
>  		}
>  
>  		prev_resv = next_resv;
> @@ -557,13 +559,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>  	while (1) {
>  		next = rb_next(prev);
>  		if (next) {
> -			next_resv = rb_entry(next,
> -					     struct ocfs2_alloc_reservation,
> -					     r_node);
> -
> -			gap_start = ocfs2_resv_end(prev_resv) + 1;
> -			gap_end = next_resv->r_start - 1;
> -			gap_len = gap_end - gap_start + 1;
> +			gap_start = prev_resv->r_start;
> +			gap_end = prev_resv->r_start + prev_resv->r_len - 1;
> +			gap_len = prev_resv->r_len;
>  		} else {
>  			/*
>  			 * We're at the rightmost edge of the
> @@ -575,8 +573,8 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>  			gap_end = resmap->m_bitmap_len - 1;
>  		}
>  
> -		trace_ocfs2_resv_find_window_next(next ? next_resv->r_start: -1,
> -					next ? ocfs2_resv_end(next_resv) : -1);
> +		trace_ocfs2_resv_find_window_next(next ? prev_resv->r_start : -1,
> +					next ? ocfs2_resv_end(prev_resv) : -1);
>  		/*
>  		 * No need to check this gap if we have already found
>  		 * a larger region of free bits.
> @@ -589,10 +587,16 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>  		if (clen == wanted) {
>  			best_len = clen;
>  			best_start = cstart;
> -			goto out_insert;
> +			best_resv = prev_resv;
> +			if (!next)
> +				goto out_create;
> +			else
> +				goto out_insert;
>  		} else if (clen > best_len) {
>  			best_len = clen;
>  			best_start = cstart;
> +			best_resv = prev_resv;
> +			create_new = 0;
>  		}
>  
>  next_resv:
> @@ -604,12 +608,28 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>  				     r_node);
>  	}
>  
> -out_insert:
> -	if (best_len) {
> +	if (!best_len)
> +		return;
> +
> +	if (create_new) {
> +out_create:
>  		resv->r_start = best_start;
>  		resv->r_len = best_len;
>  		ocfs2_resv_insert(resmap, resv);
> +		return;
>  	}
> +
> +out_insert:
> +	if (best_resv->r_len <= wanted) {
> +		resv->r_start = best_start;
> +		resv->r_len = best_len;
> +		__ocfs2_resv_discard(resmap, best_resv);
> +	} else {
> +		best_resv->r_len -= best_len;
> +		resv->r_start = ocfs2_resv_end(best_resv) + 1;
> +		resv->r_len = best_len;
> +	}
> +	ocfs2_resv_insert(resmap, resv);
>  }
>  
>  static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
