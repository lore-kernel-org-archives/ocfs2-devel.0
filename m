Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2D6C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 25 Nov 2022 11:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lKRBjbM+LWhcXiy9pGsmASUy8QN7/Os32fBYaIgLfK0=;
 b=Puudgwy6Hb7AlsCCf/bxlDcO4tQOa0Is1N83R5obu8roeGuFlhLaKix3X7xWUeXeVfNkHNEe6yA9
   y6UfG3cOOGPK8JJfEyRCtl+WozIVRFhExTlsZONOWukYetqZXMiEQyPbclke0R/IfDqdvZkbCZUT
   2uEf32W5fWjVRoGcoP6vZewECQtvxN66solvu6R8TbnZNrz6Rnkai4pFVj5pBOXl7Q/zjUdALRnU
   SupdexpW4yf3kfa6niTfot+zqVUIxgU3dXbN9wtIaZf4JBGZg1ki7LYpkYXPHt2PFM5b9tT8bkNw
   g8h6YH7lcyCffCEbZKuKY4Vv8zWivLJLM51e3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lKRBjbM+LWhcXiy9pGsmASUy8QN7/Os32fBYaIgLfK0=;
 b=CCU8wIibm8/JFYi8GADOXEWMpmEkMp/BW9v081XgCySHd8V4/sFY63nF5jfn0q+wUbXBNDgUxHRe
   34DBapPKTXMGvVCudI6C/+szJvpdvaQWhQQt0WAj5G1v7L6kXw/2hpO4ROnXKPJe5sswEJc6FB5T
   B3HVk8kzOZzcr6x00f0c81tB6c9Wi/wPYbAO2IdsQg+fWqIIRrwf/7ZjpabTC4srgLqN8oTEFpdh
   wvqkqpla6UQlbYJ5ZalpBuqJ2ujjpz+uTX9j7DXphWuarZspetEF0zmkWcetsImijYZfGZRvnCKU
   EG3XnNZk2Rjvw3YJq1kiP4C71qtrk6QILMrTng==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLW00M2HIEIBS70@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 25 Nov 2022 11:25:30 +0000 (GMT)
Message-id: <a32840a6-8894-7898-c6c9-41feb869aad1@linux.alibaba.com>
Date: Fri, 25 Nov 2022 19:25:10 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: "Alexey Asemov (Alex/AT)" <alex@alex-at.net>, ocfs2-devel@oss.oracle.com
References: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
 <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
 <53bae0c2-7e20-4b16-9c7c-4fb9e617b9c1@alex-at.net>
 <92129377-7b2f-4853-c42f-a0f199a61f0f@linux.alibaba.com>
In-reply-to: <92129377-7b2f-4853-c42f-a0f199a61f0f@linux.alibaba.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 clxscore=84 malwarescore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 priorityscore=104 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250089 domainage_hfrom=8625
Subject: Re: [Ocfs2-devel] dinode link count inconsistency in
 ocfs2_read_links_count() logic
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VVfB1ob_1669375510;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: arVSD1LKCylv991XrePNXzLHJ4qi3LmO
X-Proofpoint-GUID: arVSD1LKCylv991XrePNXzLHJ4qi3LmO
Reporting-Meta:
 AAE1WvayiAG05vAkmUgKGaKjAIRbyQQyEAjVPr6apxPhI44MLj+oG3CiqkjuwPmc
 qmcqhN6BG7hh/LsLyCVMAuRt0IpUHaFQRfLP27FfvbvoUIwv0EzachPqOd7qBUam
 eztdel7R5Z0DyklV730ygfan3A8241O2fJJ+maYOAsx6yvj8qI9K5rmUxwt5uwBK
 lFx/c08KGwV+2SAF/ayhYu1+/EEKHLyUZ1KuRHcy0naLDoWnK+pkU3+ZZMHEQu6V
 VvIdFDxSEgKnpxdArKacF0xZZ60/ihGgyok3GhuorODThQzQcgxzxjMvyzTrPUr7
 wJC+RQoXu2qcoYKQYiuREsGAyEkgiNK3gnbQSzbkZosC2Y6e5nZJA4+qQy01aSGU
 YcPwPSBd1jXdTLKeRHAKVtzXmKRdnPD2oLkMk2QPlhTKl/9yU/urreySGPNTmtpm
 zgwcTj1EhrqX1jtnJ8ZnIUBHxRqDqgAhlg49m0Qhi68PhTIucoNB80dQY1Gz/qVn
 X29rComTvSXhxgNj5rS2pQxlqYg7VCTasviuwpv73kk=

Hi,

Checked the code again, since feature indexed dirs is now default on, so
the ocfs2_link_max() check will return OCFS2_DX_LINK_MAX, which can use
high 16 bits of links count.

Could you please send a formal patch?

Thanks,
Joseph

On 11/22/22 9:52 AM, Joseph Qi via Ocfs2-devel wrote:
> 
> 
> On 11/22/22 12:15 AM, Alexey Asemov (Alex/AT) via Ocfs2-devel wrote:
>> The modification I mentioned surely fixes the thing (well, obviously).
>>
>> If to reproduce, trivial as well:
>>
>> - mkfs with indexed-dirs option (otherwise low hardlink limit will apply)
>> - Create a file
>> - Create 65535 hardlinks to it, stat will now show 65536 hardlinks (that comes from local inode cache)
>> - Clear inode cache (for me cat 3 > /proc/sys/vm/drop_caches is enough) or reboot
>> - stat again and you will see hardlink count = 0 that is the result of actual inconsistency
>>
> 
> Will take a deep look into it.
> 
> Thanks,
> Joseph
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
