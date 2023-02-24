Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3060C64ED6
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Feb 2023 02:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1vg9NxNuhk8A9KDbHO6W46pdYvstOhwxrHrPtQZgT18=;
 b=FBovvobnK+1edikmbUHHWytGX2jqg92p+ARh8EAP2UTbg1sibvrlyNYiGcpUCzTR0bsD/Q4Ak1fr
   w3qy2UtVPzUTKYmOZUT9ntY4qxpybfQePLHSSprkuU38xB8mLCHWHHODW5IEBTsOVks8H2OR/iLk
   oVZt0GFbCWgNq85DOuniPl9c/Yd+uQCG/F7x7duVtN6+aJK6zr9Do3V0hfn0cDlFgBWGx7VLbU+K
   PB2yHKriP49F+TPCQ67U5pNA2DvJDJlwzBmZ/ADWngoa9UdndkdrDuMCbUUyrX2Nel+rpjA3ecCk
   M/IonKiE8RiL5IeL+vk8aLt3HvqcHYSq6YH3mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1vg9NxNuhk8A9KDbHO6W46pdYvstOhwxrHrPtQZgT18=;
 b=OK4Xpu+jQix5UpNHlOD/CryaaPUKmUgPgwrI44hxwDH792L/bLndo7o9Fb+GG+YrcWJkYAh9QDdK
   FE2ZPYXQNy0IgKrVOwRQxKYB1Ab8oKblZ0htJZE9DKmbhs8AS8TbTDJ01btMZfh+A6xzvmgdIEcY
   /wZPZoXqdHicvmLzb+ZJzA7i9c6z+AbQYZ6WFf0Gpb1SOf5tG1BJfIblBa05VkADpshEhSaBPR6M
   m6+FvJEc/031kkhNm86et3QLroFdGcdMmFdIW9iR+fSfgL+0yOA48uC+0z7xxm9KLPxyZlr/wdp4
   GbE7osA0g4oaxqSqOCjPfnX3erE8+iHpDHZPQg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQK002VJBCU2I80@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Feb 2023 02:10:06 +0000 (GMT)
Message-id: <455fe625-9039-cc8b-f846-b3df85d9488c@linux.alibaba.com>
Date: Fri, 24 Feb 2023 10:09:35 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
References: <20230220050526.22020-1-heming.zhao@suse.com>
 <ed8df998-b9d8-bfc0-e590-c54ada78cef8@linux.alibaba.com>
 <20230223130715.8df852c1630b9103097489ec@linux-foundation.org>
In-reply-to: <20230223130715.8df852c1630b9103097489ec@linux-foundation.org>
X-Source-IP: 115.124.30.98
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=74
 adultscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=940
 priorityscore=0 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240014 domainage_hfrom=8716
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix non-auto defrag path not
	working issue
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VcM.X.6_1677204575;
X-ServerName: out30-98.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: I2CCN2L8U6JhbCCexWS0swKqBJYwGs8v
X-Proofpoint-ORIG-GUID: I2CCN2L8U6JhbCCexWS0swKqBJYwGs8v
Reporting-Meta:
 AAEUtT3C1JE2h3mBM9Hed9Ow+UF5WEzKRh2jjgCPjEGgSRjJWfe8uFqmcgiHU0dp
 ySYWlS5OpicLYpOSRhA+2aXBM1sjREMLR1JVc+T8SMd0SEca1zBjW2CPKY8ZH75M
 qA7jzd68mPboZknp0n6UBbGccdWI+Gfy6HqGRQm43bdgbQxwZy0PHMzpI6bDyOxi
 rtDwNIrwRoCVigqTgeQ8f0nEaEsQcdvPTel4UodeIVbTeRZ84G5LwjPZBKVn5Ric
 Sv12+lZzVFPxTrYzWDaCrVBa7x2SIWJP6hLxz4ozPDatYVUWp5KNcVCrqTXG9yzY
 xkD6XD9VGrizsNj1T5dbUn+OZki2TT6hs/eHO5kETHlE1IUPkS8OVyBDJHc8ukBv
 09u5CALYWszs4vDgpFif2OHRuyKUUoldSeWtkzKFOarxDItr3gkrM55qcDYKcn+x
 bjJtGopcyMc3DXSie7ZyOFLIJ9Xc3DhirTuTSJDMSeJ2ligRI2iMYDKEm8nT0Xye
 NN4K+6nw6Vjeqr3fbQcfQ19o9tjnSfuZNOCDXszdUBrc



On 2/24/23 5:07 AM, Andrew Morton wrote:
> On Mon, 20 Feb 2023 14:26:19 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>>> Currently there is no tools triggering the above issues since
>>> defragfs.ocfs2 enables auto defrag by default. Test with manually
>>> changing defragfs.ocfs2 to run non auto defrag path.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Thanks.  I added a cc:stable tag to both these patches so the
> fixes get backported into earlier kernels.

Thanks for your meticulousness.

Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
