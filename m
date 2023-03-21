Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF879C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NY5epx1ql6KWi++F5Gm3qfp2xNe401whV94mqRUrKUs=;
 b=oRFucoeE8y8pRLpH6kS4b0eDbAtffHd9WsE5MQncLgEqVStJQ5UX0yNJv1bQE3qrPR5DiPpcImtI
   t3uxe7aUqXrRmAmgqqA8J5S6Q5FqfRfXe313xzzq8Jh4MceBSXyFAOnTnB15e5ChTvHt8X1BzsTn
   Vn/N6n0pCu46MW5JyPXqw3KoUTWZkkuL9zI0+21DSUZcO3rMZizkSdlrY1zADCD/5g7rjbRVIRnJ
   L+FizDKljPyAZ0Fu8Beweh+8kcJ+gWcp103DV9mZ7vu1O0s8U9sIriAhpTFlopelj8ZSMHYX6M2i
   8ysH/Z3UmvXzQH6s4mU3U524SzKEOEXPkWckbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NY5epx1ql6KWi++F5Gm3qfp2xNe401whV94mqRUrKUs=;
 b=JCFtjKVUhQ+mAV1B3o+XbLTB/KjUCaBMlOr+JtpyWsKi2hAEYqsTsNz6NBU863r1uAEunoUdcEfE
   Ds2Y5nV8vF8A6KLb6BcuEtDc+8k70ccIWA3eb8pIpS91+v1gUkw3ZZDoxepUsYFQlhmPdQPFeQsz
   WMDCb/qRdCCyRyCvg1C12aM32xSU3EsSShPnBcGsMZzjU1kaQTFB3b8RfvY5e46qWGdizDSGD91g
   lhmm8c260hvtpv09RX+VnOM4ksX0SMC+3tD+PqHAGdyUIzJqXwiQF/ZmzjoF5RxOK+GJgf8dUAHA
   OrfBfc6KdBVPQo5/G5tY0okOlCE5S16QbDxHxQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRU00OLMLVFCK80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 21 Mar 2023 02:06:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1679364397; h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=9RCARuzcC+kq2t0rbFk8spXGJsCL8Dzdll9EAJiUgDk=;
 b=BaZqCOEep4bJYQKMP1fnq48BdpDt7MufTif/KshPMkeTrbYvBlx3h4F7f9QKkP0cfd
 ogXc0vDhwt+0ispMn4J2vIf2uN6L/dSyH11usJ8yVOWzF/PvbgMScVCafOKnMKoWSSBo
 EvDPvuCjc2EFgD3nn4C9kXRgaxtv/S0VqM5E/fS0CoM+nIqKH9KDjeQ7kwbhQuwt0jmx
 Ip4Z8xSNGg71rmblxzTZTPfeL+7u95xBkU1BsptzrA1BOATB2Dr0yMbl9u9DnkIo2GDI
 AX+pmcg2UxRpCZoRzY9X+cvIvBTKg7hm0fvoQRCbkViU2EG9y1Xn26lx/LlMmCvCRkbN MUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679364397;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=9RCARuzcC+kq2t0rbFk8spXGJsCL8Dzdll9EAJiUgDk=;
 b=2ziOv/0gq4odNf5GqBeKpZ+1qFNhAlocAXH7fiq5ev/1OUX7OCzhPHfFSzlO8Mgfq2
 IUD4o4k10f7mlr/cSeVSCASvZ8gb8Tlo57+Wg5HlE53F5hkZa1/8dHn/SGxRcmYhTn50
 6uaOOdzid4HId/0cHaqdD0hgTd018u3F4LlaYtVnubXdg5nOAPsl7YNu4zPcbq563sjp
 KyuEysA1yOMFlibB+Cbh6KRrdytbhdUhgC6C5Sof3NAP24Wd7AShNCpG1WHgXj7RdAMZ
 hNFlNzcVUIlpq29kIh9xFyPdCW7FL+PFyR1j9R5B6BJVXe8s7BVhJwOkOALPbNTmRXFJ tIGw==
X-Gm-Message-State: AO0yUKVfg2gvLdL8CA+cX6ffEXwRDiOv6Gmmd0VqAtZq/7JKLSmXwiPu
 NagFnhkF4QSjzNOchicUp1g=
X-Received: by 2002:a05:6a20:66b0:b0:da:267a:d740 with SMTP id
 o48-20020a056a2066b000b000da267ad740mr647019pzh.14.1679364397250; Mon,
 20 Mar 2023 19:06:37 -0700 (PDT)
