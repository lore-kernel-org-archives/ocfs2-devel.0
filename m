Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1D5C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Aug 2022 06:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=W5SaFjZCMJzQOwoBJ+d/lUa+nOxza0BqCys7Qs489Ek=;
 b=v5DYj7YXE9X5yzdXVbnO2yOM+ZlCo8B7q751+WdpYXCLIv8LIhoznHt08H6v4fDv5kXx/eAgFtn3
   f9iPtzPRfJwiaPz381WCEqpk0HB+7fP9QTxPbp1kQlb7fWTjCPiE3/aEOW1dAfao//vMp4quXPMr
   ep0nIB4J1xR7DPq9roYUn7Kduvw7JGxCJshojdW+ATsss5Eplno1oaEiL0kHxvxxV1bnSsQ+gHQ7
   uy2kr2Fl58XBHcGbmRlcV1Kmo7M1CfCgoOYBQQ/IMjx97w5UsoNCvkUR3WWKYeF6/34/GCqXiXCc
   XOAvZx8lvZPiPgLJZWUefAEbyNftTTxKFx2dFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=W5SaFjZCMJzQOwoBJ+d/lUa+nOxza0BqCys7Qs489Ek=;
 b=a4lQl8S3MdyHEmtYzaEvXSCjuRzUnmdQZC8JbqZNXLAe6S9jLq/0AMBv4gAwIYuifBBhsKmEvzVP
   OqFfDbdJlQINq2CcNKoyoDu2GoZirokKymQ7DKzovsRBy2wHH/60tRefzPRgNpBYLhdWt2h+Ji25
   TpE3utr74TzRleHxiuyxnPElAmKACegBm3ZPFroq443YXR2HQ1TCOLFyRchzz/3S3J+AAxPdLeOu
   QJ+MfGaOT3e7S3rnuoO82VVGdIfUkxAR20kT9Ox0cJQh2KQvzDFudYnDNUT7lVlMzUCCkZJVhfP7
   GVvg4RGIcOIoSea17O8ZKh2/hNP90vEP2dNxGw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGA00BA5B1XTO00@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 Aug 2022 06:51:33 +0000 (GMT)
Message-id: <2dd9c00b-bd33-7368-def9-9572dd7e6820@linux.alibaba.com>
Date: Mon, 8 Aug 2022 14:51:12 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-2-heming.zhao@suse.com>
In-reply-to: <20220730011411.11214-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10432
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=-23 lowpriorityscore=0
 mlxscore=0 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080035 domainage_hfrom=8516
Subject: Re: [Ocfs2-devel] [PATCH 1/4] ocfs2: Fix freeing uninitialized
 resource on ocfs2_dlm_shutdown
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VLe4xJm_1659941472;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: m-S1DV5aOei8-lgfCCLEmiy1sBz2RnQ9
X-Proofpoint-GUID: m-S1DV5aOei8-lgfCCLEmiy1sBz2RnQ9
Reporting-Meta:
 AAGVD1S9BtNSfcx+5ZFEeKBlnnToZVD1BIbjPG7l9X0SqksvpeTTgfgDa6lxPGhd
 2cbe3K+Xodrls7Il3d4ZwbmObM/hLYj70MayodrWAI3+Q89K2c+kk9ODk9RVOcOh
 9PUrR063q/etGKuARC8Jn0nPedo7aUHgPRxi47SFw+WjRqDIr6rDujK+1bMlKP6q
 +3UrKxWhAnxftN51O0HcBugBjjtHOwfJmdOVpSL5dJmBGVTAcIDw9FZUkMdqAlag
 F/ini1lbA8o6YnOQITW6YMdVIBiRvkGzoE6TbfebLwPBfWKn+IagYREwlG7w5cq6
 n/vinNr08b8kGnY3VpQLVfqD82p3LSk82cuVThtfkwIwPRyiz/1KTZDDCyuWS5+F
 sfsImAZk7DihSvAwi4kgl0JRNslX45mgCe1FSdBzfRG55aMY/QlEc4MfPQ3bv9Ov
 bRw6Al8EHN9J1veonQNTLlnViY3QNjts/HwX0kayhAVQYfYcJSscRmxjQKD4zIyZ
 VkzROwDonJK+YzreA5QWUXm/OXMb/B3K1bF+eJd7Cq8I



On 7/30/22 9:14 AM, Heming Zhao wrote:
> On local mount mode, there is no dlm resource initalized. If
> ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
> flow will call ocfs2_dlm_shutdown(), then does dlm resource
> cleanup job, which will trigger kernel crash.
> 
> Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before
> return error")

Should be put at the same line.

> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/dlmglue.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 801e60bab955..1438ac14940b 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3385,6 +3385,9 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>  void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>  			int hangup_pending)
>  {
> +	if (ocfs2_mount_local(osb))
> +		return;
> +

IMO, we have to do part of ocfs2_dlm_shutdown() jobs such as
ocfs2_lock_res_free(), which will remove lockres from d_lockres_tracking
added by ocfs2_xxx_lock_res_init().

Before commit 0737e01de9c4, it seems this issue also exists since
osb->cconn is already set under local mount mode. 

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
