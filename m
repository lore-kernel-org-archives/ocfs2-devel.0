Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FF4C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Dec 2021 01:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4LZtLplJjA23zom6iHI3vf3XxjVGultMRSbm4Q9wqp4=;
 b=28mKcD29X8pCP0ilpDZQB981n+ifUf+ysSosRi640jGMPouFDlURWHHF9Jg3ARnL/a7+kgKT4qaS
   U3N4aC4D1yfFLSyELJaKsSFs0ZU5hr9CJrYxmS6tzsLdfWSyrSpQ9A8qAvmsQ++SqiKKrWQJmwm9
   ubP6bvM3Wjh59w+PC6sAPakTnhgEHL6W7GBp4GSz20KJ13YUZcCFmYEBnsYHmO4BR6cM19/MKMDe
   iuvDon9cEvDxsU9enFleSYL9ABSURgtJyQkdTnj8/J7Fa2UVPp071fh6hmNacB4otZLjGy2Tmcvs
   IYgn3ksxFfH+uTvMsqiJGTEgxSiKMiNgJ2NxGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4LZtLplJjA23zom6iHI3vf3XxjVGultMRSbm4Q9wqp4=;
 b=nCtCBfO3HYhCdoGpVnEOq5LH2cFcoAXJq6cnEoGzAFYS0Ohl9X7/hQZmB1CGkGhx175VFC41mFSs
   CgWSKTMu5xLYUQ5OwRUmfeCxJ8sReg4RLL6N+GktUpadDqTukAuEMUGuJo+7SxkDcRMEtWvULLCe
   r4YZWYZ7wSHkY6+EFaMNGlxZeyghMEsTkOdBiklNfmDQtiqHbpgUChCgb2X9pw6m0K0KaIhmKf4i
   ljtU0/+ouCUkKaHy19Cb3bT4+Ulw0LymQpC92wEFwaP19EFfYoixlL1n+8lealjIcY6utStDs4kH
   lsRt48JfIY0CUULjPzAphtvhDv5Kr5TLvRljsw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R4U00CWPSZVZ6E0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 29 Dec 2021 01:47:55 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <c91e5edb-9d27-f05d-6151-8aaf030583a7@linux.alibaba.com>
Date: Wed, 29 Dec 2021 09:47:32 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
References: <20211228144517.391660-1-gregkh@linuxfoundation.org>
In-reply-to: <20211228144517.391660-1-gregkh@linuxfoundation.org>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10211
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 priorityscore=95 clxscore=265 malwarescore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290006 domainage_hfrom=8294
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: use default_groups in kobj_type
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0V0B6Ze5_1640742452;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: equZ0oj5iOtVvZSJMvq3bJkNgoy_UwAD
X-Proofpoint-ORIG-GUID: equZ0oj5iOtVvZSJMvq3bJkNgoy_UwAD
Reporting-Meta:
 AAGxnFGXfW5zvJr1NWJ8cMVnXfhKZh4XDdZW0N5IRpUfrAl/2H4wXr4UY9cDeiI8
 5hPoaKLT2J+/q/4sRIrrzr5o6Ru42hVi7MZ+YZZ8rY47k+I9iHmI/BhtrKQSeNDD
 9iZtg2g/kPlR4QCyzeJO02/X1h0regPtHjnA7lXfi2C5UMjji3Ona0uFk0vhx2yI
 /p6Y0COBoddTkF/L0bVQ5VOXl8tUnDieY9jcMNy9dQVB9IzVASF3RqN0v1z+WdxI
 WbyuE8+GIfXbSBXDSw8xbKiqr887NP/4XKTyJ9qpclEZzWf+ewBfo2N2MNmQznWF
 T46+u+igSRi26X5bKc0PzKz8zTzDuPskekQCB22buiLCsRweYioBRfqdO5HByGP4
 +dHbek6+QCYLKyaEt+fi0CaRfr0qQrwRVcu0j1c1WFnI2rPoEV2c2X0gVO27AFIN
 JTro0MUcOc+FkmIjCfueB7IC7PDbu1nvZGhlF4pRlgkggaHJkX59s0o9ExEQ+jK3
 ++vRQ1R1Y8NM7eI/7ewY1B7gVpYSHnuXr7d4OzGXuOQ=

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

On 12/28/21 10:45 PM, Greg Kroah-Hartman wrote:
> There are currently 2 ways to create a set of sysfs files for a
> kobj_type, through the default_attrs field, and the default_groups
> field.  Move the ocfs2 code to use default_groups field which has been
> the preferred way since aa30f47cf666 ("kobject: Add support for default
> attribute groups to kobj_type") so that we can soon get rid of the
> obsolete default_attrs field.
> 
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel@oss.oracle.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/ocfs2/filecheck.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index de56e6231af8..1ad7106741f8 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -94,6 +94,7 @@ static struct attribute *ocfs2_filecheck_attrs[] = {
>  	&ocfs2_filecheck_attr_set.attr,
>  	NULL
>  };
> +ATTRIBUTE_GROUPS(ocfs2_filecheck);
>  
>  static void ocfs2_filecheck_release(struct kobject *kobj)
>  {
> @@ -138,7 +139,7 @@ static const struct sysfs_ops ocfs2_filecheck_ops = {
>  };
>  
>  static struct kobj_type ocfs2_ktype_filecheck = {
> -	.default_attrs = ocfs2_filecheck_attrs,
> +	.default_groups = ocfs2_filecheck_groups,
>  	.sysfs_ops = &ocfs2_filecheck_ops,
>  	.release = ocfs2_filecheck_release,
>  };

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
