Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A8EC6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 03:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WlioQ0ug20gGJCivNnTaYVMTG4tF0jFzGTHnEa/g9TA=;
 b=RMB7R/9nkDVNdlnSRfoogsEQShQz0cBqDLRmhOzFTqsgFu72R89I2IFfLdXL91wscvOJDR5aWzcW
   /gFwF+3/Ah8629KYnmDwKXfnmm9poUlfhklmUJ66QBRffiz8+Sdr8w60MzsIBFFLB2XukEgy/fZQ
   pcFOl57NF7UQVuHXhFEPnyUswD5NZnoLrM+UZB/GUuM8fDtbS77IhAB/Ru9t5z3hJ6aWN+vrPfgZ
   tM4CkoJBqWJMaLsJN/OZlizS3yVI6gVgssiiMFJoxAur0jVjjDYniBDyjajZCpBsjAMQv6GfB4BA
   6d7x3iMeN/z4y6FTZROsGBEbeJ9nQk64/6x3LQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WlioQ0ug20gGJCivNnTaYVMTG4tF0jFzGTHnEa/g9TA=;
 b=pmi1PDCGxSTW7sG0+WmSGdqv5LYr+du/jp2q1TF6NXhPNsNaoIXI/yadt7vcfyopk+MiSCZnf+CT
   P3/2//T92a1sbdQTMZjUt2Vaj5J6QANU/z5zRnOXPy75oJm/S0a0qWZBD7jsS5eOpE7F2RbbjQKw
   MEhcf1tukghQ4ESnHWEeEUDzxv+xYt2cz65u7IUzGgNSDFaciY+EOAgZU7vJJ+uM8QeB+qMZW+rR
   qBx8BzV3TS7M9eya5bZLK/HLJa6d26vLCzcobDNP190UzMTFmgASVaLgGSDJDIlTDpU8uaiG+kxy
   lxoWSf0PcoL5+rkaniC7sYKaR6sMI1dMubJvQQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRS00FSNVBQ2N90@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 03:35:50 +0000 (GMT)
Message-id: <308c0ee8-cf42-1342-9745-76b715086c02@linux.alibaba.com>
Date: Mon, 20 Mar 2023 11:35:05 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Content-language: en-US
To: Yangtao Li <frank.li@vivo.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20230319092641.41917-1-frank.li@vivo.com>
 <20230319092641.41917-8-frank.li@vivo.com>
In-reply-to: <20230319092641.41917-8-frank.li@vivo.com>
X-Source-IP: 115.124.30.111
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 clxscore=-90 phishscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200030 domainage_hfrom=8740
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2,
	RESEND 08/10] ocfs2: convert to kobject_del_and_put()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R651e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VeAEmqc_1679283305;
X-ServerName: out30-111.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: MIwnzzchM4C_WHCNjEunQY2vZrELVFbn
X-Proofpoint-ORIG-GUID: MIwnzzchM4C_WHCNjEunQY2vZrELVFbn
Reporting-Meta:
 AAEsuGp1ZXBrWxADqLgLWRHIMw+PXrY9BJjA/l62tjUZoNNp9dHEGGqK1Lyt4Raa
 KjXOvSneC7oaj8gNLBllLY315qZD8UkWDRls231/aZWF2VIvAicO2DHMwE7ItfjF
 JVOKQq4sWyBrBbWvk2KoGr5edbvdDFF1pm+WT8KZh/rKX+jJglFWABVytPhbF6P4
 PmJAl2xPIbFTnHzE08u+9RghsBodNYcwjApkGiadRjUF6emM7og3nwCz7BZydDDc
 A6u1W59YtkT05ppOyvPlUTgz6KAE2LUliodT/SH315PmOLv69XKV4ZFox/ADPoEP
 BZoRI9P2dMnCKXXjBn+kJuIbEj+InEIl7QvU33c92lvJ+cXHb8J2tVcO3H+QN06K
 MaYRL2g5XzbStlHLa23DwTolTNav8FPzeVig2woyuasROEyW65YFbfmcFfBFNegr
 WFezKSlLKExrNlyuTXuLvCY8067JAMSkeW6IgeTo0UG5OOHczM3IZoWDsQyPBE2s
 YXnY70jZSkthPSNUsBEAFJKO+kv9/zzP8s8H1QuwlbMG



On 3/19/23 5:26 PM, Yangtao Li wrote:
> Use kobject_del_and_put() to simplify code.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
>  fs/ocfs2/filecheck.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index 1ad7106741f8..fb9cf601245b 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -198,8 +198,7 @@ void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb)
>  	if (!osb->osb_fc_ent.fs_fcheck)
>  		return;
>  
> -	kobject_del(&osb->osb_fc_ent.fs_kobj);
> -	kobject_put(&osb->osb_fc_ent.fs_kobj);
> +	kobject_del_and_put(&osb->osb_fc_ent.fs_kobj);
>  	wait_for_completion(&osb->osb_fc_ent.fs_kobj_unregister);
>  	ocfs2_filecheck_sysfs_free(&osb->osb_fc_ent);
>  }

Can't find any implementation of kobject_del_and_put() in mainline.
So I guess you've introduced it at the beginning of this series? Since I
can only see this one:(
So it depends on kobject lib. If kobject lib accepts this helper, it's
fine to me.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
