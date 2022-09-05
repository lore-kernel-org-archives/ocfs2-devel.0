Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A15CECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fQnDN6yGgPURp0NMC/vaSSv4vfuxMKNvf7aUlDKAp+M=;
 b=Y87+Zaig1XwrMhayXFb8J5lvZHp6180iHI+hhrKqCxO0mArH4pxiBHjLXZ1tyaEwXXjc24AtCmT7
   pQywSPYc4cvebqb5j9FkMR9lEjk5hleOOL72+sVPneBBjujxBGCxdbeHp9QxLOVT9nCJY3P1FGSC
   F4KGgPNcuq0ogfv0WCVNiqU9n1gkePkWA2FaH6oqYucsqj7dWppPYd9DHEcKZonPJGMUNckj7uqR
   mLxlVBiW2obaOWAvCJ3Sg4Vs3l6/LootVimWs2tpn9GjxvW05XMmRcnwP6Z7i1v7J2+J/Nvk7z9O
   NUWFYGAWS4C12yCGNGhVypB8irSQAA40n4yYcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fQnDN6yGgPURp0NMC/vaSSv4vfuxMKNvf7aUlDKAp+M=;
 b=fkOku0OsUlI0V9JOvS4bhTwcc4L3Z9kKNOYF73pm7rm5Yahu+goLIcHIByLQTe/M5n+cN98fbuXG
   u911PRUlAlUH08ADwZYpzpq8N04vRzjlgrcCXOPjAqMKs010A7IC2DfmcSlwTuxVxPqvlhtoYeqf
   em40mSm9Xnq/AxcT8X39KbpRw5vpxsp3sTC5RjHINbCrZUtybl/kbeRFW1KM3Y89tAijPwZUVg/i
   bXfmEaV496n3ptdx8QZjUVvnR6rMp+jdAod+DDWI6FyfM4ouGvDEodYlgbcwV1I8rPEXDebbydp+
   u5qTfdaPQnO6uaYe0S5yHOeIlTZuW7SxcjoAsQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ0013HNKG3I10@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 13:17:04 +0000 (GMT)
Message-id: <e099ea78-cc1d-41d3-4ca7-99d5f723f440@linux.alibaba.com>
Date: Mon, 5 Sep 2022 16:04:11 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Content-language: en-US
To: Jiangshan Yi <13667453960@163.com>, mark@fasheh.com, jlbec@evilplan.org,
 akpm <akpm@linux-foundation.org>
References: <20220905061656.1829179-1-13667453960@163.com>
In-reply-to: <20220905061656.1829179-1-13667453960@163.com>
X-Source-IP: 115.124.30.42
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=125
 mlxscore=0 phishscore=0 priorityscore=143 spamscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050038 domainage_hfrom=8544
Cc: k2ci <kernel-bot@kylinos.cn>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: Re: [Ocfs2-devel] [PATCH] fs/ocfs2/suballoc.h: fix spelling typo in
	comment
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VOOS-JL_1662365052;
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: VoPefMJKhQ7oQwqAIJFjcvJKNDjj1q97
X-Proofpoint-GUID: VoPefMJKhQ7oQwqAIJFjcvJKNDjj1q97
Reporting-Meta:
 AAHxvMdLq8JJ+wa7nuWtihrCSMzUFoYlP2DjaDsU7zhLgb2ZqzMnfTRDPSHjLxR9
 marA8swS7MpOhFbZpCNdY5zTkfNtBVIMR7wCXVALWPmtKKDN4NrYxLMO0mxUnl8O
 u/nvP2AmVMmXzEJD1z4luVtRjTr3zKyDMSgafHsE+OSElftF5+6fl9eiosHYw4Z7
 TeVhm429eULci6YuFd4MZ70XAInyNfUvmaezhgL+IiYG1dj1jAjEx6OU301IpaM0
 C+BtGlJ/Q9GWtHd+w9ItrVSU+Dp+w+Ej0BRoxNPbv2NNbpO5RjuQYIDcaTL/1UsT
 OZQGnq6wdxLuyGUqg9o8DtHSjB6FjoKJL69Euo9YeJtVAxjx9hhAkVi+qi+36pNJ
 QT0wIBihl/NN7Ud1WK82ht6SDSxYrhnw3C8GkOsnF20KGbjYHUElTfx3TU3fdskE
 R7bLI0S5n+FKiMjCn81f9ZWJAhUxW60CRmM4q51NIAGy26LXxq4E4TBQ85LJLfoU
 mzwC6KGyPSqG9hJHNZisR8yoTnX857OpsSkWOVkt2EwY



On 9/5/22 2:16 PM, Jiangshan Yi wrote:
> From: Jiangshan Yi <yijiangshan@kylinos.cn>
> 
> Fix spelling typo in comment.
> 
> Reported-by: k2ci <kernel-bot@kylinos.cn>
> Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/suballoc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index 5805a03d100b..9c74eace3adc 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -106,7 +106,7 @@ int ocfs2_claim_clusters(handle_t *handle,
>  			 u32 *cluster_start,
>  			 u32 *num_clusters);
>  /*
> - * Use this variant of ocfs2_claim_clusters to specify a maxiumum
> + * Use this variant of ocfs2_claim_clusters to specify a maximum
>   * number of clusters smaller than the allocation reserved.
>   */
>  int __ocfs2_claim_clusters(handle_t *handle,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
