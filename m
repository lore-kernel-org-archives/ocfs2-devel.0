Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 466B2C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Dec 2021 06:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lt685rLth3Bw+HHdkrBSpV691ppU6GpZFB+mSaO9pQ0=;
 b=r76Khev9ivmDa8W1OwG5Fi5t+d3frEOxYZc33kr3U5u/6PfUzQae5T2MFVE82xLubSGOw83NxIGs
   gZdBOmaYnIIKjonKBbZ6AYK3FmbfRFzP7SZoOK+fQ0gQrVDX9h5fGl1PMnEoc1+RVOdxMSZm5gLC
   QvGA8SG7qDJBawbZknyggaIfEpheib8v/jn6lB3TWqz4eHtwo5lzzZVBYrKT5/PQ84DH516NPDKo
   svdBvQltbx56H0+iJ6e6xcktOF1XaexUUJtzFYNG7N0svKUnlMKMuxcPphi1qEYTsBWu9kJuquL3
   snXu4pJ+Z/JbBuV3hxqsgp6Iqovpm+7U5G6oVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lt685rLth3Bw+HHdkrBSpV691ppU6GpZFB+mSaO9pQ0=;
 b=Cegk8pTg4Puw3/f7bStB/NtZEMFVxL5nmoW6acusD0IXr4+j/v5hux52vBHhM+49NFQx4SDl3lD5
   fodHBjhw7LAWRiyLsDO8tVMAe+DFM9zRgX6xP5D+0Ki4OgYseHR2QTspq+oXconDQObRojCE03pW
   900TbkI7KEJQhZAs+dRNK/IbZrO3JEiweUbYuva97kRLbeFrw2FZp3FZdAvM+Tdizh16VcUzRQIH
   fXr+bZC9fUuRmlRGpfII/ocerMrB/eAB9PhMuO6tNdQyD5vknoOiuWupnfstPnly0XmDl3184az7
   KGRyfgqslORShs3fYeAsRSAA0DoDhUw0zyKfkg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211123 64bit (built Nov 23
 2021))
 with ESMTP id <0R3O00L05JI6D6B0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Dec 2021 06:03:42 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <1e9cb07e-aef7-1461-25c4-1e9cfbe41c12@linux.alibaba.com>
Date: Mon, 6 Dec 2021 14:03:13 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Wengang Wang <wen.gang.wang@oracle.com>, ryan.ding@oracle.com,
 Junxiao Bi <junxiao.bi@oracle.com>
References: <20211130104043.GB5827@kili>
 <92d4d393-9734-9f7e-4440-20429bdac14f@linux.alibaba.com>
In-reply-to: <92d4d393-9734-9f7e-4440-20429bdac14f@linux.alibaba.com>
X-Source-IP: 47.88.44.36
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10189
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=70 adultscore=0 phishscore=0 bulkscore=0 clxscore=213
 mlxlogscore=648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060037 domainage_hfrom=8271
Cc: Sunil Mushran <sunil.mushran@oracle.com>, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix uninitialized variable in
 ocfs2_dio_wr_get_block()
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
 TI=SMTPD_---0UzX-aeR_1638770593;
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ygZ7N8a2GI-j8ZF61jZrrR-QIPU4z15c
X-Proofpoint-GUID: ygZ7N8a2GI-j8ZF61jZrrR-QIPU4z15c
Reporting-Meta:
 AAHbibWq28nfr2Zo8sZYIK0U31S4mpEILkguuQit1LvnAoTscrlcySCgQzDrFtUi
 MC3tYKuIJ2eJtqeitVhN6Q4m6SLzSS8ndn7HqmaGe5mMtM22OJtawC/vADZOcKn5
 uBjWMD+pve1LZQAmj8w9eo/anpGD8kEOHACTYvtsbReuV0Lnbf1P0v3hxtX3toHO
 HGKuAZsOycwPydsrcaCxDKwP5HSr4aTSXOGYxZS5nVGLVgrHjJDyYE/lLxS7QXZr
 AxgUjEJ8f1vMa9nSTlWLUuKqAnZ1rtx/GR4Yf16hxRQOdZIjJWlPtsk8yluSzMKJ
 T7q1BhZFrAVKVLQt+Ly97GYskHvEV2ZwSr5RyY1yM+R6Es3j3YFVVeskCeaipOpH
 +XCWb7zeJArV87redX1MSr87TZCFx1wht1Q8x1bRPjsOGhD5Kv514jyE5wnFrRwM
 eYB/IffCy5a/i2rFKqcllFVP3IfVcymh/ZZXFKkkBApgOREmataaoVOnUCfw25Hs
 N2L+lSkYirUBdRWki6+rK3IKw/FgWWqx9h4Lgqx10EQ=



On 12/1/21 10:24 AM, Joseph Qi wrote:
> 
> 
> On 11/30/21 6:40 PM, Dan Carpenter wrote:
>> The callers assume that "*fsdata" is set on the success path, but
>> that's not necessarily true on this path.
>>
> 
> In ocfs2_page_mkwrite(), since in this case no target page locked, it
> will finally return VM_FAULT_NOPAGE (better VM_FAULT_RETRY?) and throw 
> to handle_mm_fault(). So no problem as comments described.
> 
> But things seems changed since append direct io path started to use
> write_[begin/end]. In this path, the target page is expected as NULL.
> This needs more discussion.
> 

ocfs2_grab_pages_for_write() returns EAGAIN only in case of mmap. So
current code won't have any issue.
I'll send a cleanup to make the code more clearly.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
