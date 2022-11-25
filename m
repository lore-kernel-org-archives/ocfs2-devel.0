Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D705C46467
	for <ocfs2-devel@archiver.kernel.org>; Fri, 25 Nov 2022 10:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7rnuSA0FUJrOTjiPXAjqT5zMJ5GWgrMiVsG00uzKugE=;
 b=sDuRCf4a8J0hoa7LlnvcmOSL/AdYrFpfSr2S3Wp1jXWt2E6KkzKwcU+byHvOBd9Ad4dXu8Zhxpi5
   bKmHYwwoaow5t2GGlYafFONSDK0+RH0QLSQgMDmp+uBG4H2C0aXMo7v+KiB0G7RNhLe5G+MDQM8b
   FbltBc0vn966kb9dOjblqTnW7ifApC+9JxwkZloiB3PaT/Cb+dWOldp7wk72kUujkwlu6epFsWs6
   f2Mxnu0ufGZopDeAYMQiE2ZCUdPop/FieZNWT9FtiDxLuzeF0Bs3lYCdMh24IErBmzj4m7iYCJcp
   u3kzi0Xe0flensFhkcECLsCNIvFsKK26gaHZfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7rnuSA0FUJrOTjiPXAjqT5zMJ5GWgrMiVsG00uzKugE=;
 b=Mv3k1Op0/qY61zD8Gl9X5hTf7e3Gy6lD67TIe1/gkr6ue6Wz24RAWSN8Y3EoottNCvt0l4OBuaAD
   Wd4hkv4pboa6eARC8WKBsIUESx42BCkfkR3wEDTe0maF9s2Ltk9HO3xYCFlaoc1T2d+XIDg4MUzc
   HlP3MmXX4x6/UP+LOQP5fhABouoRnhol2QGrHa14Ls0dadt+OwNaaV8c4jpT6gTofKQBGFMCPrYu
   Pmo/eBIFV37EiPOdLlXlQHBeHzsGmtqvKs1RgVnL0vLxecBOSPG0B9QVYHXgRlqFoOPrNqRCAaDJ
   jMuqhxQeZxUoVu6exdYgSGQPC+0afAAXKIxhng==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLW00D1GF1J5I90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 25 Nov 2022 10:12:55 +0000 (GMT)
Message-id: <711323de-5a9f-db09-6105-319ff1ff52c1@linux.alibaba.com>
Date: Fri, 25 Nov 2022 17:41:04 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: lihongweizz <lihongweizz@inspur.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20221125034118.427-1-lihongweizz@inspur.com>
In-reply-to: <20221125034118.427-1-lihongweizz@inspur.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=978 priorityscore=104 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=6 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250076 domainage_hfrom=8625
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix infinite loop for orphan entry
	list
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R731e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0VVewUrY_1669369264;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 4lkGHz5ZKNYAJ7rnHOv3q1CAMmGSySgS
X-Proofpoint-GUID: 4lkGHz5ZKNYAJ7rnHOv3q1CAMmGSySgS
Reporting-Meta:
 AAHRg3ByWc+Vr19QOYhnaWRKaxVPr/C9xemKoU2ZTV2u4zqNrE+RrY+NJjaP6yVo
 RerPjGciVQ2E6Fyz3DLO5PT7r7qJK+qdNs430hrtfHhhM4INAuae0X6m5E9GRud5
 cDLO0ETeMrBsoNfT5vOTsiAo2N1Lpgx19Omx22zSR4CjkJA0Cbd1nKmRspiHaOS5
 aunNUZOunFZ9EGBQfe8gQVKb9CnriYNqVqkKmbFHhkjGOx4PjsWUx7XljpO1zV7m
 dKe69M3Mn/4lz+Fj5d91ETpBDrrcpkfs9DJGRllY32/iZ9MiHojEC2GVJ9W0o6n4
 tYlCfjr1BYpaT6TfZRXrM3SrevdiWnuzJaQ1dDEQ5Ao7dpw/GwI6MUjH/g9YTB7E
 Ap0mAL98ii7ma//BR9Im64BwFFjCgox+sogjKqL6nSsdNdoXcUwF9+tIGJiMI1ua
 NzNbdLfaMSmg9tJHu5Wou7qs02W2xDNrR+hEbVstkwPUzdR71iHWQUQ8mAplbp6c
 KHuoQ3UysPnSNmfcW8Rqt0pD5fa+I1CIDvuTYPsSxAA=



On 11/25/22 11:41 AM, lihongweizz wrote:
> Orphan file may be in the recover list already when the ip_next_orphan
> is NULL (for example, orphan file is second tail elementof recover
> list). In this scenario, the file could be added to the list twice
> and infinite loop happened. So we need another pointer value here(EFAULT)
>  instead of NULL for the list tail element.
> 

Don't understand how it happens. Is this a real issue you encountered?
When queue orphans, it will bypass those already in recover list.

Thanks,
Joseph

> Signed-off-by: lihongweizz <lihongweizz@inspur.com>
> ---
>  fs/ocfs2/journal.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 126671e..4620013 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -2207,7 +2207,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
>  				 enum ocfs2_orphan_reco_type orphan_reco_type)
>  {
>  	int ret = 0;
> -	struct inode *inode = NULL;
> +	struct inode *inode = ERR_PTR(-EFAULT);
>  	struct inode *iter;
>  	struct ocfs2_inode_info *oi;
>  	struct buffer_head *di_bh = NULL;
> @@ -2224,7 +2224,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
>  	if (ret)
>  		mlog_errno(ret);
>  
> -	while (inode) {
> +	while (!IS_ERR(inode)) {
>  		oi = OCFS2_I(inode);
>  		trace_ocfs2_recover_orphans_iput(
>  					(unsigned long long)oi->ip_blkno);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
