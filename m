Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EE7C677F1
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Feb 2023 06:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9wf6ErI+NTC97EoB/DS8W+FM7FuL7ThqB3A9v1ca4Cw=;
 b=gcCwOV/HDZhSy29JWE9JX3+zjBl1/r8sHPXfEkzpBMd/hDjsNuxomDHNTHuWQXebW8YrlWBVUlI7
   jxJ6SEDuiezToQCjo9xgXnJDP0jW941a4MlLMwdlnN0kNPuEJ4awvH90bleIwBczq3BiFSRn9WX6
   RtQmRUg6f7c4gufUx4r+efevNGygX+fVdxa2pJb31ZLfIgIgheS5KYmeSvgCvrHusNU/+oIG2amM
   xxH5Y/wBD0I1uPSeJ3+1cs/hp/Hqn+O22IO7zU6xm7qnO9TPYMkg/U/kjV36+9U/E5Dn49YIYLlk
   4FJIlL2u2HVgQJEcSzDUfqYw/tiUMD4XoqQ4Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9wf6ErI+NTC97EoB/DS8W+FM7FuL7ThqB3A9v1ca4Cw=;
 b=Rt4pHQZtkcDIdPWj/dPAbYlswUYC+vOAU0/iDhTus77lWEh+9PNNiOdP38FucxuDbtZakds9istk
   +TavH82U7se2wov99c2M7+fqPQIOq1lYPfnphasSI5Jb8I4fRXTYyFdX7bM0WyaWvBjEDEPLUkZn
   C1X7hP2XSBxcjF06aNTD83NJVtYGDw5eUB1zt9zJCWNA2DCeTQdGhaO0F+doYrBl/OjZhDC1kTGR
   +xvn/2Cavc4afVIAZ9ny+KgItbvHlURJKPHEvYDGrwHbJhdbb4wJFOBPJZ30lTBMpWQVULO+aOL6
   uj3F7risRAFdKgUvhQQLIa8a5Bk2c8arLuhX7A==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQK005WOOK6OR80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Feb 2023 06:55:18 +0000 (GMT)
Message-id: <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
Date: Fri, 24 Feb 2023 14:54:48 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
In-reply-to: <20230224003251.otqzmap2f64o3fpf@c73>
X-Source-IP: 115.124.30.98
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=120 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 clxscore=97 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240057 domainage_hfrom=8716
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045192;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VcN4jba_1677221688;
X-ServerName: out30-98.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: VhoI2cQMVBcZwBKmSlPRxlTkjxTfkDCs
X-Proofpoint-ORIG-GUID: VhoI2cQMVBcZwBKmSlPRxlTkjxTfkDCs
Reporting-Meta:
 AAHvX+DMSwoeEG6Yy1ZqhHMUWMETTWgreoef09qYGkFYhrXP9/4kwYueX/8Hdggr
 Tk4avi8VP8An32nNZfcWw567Ct1TYfOWqaZyjQgw6/DkZ9vRBioFdLrsUyETNvtj
 OHGe2gTdZUT97nEoslI3OJ+BvAWoOm7W98O6uHy6OuV9FeqEC+unb5NiWEqcrtvX
 JvownYyOKQFzKv6gli9323yWcKB6aYdOv/ZXB7frd4/c01dHg6G5X2a/EWQlf3KB
 08GtPVNTPbhrQ3BlH1FOUVsQFdjBDvU0zjElDEuuwTk9qoafQhiy6B+G7sSKUmlI
 OrjYbh8puHc5wPCFQNAWNqY0NBobWPAFYp73OJrXYmzbgMhCmZ+PdesfkJ1z2fiW
 xmKpUOGbL/KOcFr2G2H4RwLHTi0VMq7OcS0Aqilov0DXBjunKFGb+Xgb7hFvaLSG
 hysDf6yqVvYiHKvl8zRMhNjH/msTX3X8Kle+i5Xmqu9w31NCQurhN7537FJk3jmo
 jT27Q6UOORPig9WOInWH/TQU5XwI7fEyRIqNZglbt6c=

I can reproduce this in my local VM.
I've traced ocfs2_dismount_volume and found that it hasn't been called.
So EBUSY is returned in VFS layer. I guess something wrong when doing
a copy with linked SQEs (normal copy seems no problem).

Thanks,
Joseph

On 2/24/23 8:32 AM, Heming Zhao wrote:
> Hello List,
> 
> I found a weird bug on ocfs2. I am busying with other jobs, if anyone have time
> he/she could fix it. This bug is blocking fstest generic/013 test case, and also
> blocking fstest to do later test cases.
> 
> How to trigger:
> ```
> git clone git://git.kernel.dk/liburing.git
> cd liburing
> make
> cd examples
> mount -t ocfs2 /dev/sda /mnt
> cp /etc/hosts /mnt/a
> ./link-cp /mnt/a /mnt/b
> umount /mnt
> ```
> 
> umount trigger error message:
> ```
> # umount /mnt 
> umount: /mnt: target is busy.
> ```
> 
> The umount error can only be triggered by liburing write operation.
> 
> Thanks,
> Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
