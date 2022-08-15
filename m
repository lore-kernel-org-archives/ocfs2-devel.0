Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B73FC282E7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 15 Aug 2022 08:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wVHVFm/DG+x4LCwx/id2x89EdxRhK55mcDYRSEqa+H4=;
 b=PqXcQ5kIEoJTH4/qwsnv5eD6iycmRgNyrYSU8vdUAgquJcEJ8gvciMycj1a1BpJ/iqpozwdxhWZf
   EvTknIHCE7sdUEtTpFn4wXkqsbg5TSzzBjwOdB6l6BizOYfOD60X5j8GNcxfgu6gUSsKDIDPI4hZ
   F1pgy40P696xlWl1AV2YEgwsw6rpOuDpC7GxQE0a6blxh9mAIP6Tdy3RxrIBpUjDmMHFTNFJ6ocj
   lOBT7d32tU3RoNrJFRHp2F7djTrZ5IYGM3/v1qudYR/RcvDE1Zp/3TZHwcx/J+ZbTUCl2Rg+i9IB
   BTkDs62vD9zZ7CzB/slUSKEkFub5tMVNISqffw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wVHVFm/DG+x4LCwx/id2x89EdxRhK55mcDYRSEqa+H4=;
 b=B8EfKr4sazRCUI/3mAnNl3Gp2Jjj0ozp4YXei0kJlsKmTDZDjU60UfkU7GtNKiryYB7qvnsTF/RA
   uOLUaV3snHbRyMdo+p0ChKFJPL2C6PcRsyEKhrAX0t8Kkx0RNlk4R9ROOkng90uGIWj1e1dFOJfn
   O0I8s2TVy3oGcF7XpF3BNyeW4SPIdXbnaq1ze9E6zzREY6f8P85Ekh/Ye2LNpW52JjnuQLXZsXPf
   y76Uj5kpJdk1Pm7bdshgRceFNxO2EkHKwBTyYEgFF2dnQYsj7gl6Od5TtPKM/r9GWRuk7/HyQACW
   eLkuIMolHAUZ3HcWnFyG3h211kbIJCTWUAyBAA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGN0045VD80ZHA0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 15 Aug 2022 08:07:12 +0000 (GMT)
Message-id: <d4ad82b6-bb2d-95c5-aed5-6b58d3ccf17f@linux.alibaba.com>
Date: Mon, 15 Aug 2022 16:06:50 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, junxiao.bi@oracle.com
References: <20220811094618.23175-1-heming.zhao@suse.com>
In-reply-to: <20220811094618.23175-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10439
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=134 lowpriorityscore=0 malwarescore=0 clxscore=121
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150028 domainage_hfrom=8523
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1] ocfs2: Fix freeing uninitialized resource
 on ocfs2_dlm_shutdown
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R521e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VMGiujO_1660550810;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: l0gMz_bBq2gJgTCtBvNUcEOgp6FeVFHq
X-Proofpoint-ORIG-GUID: l0gMz_bBq2gJgTCtBvNUcEOgp6FeVFHq
Reporting-Meta:
 AAHuzUCZvfYSh0NMZ/F3VGeRW8muFCZ8OFH/5hjxPJYc0ZKT3FPPCVmEwlkV2IST
 5baUxAp3ZS2JNVQ4Dg9MUhWbunfghSlFIVrY1H34EZOrmSHqkSk8/9OpRBnby67o
 TpZp6a0sdtSDW2F/+lwm8+pYfu34XnHU2E+34+RIikiBc+dxiQYfxdEzK2jRxpj9
 dTOPR+OOvuXWGtrZ+vUltpAinTnOnJ+6NRQtwCX99wbNlKswZ4vsrFkqPHKIgSJ0
 lsMH0B4gr8+aXUrxp7l2lY279EljfLv/WVdl4YBa9fxIG5Am0uSBpqSm7+nvVpQ+
 RrOsBXbGwtmFabeL7oOFGeJeV+7wm/ZeCi061JEhhBkGAtAT8ScsvSv2xlqPDisL
 6Ma4MLXawRXzPST7HosB1kvKxyS7IfntUon/CDW72i3MvrelUctO2/6Y91s8Ddse
 8LMHmlNkEd1uRSmKD3BVJQDEBmvWuytZvuvnXXka8o8ZD7NkmiV8ExGFQQjP0W6+
 D/gLEBv4eKApdJuPC11MLWV+w78xrcMJdzh9zCXcbqwX



On 8/11/22 5:46 PM, Heming Zhao wrote:
> On local mount mode, no dlm resource is initialized. If
> ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling

In fact, any procedure after ocfs2_dlm_init() fails will trigger this
issue. So we'd better describe it clearly, or just take the above case
as a example.

> will call ocfs2_dlm_shutdown(), then does dlm resource cleanup
> job, which will trigger kernel crash.
> 
> Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> draft -> v1:
>  - separate to a single patch
>  - by review comment:
>    - do free lockres in shutdown path
>    - put 'Fixes' string in one line
>  - revise misspelled & grammar mistake in commit log
> ---
>  fs/ocfs2/dlmglue.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 801e60bab955..c28bc983a7b1 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>  	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
>  	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
>  
> -	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
> -	osb->cconn = NULL;
> +	if (osb->cconn) {
> +		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
> +		osb->cconn = NULL;
>  
> -	ocfs2_dlm_shutdown_debug(osb);
> +		ocfs2_dlm_shutdown_debug(osb);
> +	}
>  }
>  
>  static int ocfs2_drop_lock(struct ocfs2_super *osb,

The checking osb->cconn in ocfs2_dismount_volume() has to be removed.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
