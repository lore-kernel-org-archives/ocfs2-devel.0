Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9429FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 Jan 2022 02:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CGlzQIOPIixB9ssvYbAAsWRGZRH+dJborAsLxEj4QKQ=;
 b=KmBrRznZbH3EbIDPh9i9Ce7neWdmAEBg4yj0MGw2grbczlqek1fcIvLSnkHq+dO6lPcINfxI5pZ5
   jlCEeK2ekgeuOAHOajKXsLAqSaAwJfw1cVuE+x4Ot+4uGMrsgO6NzULe1/5V6nGFbJ8S+yHE8NzI
   uMv5ENrgEzQn27HzX2ZFTCBUBg9qu7ZImvixuz4Gy/YpNBdMK32w8BBJiVfJqUkMGXMwhB8oV1kD
   /E4NWT9MYuUnO3NPn7c3+Fj7BHyPe+yNcbCghdU2BI+ReKYkye5gRthWS6doMVISuCtaPqNQtxC/
   iLmu1+E1lRfoZaEOZvebqUV4lMsqPFmYK/k5tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CGlzQIOPIixB9ssvYbAAsWRGZRH+dJborAsLxEj4QKQ=;
 b=hVc4bf6E//11VnHMkrAWTx9BXy9elMIG21e4M0y6hDl+8Yn8u6PlYnbWcwQoRSAt7mrMAWhclsDj
   UnsDoLVuruuAOTiJ5rmNT2y6/yNgc0lKd40B8EGARu5dNdVIxZh0IK1odWJoruxCIeDnej7ueOHN
   jknykUt6uMdS7Vm3SDgD9bgOxTdSjEGXAQQ09c9VeVu1xLlyDTVOik4etJfmESiDSh705PODf9Pq
   sDhd1n8V6/5x4tN4Ny1wY8cvuEfqwInMDyatDuWj7FEGNrHSTyvf9iXZWKxNtT8DzWA4Gt7IoK5Y
   6BGjLlCdFvYDNqA6Flk4dXsVUutcMd2CVC1kaw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5M009YVMEUBPB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 13 Jan 2022 02:18:30 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <dc5c3f04-b13f-6c32-9836-8d9f9783b81f@linux.alibaba.com>
Date: Thu, 13 Jan 2022 10:18:12 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Colin Ian King <colin.i.king@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220112230411.1090761-1-colin.i.king@gmail.com>
In-reply-to: <20220112230411.1090761-1-colin.i.king@gmail.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=111
 impostorscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=206 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130008 domainage_hfrom=8309
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: remove redundant assignment to
	variable free_space
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R481e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0V1hSvEW_1642040292;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 4qoP1xB3-sxAaffIOFF71L7z_R5qHWSf
X-Proofpoint-ORIG-GUID: 4qoP1xB3-sxAaffIOFF71L7z_R5qHWSf
Reporting-Meta:
 AAHzOrEAfJNgerMoyZGBmv5bxj4snjKM1ykBsCPKS6rVA6KI8g9I4bNE10gvzo28
 SVc6UkhQYqO8tPN2GeEh5wLZ2Aklg8fh3C7X+mqdDeMm7aMhWzR7W0DcYb7yQJC1
 h8dI7DczQPokrMt7orfFtdoskXWbpkfQAOu//X6QPSJ5ceIaJb7Bl3FhkqKqxo9P
 nu2i6G86/I2F3QEtrVmriF8EdhvhGR+HlcUmFfa1KhRw96LHYbQY/MRrtJii+qH9
 Zy3cqzyKxutmelRbtzuuQoeYh78dnMsVXjb/kCBvuqXC9SEhLK4iqp0SYeJrmx1H
 bDK5uS1P7imLlFFTmotBL/AnQtDK4l82xgECkWjcnDvwKsWGExPBUYJ67g12Vqbz
 6EDfOpPXRt6p/uFewoI70hne8ONQJaiWoj4aPs/jm3pTs5FMkTCBN6L5tLHpE/gY
 uxdT+zVwPLxcOz6MBfebDTlKLrQKI/zdVjFj9T70cBAmKFq3O62MjE+dG55qylZG
 1MNNBXSFd68+VyKr34s+jLdD8yPUOCnXgzFd3cKIw4oT



On 1/13/22 7:04 AM, Colin Ian King wrote:
> Variable free_space is being initialized with a value that is not read,
> it is being re-assigned later in the two paths of an if statement. The
> early initialization is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index bd8d534f11cb..f2cc1ff29e6d 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3343,7 +3343,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>  	struct ocfs2_dir_entry *de, *last_de = NULL;
>  	char *de_buf, *limit;
>  	unsigned long offset = 0;
> -	unsigned int rec_len, new_rec_len, free_space = dir->i_sb->s_blocksize;
> +	unsigned int rec_len, new_rec_len, free_space;
>  
>  	/*
>  	 * This calculates how many free bytes we'd have in block zero, should

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