Message-id: <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com>
Date: Tue, 21 Mar 2023 10:06:30 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Content-language: en-US
To: gregkh@linuxfoundation.org, ocfs2-devel@oss.oracle.com,
 akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jack@suse.cz,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
 mark@fasheh.com, piaojun@huawei.com, stable@vger.kernel.org
References: <1679313445246112@kroah.com>
In-reply-to: <1679313445246112@kroah.com>
X-Source-IP: 209.85.216.49
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=355 lowpriorityscore=0 clxscore=4 adultscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 unknownsenderscore=20 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303150002 definitions=main-2303210017
 domainage_hfrom=10082
Subject: Re: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption after failed write" failed to apply to
 5.10-stable tree
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
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AK7set/E2fIgBBV0BWEhQriFnseD1pJJrKzDQuKEuUyWbfc9iYhf6TcwHuN1xHG2zSQ7pVoOy741iQ==
X-ServerName: mail-pj1-f49.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: Pt8IVZGTz10tzHAcs327XsUTDoJrJWBs
X-Proofpoint-ORIG-GUID: Pt8IVZGTz10tzHAcs327XsUTDoJrJWBs
Reporting-Meta:
 AAHvZ5zP+33sgb9G21wM54CHPuozHQlLVkmYx9Wt7dA5n2RZvSKP6mMo09yKfdlx
 cBrtuD7QTvsKZicNmBq6dyEvRiVUWplXzTEisoiZWiTU6nnZrzd4FJPU8tR4oHiz
 P2uH3BZSG+T9VgNiRui0IHzLpjpFoiPTqPadIBS5MPArEzTeMy0dOCh0yrIVPULk
 pk3ZzGclMazZDNbzacnbyNgxmvkMZmy7zMIS/vQdsOEUHQ05RbPRNcO9kog+IN55
 WIWk0dj5phwSpkA43/1BT0EBTG52S+Aa2TTjbiSRMNnlk3cAdybL76Z/JeXM1fCZ
 szAq8GzM8j0JAnxqqwYOEpV74p6BkqF//eW744SEuVqKv0oqYpb3doiogYCcDk7k
 p6df1nPVGFUdwqZioGZkJY/VXG7Mtv0S7c00QjMVZPEFlvUI/7yDC9+QFKQ79OJ+
 V9i8scsGkAG3WdXRIEADaPdiivgWTekU4BPv20Q5De+yOjvvP8Vyh+1/ov6w7SVN
 UDAUsNbE83JWpJdVaXU0rVtG8IKHKARgEWgmecz6c7A=

Hi Greg,
It can be cleanly applied for linux-5.10.y and linux-4.19.y in my desktop.
I'm not sure how it happens.

Thanks,
Joseph

On 3/20/23 7:57 PM, gregkh--- via Ocfs2-devel wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
> git checkout FETCH_HEAD
> git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679313445246112@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..
> 
> Possible dependencies:
> 
> 90410bcf873c ("ocfs2: fix data corruption after failed write")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 90410bcf873cf05f54a32183afff0161f44f9715 Mon Sep 17 00:00:00 2001
> From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
> Date: Thu, 2 Mar 2023 16:38:43 +0100
> Subject: [PATCH] ocfs2: fix data corruption after failed write
> 
> When buffered write fails to copy data into underlying page cache page,
> ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
> leave dirty page beyond EOF and if page writeback tries to write this page
> before write succeeds and expands i_size, page gets into inconsistent
> state where page dirty bit is clear but buffer dirty bits stay set
> resulting in page data never getting written and so data copied to the
> page is lost.  Fix the problem by invalidating page beyond EOF after
> failed write.
> 
> Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 1d65f6ef00ca..0394505fdce3 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  	}
>  
>  	if (unlikely(copied < len) && wc->w_target_page) {
> +		loff_t new_isize;
> +
>  		if (!PageUptodate(wc->w_target_page))
>  			copied = 0;
>  
> -		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
> -				       start+len);
> +		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
> +		if (new_isize > page_offset(wc->w_target_page))
> +			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
> +					       start+len);
> +		else {
> +			/*
> +			 * When page is fully beyond new isize (data copy
> +			 * failed), do not bother zeroing the page. Invalidate
> +			 * it instead so that writeback does not get confused
> +			 * put page & buffer dirty bits into inconsistent
> +			 * state.
> +			 */
> +			block_invalidate_folio(page_folio(wc->w_target_page),
> +						0, PAGE_SIZE);
> +		}
>  	}
>  	if (wc->w_target_page)
>  		flush_dcache_page(wc->w_target_page);
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
