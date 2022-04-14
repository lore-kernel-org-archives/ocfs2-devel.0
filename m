Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D4B7C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Apr 2022 03:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u6phcglXc2rjiEiLgEgwhXjof1zSi5Sd1Q/aKq6h0u8=;
 b=ecPOF6HTBCVlYCNwPpOsrnjYVBKmL2sbys26biXuvDoWAdkc+8rFUfDITtmv0ALnpf2wtUXMWbMl
   cdACdKba21QdgQF62rRK7Et3/eP7X3NBo8bv7FM499g6jWMQp8grSpKgSuix3pe4LxG2IRPjWsrd
   23vaY3ygIul8Ai0eqR96u1st9qPiAUdE8dGiCMUBRDb6p2T+/yzPyOlTbsePcOtlUQdJyinljfp8
   8R+F78Kjfuiab/wCoqKf3RL83hg58NI/ROAatdhOOHHbnqUQltRf7SBjtOTcc0YSxg5CkjrTR23C
   mqWasPUu3s8NrK+RkluCluK5JZFQi19y7PAL2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u6phcglXc2rjiEiLgEgwhXjof1zSi5Sd1Q/aKq6h0u8=;
 b=phEIER/Z//YNJN28ClkZZIUaIok1w4ycy78BvFvSbuLXBuUm7EpJnvVYA8ENZjXxOTEerRFwjzOg
   Kbh0kQgx26yjEua/aly17odddYSBWblVO/viJOHwl02Rc9FlSUWLywgrtlHw+eCoiXRSEPHc4hzR
   16NCD2qsCtx25B0WalgfAvWKeLAYkCGrQ4GFvGo6BzYLjMFikKk61Vm/Wc/fuVo2OZjpSsoZ4uXD
   XHkV2q0hOLzKEctnontoV8LKuYZ9G1JkT15Ihgiik1BjwHv6m/w1P+t0qlFSu4OVoEcBullFOvjg
   l7oWhxPOwdR8tmacXJqXatJZlBky7gX8/FOHgw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAB00AUY9A4NF50@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Apr 2022 03:49:16 +0000 (GMT)
Message-id: <72ee0290-4140-f3d1-170f-3b5b883133f7@linux.alibaba.com>
Date: Thu, 14 Apr 2022 09:47:42 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-6-heming.zhao@suse.com>
 <dcceb610-3c1b-d46c-493b-c836317e6d4b@linux.alibaba.com>
 <20220413131105.7k7xpmlzemwgw44x@c73>
In-reply-to: <20220413131105.7k7xpmlzemwgw44x@c73>
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10316
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 mlxlogscore=924 spamscore=0 adultscore=0 clxscore=120 mlxscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=30 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140008 domainage_hfrom=8400
Subject: Re: [Ocfs2-devel] [PATCH v2 5/5] ocfs2: rewrite error handling of
	ocfs2_fill_super
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R491e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VA.rVFg_1649900863;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xWa7AZWkRatUEe5sjcOzWG6sYwiicF5E
X-Proofpoint-GUID: xWa7AZWkRatUEe5sjcOzWG6sYwiicF5E
Reporting-Meta:
 AAHPGGz+01nJTI6qYyqdwZaIGtGoEyabD8U+KnTrlBT1F1WbkLy6+2tG97ByEjnC
 6yMXCfxFzZIB0LBnryUKlYJT4vmhUHNRknLssnwMMugdJfR8I21YZifgys4LeAoI
 IkUZ6Weh6wlpgt7Rg5zckuqcHaNp7I4xvi0L+4lgJMajH2GKhnDveVAMiEaLmGQ8
 gce2RF/T6sSTY+81+OjNwgrE/ZRSUymKHdaHzMC2Io1XtztxwGkCnQX4daxJCvGY
 i2qLJE7Cq1Hkm2z7La9dMxGWTIMUANATCuj80Luz6u4uE0JahladDcMSX1VQTiqK
 hademkuecJIW5sDy4wPOb9NUKZEuIBqiTEY0kVqQP/dYXYQoq9CJMqqpEDzKhU5r
 RMYd2T65frHbdonU457UybFH2kr8XNSrV6vwe71oaldQr+30LsIYUTHpGFkuc275
 RhQHLVK0xizMGlSaqkNVYMkd6qK2B0rZxqCYRv5bToQWEYGQHY0mR6MnLuM6KQHu
 3DGQJjxyjp4WXE0V6URIPllzXO2Y6ZaQrQMRHCsZyujh9Q==



On 4/13/22 9:11 PM, Heming Zhao wrote:
> On Wed, Apr 13, 2022 at 07:37:59PM +0800, Joseph Qi wrote:
>> It mostly looks good to me.
>> Have you done error injection test after this patchset applied?
>> I'm afraid ocfs2-test can't cover this as of now.
>>
> 
> I plan to write a debugfs api for error injection test.
> The code only for these patches test
> 
> My idea:
> echo N > /sys/kernel/debug/ocfs2/xxx/error
> N: 1,2,3,4,...
> 
> "echo N" will make ocfs2 trigger Nth error point become true:
> 
> ```
>  	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
>  	brelse(bh);
>  	bh = NULL;
> -	if (status < 0)
> +	if (error_inject(n)) //eg. "echo 1 > xx" will trigger there "if()" becomes true.
>  		goto out;
> ```
> 
> What's your opinion about my idea?
> Or do you have other method to test?

Good idea, actually we did it in this way before since existing
fault-injection can only inject common failures such as slab allocation.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
