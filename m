Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C027C00140
	for <ocfs2-devel@archiver.kernel.org>; Sun, 21 Aug 2022 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=97vX5RUMuzmFHY11wltAd1w9JzZBdg1e09XZksH+k/8=;
 b=vpKwcq2xc+0fduXFRTEV9CPsByFYPt1gWbVUGfKg3L8HI0Pmxfag/5s0RfWB8q9erxQGqrpFLU0B
   YQWpQnJnHg5E0ui8MqMvUB6QoBe6tMhPjkidayACoAYWrN47QkgmOKeC50vluEkdXPy7jJNvGOvQ
   idFmZQDnSWwA1Gmx4xkGiVAmWSPD0qERX9gcDsP4702I+yHzyPesHkGtUFn0BwAAdTdx2ELw8AI4
   hkVsL3I9123u1OcpXWUVSgdr/JHjBp/t2bvPo5ouh+4v5bzUvAWthsGeSKPTLpE+NmBZqM/5Ympn
   geb35OyXTSSIZAX6zWmqq2777CscEOffuCL0fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=97vX5RUMuzmFHY11wltAd1w9JzZBdg1e09XZksH+k/8=;
 b=r9S11g8ei5426P7ncdwS/+HN7k7ayp58zH/ZmUOTiwz9wCV0ePvuFJqTdaOMmxoCdoDAgG2kTN1j
   M2lYgTgRcBWLi2fBhJchhrpURlnfULBtgPb17JaSah0DZ/XEc9eviaOk32NIyRQUtHJG9VHNO4Zk
   JyjTetmFmaHGNX15CYs/itH+5LTr5dh5eYsPTeiXiEPCkgf2DtOdfTQmE7ZAdYErPTnoz2pP01+e
   afIhU3fjHP8fBWvykH0ytUL+1oQ3iGQ7ZYoYt9yZLSNaPu5XEqVN4Kq9YfpowzjPGIJrha/4J4w5
   3PsyGSV4E0P80GS7jth7NQIiD6QfyxlkmD6mLw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220805 64bit (built Aug  5
 2022))
 with ESMTPS id <0RGY00CLOVXIGK40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 21 Aug 2022 13:24:55 +0000 (GMT)
Message-id: <71c6c3cd-5022-dd7c-d8d0-d1c354c85f13@linux.alibaba.com>
Date: Sun, 21 Aug 2022 21:24:29 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-language: en-US
To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
 linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
References: <20220818210123.7637-1-wsa+renesas@sang-engineering.com>
 <20220818210123.7637-4-wsa+renesas@sang-engineering.com>
In-reply-to: <20220818210123.7637-4-wsa+renesas@sang-engineering.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10446
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=129 priorityscore=123
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208210053 domainage_hfrom=8529
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 04/14] ocfs2: move from strlcpy with unused
 retval to strscpy
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R551e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VMnWTjg_1661088269;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: cOtT92HQdEEAfSeZP_qj2uXSELJFtofU
X-Proofpoint-ORIG-GUID: cOtT92HQdEEAfSeZP_qj2uXSELJFtofU
Reporting-Meta:
 AAESJEv6Z9rYR+RHMJaCJZ+Q5KC2S1BDcmx1m0CDbOft5QdkTJPMubkaq14o6Qpt
 vqyp8kwg+gG1lKBis2zc7oD8gC3IXKFSciU93oNXhHWf1VrsiFGa8iwTWyP5f34b
 TQQ0UeIr30v32htXhe4dVMC74iEbN5x6OPTV6y36vVv6pKtRdrQDx+g1HbHlSap8
 WbEeLO46nq3lyLdD9TD17hG0O4wr7pN4Y9f08vsBpri0vk8TE6dH6jmtxygiTjZ8
 07ezcag5kJSQvw8DSzfaUdDmImdxbbeDS/NFkREDslQdUoHxK9xlt4bwOCiov9uR
 bfyoORpwTRDo3uJpN5DRn8tg24vv7Wwx637J3crrecFO220NHEXXEKNLEL+xJr4H
 rafrxURU90On8x1XgfpZp0vVoaz/xqkToEhKDWD/efwew268XyQb1BaXpnty0uis
 A06CVg33PVYxokTQ0uHp3w0CLiQsx1/NYxOmngLcK0z5xKpBlt+Cheqx07ScAWM6
 ksYmA86rshfBkMKVa5Vf+FymtIowJSKxDQbnUMdQumatuw==



On 8/19/22 5:01 AM, Wolfram Sang wrote:
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
> 
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/stackglue.c | 4 ++--
>  fs/ocfs2/super.c     | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index dd77b7aaabf5..317126261523 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -334,10 +334,10 @@ int ocfs2_cluster_connect(const char *stack_name,
>  		goto out;
>  	}
>  
> -	strlcpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
> +	strscpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
>  	new_conn->cc_namelen = grouplen;
>  	if (cluster_name_len)
> -		strlcpy(new_conn->cc_cluster_name, cluster_name,
> +		strscpy(new_conn->cc_cluster_name, cluster_name,
>  			CLUSTER_NAME_MAX + 1);
>  	new_conn->cc_cluster_name_len = cluster_name_len;
>  	new_conn->cc_recovery_handler = recovery_handler;
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 013a727bd7c8..ec46489b6c7e 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2222,7 +2222,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		goto out_journal;
>  	}
>  
> -	strlcpy(osb->vol_label, di->id2.i_super.s_label,
> +	strscpy(osb->vol_label, di->id2.i_super.s_label,
>  		OCFS2_MAX_VOL_LABEL_LEN);
>  	osb->root_blkno = le64_to_cpu(di->id2.i_super.s_root_blkno);
>  	osb->system_dir_blkno = le64_to_cpu(di->id2.i_super.s_system_dir_blkno);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
