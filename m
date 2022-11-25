Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6502C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 25 Nov 2022 10:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v9LDnV4lvWF6SWfLc1tAkwt/hNIqbcYs9DAFdHFJt0U=;
 b=N64rqQE0jC9K/7RROtVUbKW1UyOOt/Le+/leGuw1WqEuxx5t+n8x9UYIYc5Njoq+TSeyHtEf234W
   4FFDDlnKEt/6fCeslCMGHcZznXgfPErf0/Jr9F65TgEmsjc/FCgkEtfplDQ5uq6cjlz903bEuPnc
   kwmSrqPBvsZqbfYE0KXlEUDmcCdKXKFUYb6Y29Q6+Fg1uYlKzK0pjMKUldeVD+gFnqvMEKQ+Xtri
   MOAr2rsfJ5FYQIGX0kDokooEnseRgPOR66eIAISQdW8z0r2uCfEdQiQaNxAj1rv7yek6Irg08UWf
   KDwrc6WYQm2jU9DUrluPg+tXGy3hFHCEo6XRNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v9LDnV4lvWF6SWfLc1tAkwt/hNIqbcYs9DAFdHFJt0U=;
 b=TVcGbhHw5eG1kJHd1UfdcBBjYBQlZq2mlB8GUQjDe5bUkt74DygknCrCTaWLeSEGZkGx6CWFshdn
   B/K7OrChsp3X06bWwEa/MsWBB6/9+FjEB8ft704z69nA3S4ZyP7Vo+tW74oWkpYYUED2cxE6GhV0
   6YX0xck7kb9j9rb2COfhsh+JIbwo3HWtbVOrdjRNC4DAW2JRE7/ZApKQYyLxvZKNj4d135SfNRbx
   GT6KLvCMvMIT7BhPbKJDeLMc1AZOOIv/xNLSqdVmRSBcZYfeGICG35ZcM41qUpzExUiAfW7uxRc7
   ExGDkguw4nJkkGU4qJ5uaARA7NHw/Nvpiq6YNw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLW00IK5F1IWMA0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 25 Nov 2022 10:12:54 +0000 (GMT)
Message-id: <03a60f60-6408-b67c-6e66-d4ff1d24089c@linux.alibaba.com>
Date: Fri, 25 Nov 2022 17:28:56 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: lihongweizz <lihongweizz@inspur.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20221125031522.339-1-lihongweizz@inspur.com>
In-reply-to: <20221125031522.339-1-lihongweizz@inspur.com>
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=999 priorityscore=85 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=6 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250074 domainage_hfrom=8625
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: properly clean task pointer before
 o2hb thread exits abnormally
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0VVedjiE_1669368536;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: IwzadXzI3HDJo4MPiNend5uef6xU0FYQ
X-Proofpoint-ORIG-GUID: IwzadXzI3HDJo4MPiNend5uef6xU0FYQ
Reporting-Meta:
 AAE1WvayiAG05vAkmUgKGaKjAIRbyQQyEAjVPr6apxPhI44MLj+oG3CiqkjuwPmc
 qmcqhN6BG7hh/LsLyCXV++Nt0IpUHaFQRfJaVUIN0pjGJFcX7gX5Zs/hc/d73EjD
 Ptg31O9QFz8rQlFMLEGFqby0gqq7zlrdHQy1AoMUecVA5KYvrjYeUe6EsAoeppiq
 KdD5k9/JICsAaPfLklKQ/CBtNz2sc/FKCDM8J9WYbZBuFwygmNU6KDQdBzSg3Lux
 sCWoOi2Z0baDqH3rOt94zG0lYxDhWmTJUj9tqZlkIkFkYfO8kgjVOc5MNFTfdX8A
 +/u+o2cnW8OE/19nwJz+2rSR1qM2A4Kju5hX5/1ROBXzGz/Jxq4ng2h6WJigCftl
 JPqWrWfAAIOwBt1o/zP5T3amW6bC32ajPaW4XyihiLvvXHnkXSH6oh6UJGgmCggC
 /Mx8dNIWmA1Xutzzm3GE6BEpRJc5gXtbBJjOGnlqSdDSbU/rFoaamSDd8EjG/glH
 o4CZbn8Xc+sj0NfFWHuN4SQsNo9OA9K75oFKK9+hWnYb



On 11/25/22 11:15 AM, lihongweizz wrote:
> From: Rock Li <lihongweizz@inspur.com>
> 
> in case o2hb thread exits abnormally before stop o2cb service,
> heartbeat_drop_group_item will try to stop a noexit thread cause
> ret->hb_task was not clear properly.
> 
Could you please describe the scenario in detail?

Thanks,
Joseph 

> Signed-off-by: Rock Li <lihongweizz@inspur.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index b13d344..9db448d 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1258,6 +1258,8 @@ static int o2hb_thread(void *data)
>  	/* Unpin node */
>  	o2nm_undepend_this_node();
>  
> +	reg->hr_task = NULL;
> +
>  	mlog(ML_HEARTBEAT|ML_KTHREAD, "o2hb thread exiting\n");
>  
>  	return 0;

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
