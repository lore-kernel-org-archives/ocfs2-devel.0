Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABC2C19F2D
	for <ocfs2-devel@archiver.kernel.org>; Wed, 10 Aug 2022 01:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rV91eCOWPQnxz6XsNNpDjcP/0wnRmK2RZx2N7Zp2W60=;
 b=hPHfVUmKwLDsxsxXcChxtgx/Fzde0Spf7Kk8tQSMdbU1mkuVbPS6v/dhge80r4Yl+1Cir9AOzrbH
   USCYjJbtEzlf2ABp0haTYKjTJSkbfCMiCGK/lR1PMyJ+W5it5nSAELEX3f0UXrcHecwouBjcB3i8
   m/pQcJb08cYEvy4P6SVB93OwdEF0NZuwaNwQ4g/z8nNmSxcQ8L463PfiAUu3wZZ0OAut1kxfy4ev
   9BvYpVWFgAegWByFN4Kgtx2tpWLH3vZ1TD6sAx3rac8L2B+2XKcj9nPF/P/y/l4iBEO9egx26DGA
   3em9krOMlV8HGWamKpWHJNcy7UhKjrHbLhk0dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rV91eCOWPQnxz6XsNNpDjcP/0wnRmK2RZx2N7Zp2W60=;
 b=Rcey5xeBuxC9sSj4imu+Xi6Ur0kVmVxnuDeIMbNiruWXTxDxrD+Q8x5rNu10jqKgswYX6lPD9bXg
   tZtrNySxTAMqa/pRBr7NGwOAlM69cEWfsHUOe/t3JIakXX28Qor87dYOFjKbxpe2/AKGcVCuPp4b
   aUrAX/1foqLFTW89mBMqHL/duib7uKGkmWEnxwC4aEYJForufxQZrfaJM+sCBy6K360/KLJvOYSR
   XD713oGp1KDMzj3A+ktX7b1nQ9xP7uqsIEuAjvl3tEpSxK6N1BVQ9+iCfbKFegrcuoTvQ1HDHcHA
   ncNiLcXC03UOJh0Y3VXdvwnYyV6yZ84F75xQVQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGD00OO6LKZPX40@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 10 Aug 2022 01:31:47 +0000 (GMT)
Message-id: <d6f09279-38bd-e9ed-51a6-badf9fb7d366@linux.alibaba.com>
Date: Wed, 10 Aug 2022 09:31:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-2-heming.zhao@suse.com>
 <2dd9c00b-bd33-7368-def9-9572dd7e6820@linux.alibaba.com>
 <20220808120852.6tuj3f3ivsuup2pd@c73>
In-reply-to: <20220808120852.6tuj3f3ivsuup2pd@c73>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10434
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0 clxscore=-34
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100003 domainage_hfrom=8518
Cc: ocfs2-devel@oss.oracle.com
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R961e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VLsfgji_1660095085;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Q9999P-7rCM0GUt75vMiwHrGhNxUBP_2
X-Proofpoint-GUID: Q9999P-7rCM0GUt75vMiwHrGhNxUBP_2
Reporting-Meta:
 AAEC1Y3XDGyROmAza7CdA/74YaFJocHebdBy0ykgksGPEKiSs7aM2uLC7BvOBCqB
 wXXwd5YAqc0hEMOlI8MSIQTy9N6dqtArhduBMW8bVagpXbkXm+4Hh5Yl/B8ogBx1
 2nly+nStrDWsMIaA+B7X4eb3sRdbrRrBvukjiP5mQlp7NmZK/kSNpUO3hV6SIz9g
 tMWEeW9kiwRAaPD/NcSbgzO9jiPWTUDZDp0ABnmZWn9uBmKhcaw1aw+eDlpqNJjI
 UqgqmlEYxBaALrKoiMZUd8knwH8CqRjuMDhMqiNGf2uqxasxVhBYEDfmwNhPg5Uv
 iwCBYEmFAsVA9zLpQsOVxhURxSBWkdrzXHRXLmMZGc5WNAgQ7UnpeSca3mEGf/nw
 EwpE6QP/ReGDLGFN0zqo9Y3hce4uUdjvW02+1YHUZ5kzKNJABzXxYnk0+NSjjPz/
 dDBtkLxh+oSYRa0mTyTs5OYiMm2P+nPUZ3bd6ZI/56/Yt513Oig6JfgRbVJDEp8i
 Fdaz6ocaKxNmI4U+ZT5JtQQU0PFLr5KbFBlr9IQjg/01cA==



On 8/8/22 8:09 PM, Heming Zhao wrote:
> On Mon, Aug 08, 2022 at 02:51:12PM +0800, Joseph Qi wrote:
>>
>>
>> On 7/30/22 9:14 AM, Heming Zhao wrote:
>>> On local mount mode, there is no dlm resource initalized. If
>>> ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
>>> flow will call ocfs2_dlm_shutdown(), then does dlm resource
>>> cleanup job, which will trigger kernel crash.
>>>
>>> Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before
>>> return error")
>>
>> Should be put at the same line.
> OK
> 
>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>  fs/ocfs2/dlmglue.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>> index 801e60bab955..1438ac14940b 100644
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -3385,6 +3385,9 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>>>  void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>>>  			int hangup_pending)
>>>  {
>>> +	if (ocfs2_mount_local(osb))
>>> +		return;
>>> +
>>
>> IMO, we have to do part of ocfs2_dlm_shutdown() jobs such as
>> ocfs2_lock_res_free(), which will remove lockres from d_lockres_tracking
>> added by ocfs2_xxx_lock_res_init().
>>
> 
> ocfs2_dlm_shutdown does the cleanup job for ocfs2_dlm_init.
> This patch fixed crash in local mount error flow.
> In local mount mode, ocfs2_dlm_init does nothing, which should make
> ocfs2_dlm_shutdown do nothing.
> 
Not exactly, even in local mount we have to initialize lockres like
super lock.


> And I checked all calling ocfs2_dlm_shutdown cases:
> 1. mount flow:
> 
>    ocfs2_fill_super
>     + xxx =fails=> label:out_super (checked, work fine)
>     |
>     + ocfs2_mount_volume =fails=> label:out_debugfs (checked, work fine)
>     |  |
>     |  + xxx =fails=> cleanup everything before returning
>     |
>     + xxx =fails=> label:out_dismout
>          At this time, dlm has been init successfully, we can call all lines
>          of ocfs2_dlm_shutdown.
>     
>    
> 2. ocfs2_dismount_volume => 'osb->cconn' is true.
>    this MUST be dlm successfully init case. everything looks fine.
> 
> In previous mail/patch: [PATCH] test error handling during mount stage, I may
> forget to test local mount mode. So this crash didn't be triggered.
> 
>> Before commit 0737e01de9c4, it seems this issue also exists since
>> osb->cconn is already set under local mount mode. 
> 
> Yes. The bug exists since local mount feature was introduced, commit number:
> c271c5c22b0a7ca45fda15f1f4d258bca36a5b94.  I will change 'Fixes' on next version.
> 
This patch can be a separate fix and we don't have to bind with
nocluster mount feature, even though you've triggered it by related
local mount.

Thanks,
Joseph

> (Hope 'CC' list takes effect for this mail. -_-# )
> 
> Thanks,
> Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
