Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E8CC64EC4
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Mar 2023 10:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lCzqHSxuWpQxJHuaa1NrWyuzh3act31g7cYEeUwm514=;
 b=Dv2gZi2drcVZMVZx94ET0qb4AoApNKhM1e4kOB3pvJ20RA6+QFRtRp41hIJTVfnAezENemiWijto
   qO7HDJMuifn4LOPMQ60CXXiagn8Uj3sgBPxrVSD4oFMRDKc05Ss9XLwROsHNeUSzg/BFn4PXJo9l
   46WUauCdEUmT0IBy3xKTXSl7UnfRGdeuFWC9h3kozKkW6NmL/0GlwnEX30zljYdOMfPSArMgx1rg
   PVHtVF34DV9uihh5cJlxWNFZGzq6wa9+QGiaf0b8/Xtp7odWn2cg3FN8vaVFdedFzffRzD10yXsl
   0RHADJmJTRzWJQJFy0YbDu9GuPGlLUKgHFCHkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lCzqHSxuWpQxJHuaa1NrWyuzh3act31g7cYEeUwm514=;
 b=MsfOnGxm+c49QUDmy+V87CMhU9N98eqpRuo712iUn9mKn682J+Aw+Cr7K0ZWQDDvJrnJo7kMFG6p
   tkBxtFsWR1hwKwkVhMdHzaNUNkyj7rEVK7nkzuSL6kalWRJXx9LdLK8oM+9Y5uPov6j9AiUc5slJ
   wecWXQhzdfUdBc1FeYTj35GrTOkDV397+glonA8YicpPBhDFKef//IV/UiFd2qYt7e7VIW+j0B1Y
   U8EFxjPtyUYQmNbw6r1bGu0HX3KO2D0cm1QTvJKiYXj9TegOzeGvaLUooVekhrncUiC3pntznsmE
   ViVuPwiiG1mTHCZbHlQHUvRnQuHEVubcRZg9YQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQX00FYRYDHV940@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 03 Mar 2023 10:56:05 +0000 (GMT)
Message-id: <2df624fc-b463-5f28-7953-c368f9f9dd8e@linux.alibaba.com>
Date: Fri, 3 Mar 2023 18:55:48 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Jan Kara <jack@suse.cz>, akpm <akpm@linux-foundation.org>
References: <20230302153843.18499-1-jack@suse.cz>
In-reply-to: <20230302153843.18499-1-jack@suse.cz>
X-Source-IP: 115.124.30.97
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10637
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=162 bulkscore=0 mlxlogscore=971 spamscore=0 clxscore=40
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303030097
 domainage_hfrom=8723
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix data corruption after failed	write
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0Vd.51zs_1677840948;
X-ServerName: out30-97.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: uKFI4ISMZrFt1ZprFYg9i-ZVJ2lF0Ts5
X-Proofpoint-ORIG-GUID: uKFI4ISMZrFt1ZprFYg9i-ZVJ2lF0Ts5
Reporting-Meta:
 AAEJqUbJ62ZNkcw85JoHiy4DtClVNiwNbqqBTToyA2byOLkkNA5ccs26RtnL4uD/
 1p4IlqdZfAadydjIVYw/zWd3vfD5FpI2oA5YeGftXZygzYL4Q3UjXL0JFBm2bWDt
 30pMq99tn2MAJGsLM1TMraLCvuFoN8WE78DgfM6b1uA4bw04PyYLYFBSn7UXnGlB
 N5+h6nl+vBnbvDNO74FtDzP0n1vMDAz+dLgdpjPyT/DiPeuNcKTiaXft+3IS96SY
 SpPkqlk1PkIbU6JO7wX4/kOkgCHe8tIVbPq5baL9h7bpgqfXjhR5C/a3yKEstg4p
 ixdKOI2ODK0Ns/OEb6ho6KYIwGztxvjhyrRK8sTcxcgV/yc9ioypTVB5R8uZU/8q
 VMfDLu0Gm/nh4zpVW+GzQax/im4H8shcR0+NbUQnN4uHZrPtGcs8jA6HJSfYgDbj
 43/F46wEv5XxYQk32NDCdXan4fBHrzxG84ckirT8qT3errbJ73AsroEBFhanigW2
 ARWJ5MRm1KvA8EzB+CwaL0Xe3j3prWTCDgffj4mETkrW



On 3/2/23 11:38 PM, Jan Kara wrote:
> When buffered write fails to copy data into underlying page cache page,
> ocfs2_write_end_nolock() just zeroes out and dirties the page. This can
> leave dirty page beyond EOF and if page writeback tries to write this
> page before write succeeds and expands i_size, page gets into
> inconsistent state where page dirty bit is clear but buffer dirty bits
> stay set resulting in page data never getting written and so data copied
> to the page is lost. Fix the problem by invalidating page beyond EOF
> after failed write.
> 
> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
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

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
