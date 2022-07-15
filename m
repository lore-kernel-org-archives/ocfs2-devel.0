Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE7F4C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Jul 2022 21:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v65dxnAWd62kXAXE/yXVWsyhnH5MKGZ6U2fbMoHmuAE=;
 b=ZsBI6PEHRTSU7xiFz69g6hLBDHCu6SU0H7RN2MXZkQeaurvliX8iPgJ2oBsZNg0O8e8XHZ2I7Fx9
   qoArR3Rd1hOox2em3c06RmPPSRnt1/+9X4FxiDk19gtFkqeE47aP4hWQakHytUFhSbSH/3UVrhAe
   0LeVOViU2o0wErfeAswuCJBbRlWTqCF3X7xQ2yW69G98sjBnlpT/Bpdtk/cPU9OhZmmgOH5nMube
   yRJITIyN7IxmzY2TGhRbHVCF3icZGJfPRweXLN94Rnyb8qSRqcldiwtEjC9gDDsXnVLHB0C9uZPI
   aeI2nf5V7gFXCTkTycrNPDqcxLS+BIEWeU3zNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v65dxnAWd62kXAXE/yXVWsyhnH5MKGZ6U2fbMoHmuAE=;
 b=dRGuq943BIIOObK7SPaCL/s+tVi9ywzJe6f80Kcukc+ZmQ1vpVyEOW2DQ89CUJMRD87w4+xbSVuQ
   9EL7gMIkhM+stkCs6Y6OYAffdRixVk0C3EMGoVqb0qw+g6tAnzn+li3oAryz/8CrVEVUvKDc33c0
   DqX/RAKqUQZXsQM0iAbPFzoKnuBUXeAy4PxiugaAHWupp0QbSOoYXTpECXAMluHTMnvJItUsAjy/
   Y9wRDlZ/yvn0bkhy6oZTkZXsDCpuBcaQMGoRMXyWo/yHUn2r9os10iRgPJI01GIYMuzyIYDEcXrj
   JCvJV6eSXBHtu/VErjGIt+VkcTGyOk8TeKIYtQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF2000LNYJISV20@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Jul 2022 21:04:30 +0000 (GMT)
Message-id: <793cab25-a591-b4f4-c4a6-bb80ac681a02@linux.alibaba.com>
Date: Fri, 15 Jul 2022 16:18:11 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Jiangshan Yi <13667453960@163.com>, mark@fasheh.com, jlbec@evilplan.org,
 akpm@linux-foundation.org
References: <20220715060035.632903-1-13667453960@163.com>
In-reply-to: <20220715060035.632903-1-13667453960@163.com>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10408
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=200
 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 priorityscore=78 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150035 domainage_hfrom=8492
Cc: k2ci <kernel-bot@kylinos.cn>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: Re: [Ocfs2-devel] [PATCH] fs/ocfs2: Fix spelling typo in comment
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R691e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VJOSTJF_1657873092;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: jOmxIWohuRlNflN5N_h_Ejyy8rkqu1CP
X-Proofpoint-GUID: jOmxIWohuRlNflN5N_h_Ejyy8rkqu1CP
Reporting-Meta:
 AAEbDXbyaNgsbh6TEq+qR1f3mxB8K6rFDbUAB9oKoRCcFIkQCjwSgAtm/aVRO08C
 7TF+kOb6Xsd9PTMUiUg8mBVTWYlpEcDmSSzm12d1U7o++qWU1FJiron4bHd9/I46
 ImO4LahGZm2YGIkHSD1MKLg7+JRw41rjVm0gOlQlxWc6qaua/hA1SsVPH45p2aF5
 8VVPCU9Akh/EWMMotAqhC7SKndIHeC2QM/RaKsyb3fYkK3z4OMdZ1n9tUuOiFd3S
 SCrE0OTEw2/nZnWb9DWyWA32rhj1LKVsLb7Fl0C1hHj7T7/Fsgb8omTRkjE0SxZz
 1NjiFjJpwBWtvHAiEBK0SPzYx6R7tYt0pPJgoxKD0G56OzhSTTnNjOjRfnWwK2Vq
 rQGrztsBYXFuZO/jxzdaM61QeykJZySfI3z2cn5ix9lnVcoQumSer+hBZu91P2o5
 67oVSG4drqV4F/SYnBk1W0KdlqVuQ3S1CxJ9zs7WZg3Yz/EmrXgfyRCnC/zWXBms
 /gfockpIgPOKHJsRK7mQqK7h7lN2xPgJmag08Xokjb3kDQ==



On 7/15/22 2:00 PM, Jiangshan Yi wrote:
> From: Jiangshan Yi <yijiangshan@kylinos.cn>
> 
> Fix spelling typo in comment.
> 
> Reported-by: k2ci <kernel-bot@kylinos.cn>
> Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/quota_global.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 0b6f551a342a..dc9f76ab7e13 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -412,7 +412,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>  	goto out_err;
>  }
>  
> -/* Write information to global quota file. Expects exlusive lock on quota
> +/* Write information to global quota file. Expects exclusive lock on quota
>   * file inode and quota info */
>  static int __ocfs2_global_write_info(struct super_block *sb, int type)
>  {

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
