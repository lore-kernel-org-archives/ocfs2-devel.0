Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17AF5C7618E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Apr 2023 07:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hLykN8d22GERvlNL7sC4Zc5DmwwliiRqOj/Zid58DDc=;
 b=A/M7UC2A94GK8x1Kc8zz7AKSGp+t479cejGjhdrMqYaj8UyPsgF89QTLFAINbqMEcQMxLPb32cmX
   XbZxPaA6Us9EuNVrYNSAQM34OEKIeO4McuVRS7KGzyqiFu/9Tp/9YUIKfDC9zXPM3SRJXLetXBu5
   G893Uzk7JN66CM2m7pzy+AakgRue/k8DPq2zc8SdPK+dHWUpbDxo8mO3z17BfzjdwTzWOoJqucUY
   SP6K8eHEPz9+dCs9YMrT/7TGvMOieVGOBrYaCMpn2+Ois/s9E0N5c+rAAhXSQwLbvLhi3INb8Lut
   +hQ+GXw+8dIvg+NLtOUkezUt95sR6Q+yvzVC7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hLykN8d22GERvlNL7sC4Zc5DmwwliiRqOj/Zid58DDc=;
 b=W98P1/28wQzlbWmqrI39MoObsh3gO4X9y1vQ+bAQIgJJIRFwtiRUm8o0nChlAa+MwHgDk9Pyb2hm
   7o+OXtwr+R1JjSLRjk8ZXwv0fP+sfHZTYXxUtHkoBpgtdYwXwKUAunCWulXxc/PfqMWP8QQTIesf
   W5zNB9wEvTAB+Cwi3Ccq6wp+rXpm+oj6dAOsnymmL+x86fnVv9644HXXbzWU8r/epYAud6m4awj7
   C4qgPBC1qRotiaAzxJAMjygyJ/rxuIp2rXKY2ZWko7iWCDLi58Km+acEgPgdlQcgSAQRO7BX8XWO
   6pMQ3jNCGQ6Dz7rM4nyJHjQk/prj68+t0yzYCg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTG00M30FR12I60@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Apr 2023 07:35:25 +0000 (GMT)
Message-id: <c5034daa-056a-7603-daaa-3db5138bd3b6@linux.alibaba.com>
Date: Fri, 21 Apr 2023 15:35:01 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20230406154052.9863-1-heming.zhao@suse.com>
In-reply-to: <20230406154052.9863-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10686
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=120 mlxlogscore=999 clxscore=76 malwarescore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210064 domainage_hfrom=8772
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R711e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0Vgbzxk8_1682062501;
X-ServerName: out30-124.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: j8ortiByM_bu55jsPfZEJxxHHBKejJ8R
X-Proofpoint-GUID: j8ortiByM_bu55jsPfZEJxxHHBKejJ8R
Reporting-Meta:
 AAGznP1MpJNUIJ2LRWFxC7hVh6M6HIAzMN+pijowSQvL1yye4CI73IgUsrzm0UXk
 AhLxMmTc8TWdzJy388vKlpDLtqj1mIHTCachAEp/Re78y74acU084H+MV/yEFH2p
 f7dO+44zIoaP2gbWJjUmmo8rIJeXkn1EjRB6xNgHVZpvMguSUDUP2Ft/gPC8SO+P
 BJTJ9xghoaqc0A0yykj+A4BBj4Ti8VdNrAdmif7v9G5P8pTqsVzvKpdKVxKJayHr
 L4kjkL3h6X7L8OFlT+y4BhFPuA5gXqFTjQaDjgbKHXvqLvvXuBIcDlhdYjfOsgn1
 0HCXZ6gG44zsCJa0uOyoZOFwMEi1huyLmQy57ELtrt7k8E/q14KCAbBq8iQ3XfGP
 wSbzeuYvJdhdOJCqW5NQtlS6RhbDurxS/i2T3U8o6WsBdhWOG6w70iUUGNxIBE1l
 FnJ0ChriGdbDxaAFhns1lxa+zfMAWc80187F0e3GmxnFzI3ZknxKBK9eM+zWvOSK
 i6RZ/0RtXgcnSAVA6jllqFpDuoMxyUhpm/x9JzF/BSU=

Hi,
Could you please share a reproducer?

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
