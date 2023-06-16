Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6BEEB64DA
	for <ocfs2-devel@archiver.kernel.org>; Fri, 16 Jun 2023 02:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y2GFn7yk8dGV7TJzxKo3A8+X2K6z/Uvhpj3B6HUWaJs=;
 b=UuNXaDgZ7cnmZatTIjLEXE9Ta0b66wZD3L2iMD8vGK2XDJluG9tRwg3zhvtgKqK1iFUCQvOn7oFP
   GLmSmZQRWTdUy4rqw7VV3xT4oRVRgyBHzRjIrLbCuFCO3TGTEXIeR6Hpdw5/h512hBBABYtLkEeq
   nlSirXmptNSShCr0nze89pf00XWO0aqE0IxjGFxlcHpQ7Cx5zHF76cbYgYQlyPsuEwG+2YKgNr+Y
   vMYpsYkTpYFrEDeb6/3mgWK8RdVB4vCknKbDmXdVsKVAB+4nMk6lW2VEnH3BFnyT9dQeoqhga2VA
   WX0IW8B/O0aEDK9WvBWwUkR3zt2y83ajDlwvLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y2GFn7yk8dGV7TJzxKo3A8+X2K6z/Uvhpj3B6HUWaJs=;
 b=S51IQkzbONyFlCFJfX4k4qlaJMgN4BcPViM5XAgB/szsPOEO+21LgVYLtHXXnlsCAC4vu61zWiQi
   hUfn7n54d59v04zZVS2JrgUUP1rjL78Nxm5Z+Fn6NFdS41Yqvl2X4Z7tFZAeMimAa2kuofKz2fvG
   q35IWOVWfi8VBkwPz2BEUd83z7gKrk5VY0z1JT0giPlshChzvQA1eSKiJIkgNiSZp1miwrKh2PjN
   rUyMRQB9UqBry4yHBh8RX+sEyqsdQAnWVtMHGkNNoK8wN+dRJnmqKMIE03bVbqxcH+FP+IVqNkwG
   dTR3KUhYd4hV1ifBk4gSB8bKAbr4du6Eg8SOeg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWB007NTQ3JMLE0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 16 Jun 2023 02:11:43 +0000 (GMT)
Message-id: <bb92b1f4-8433-de5c-0ce1-b23e693b8ad5@linux.alibaba.com>
Date: Fri, 16 Jun 2023 10:11:21 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Tuo Li <islituo@gmail.com>, mark@fasheh.com, jlbec@evilplan.org,
 akpm@linux-foundation.org
References: <CADm8TekHVfLHzKBLRfj7TwZiw=eL=VSgPpuhdpx_FSjNUXNtHQ@mail.gmail.com>
Content-language: en-US
In-reply-to:
 <CADm8TekHVfLHzKBLRfj7TwZiw=eL=VSgPpuhdpx_FSjNUXNtHQ@mail.gmail.com>
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10742
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 clxscore=-16
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160019 domainage_hfrom=8828
Cc: baijiaju1990@outlook.com, Linux Kernel <linux-kernel@vger.kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [BUG] ocfs2/dlm: possible data races in
 dlm_drop_lockres_ref_done() and dlm_get_lock_resource()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VlDwYUZ_1686881481;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: GClPgjqPuxWpBq6U3lNxesZGoR07-X2q
X-Proofpoint-GUID: GClPgjqPuxWpBq6U3lNxesZGoR07-X2q
Reporting-Meta:
 AAEUaXlFQL+6DsN/e0wyvFJa+tS/VOuclEkUQM14YAwgcKOIuOGbNqJzhND3sye1
 z/rIxw+DE+VVBDjwxlmM9tDDdWCmyo3snX4nEWxRRB/UbIK6+jJKm25hLPzRfVaQ
 dKgEHWN2QcVOg4oIXhWk38/CC4q18ChM7TQ9J6F5yDo30171I1f5yuj+Cixw9TSl
 nE2a+yJ720+zjfWfRj1gB7vkrloCtVQxsUdpnNjPJBo1DWDdXmm9FLMYykge+DU6
 YYjLYCeUhfCvc27MwAb+ywvJR2XQNXgMRTuPWyCsN790miL4pZKiuDlOZerAY7jn
 gjNd52Uek3ykoOAHPCrva6d2ZEiKZEWsik8zHB240LYG2zfc4y++AKlJFZYfhYEu
 +zOHnkwXeKgbRyt3Mdr/dYco0I8wex/8otyV1LXaSdj/oIg93B/e3pzVW5q8K+HF
 pLfn5OpXkhMtoA+DNE++QI0HOxnhgdGmvEFHmfTCF+GyEPZ0ZVNGKzVkdZHhn71q
 HpKnEsOeWC0zHpgYTdpRypzqpcaY1Ip6h4aqtTfCzh9B

Hi,

On 6/13/23 4:23 PM, Tuo Li wrote:
> Hello,
> 
> Our static analysis tool finds some possible data races in the OCFS2 file
> system in Linux 6.4.0-rc6.
> 
> In most calling contexts, the variables  such as res->lockname.name and
> res->owner are accessed with holding the lock res->spinlock. Here is an
> example:
> 
>   lockres_seq_start() --> Line 539 in dlmdebug.c
>     spin_lock(&res->spinlock); --> Line 574 in dlmdebug.c (Lock
> res->spinlock)
>     dump_lockres(res, ...); --> Line 575 in fs/ocfs2/dlm/dlmdebug.c
>       stringify_lockname(res->lockname.name, ...);  --> Line 493 in
> dlmdebug.c (Access res->lockname.name)
>       scnprintf(..., res->owner, ...);  -->Line 498 in dlmdebug.c (Access
> res->owner)
> 
> However, in the following calling contexts:
> 
>   dlm_deref_lockres_worker() --> Line 2439 in dlmmaster.c
>     dlm_drop_lockres_ref_done() --> Line 2459 in dlmmaster.c
>       lockname = res->lockname.name; --> Line 2416 in dlmmaster.c (Access
> res->lockname.name)

lockname won't changed during the lockres lifecycle.
So this won't cause any real problem since now it holds a reference.

> 
>   dlm_get_lock_resource() --> Line 701 in dlmmaster.c
>     if (res->owner != dlm->node_num) --> Line 1023 in dlmmaster.c (Access
> res->owner)

Do you mean in dlm_wait_for_lock_mastery()?
Even if owner changes suddenly, it will recheck, so I think it is also fine.

Thanks,
Joseph

> 
> The variables res->lockname.name and res->owner are accessed respectively
> without holding the lock res->spinlock, and thus data races can occur.
> 
> I am not quite sure whether these possible data races are real and how to
> fix
> them if they are real.
> 
> Any feedback would be appreciated, thanks!
> 
> Reported-by: BassCheck <bass@buaa.edu.cn> <bass@buaa.edu.cn>
> 
> Best wishes,
> Tuo Li
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
