Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6856AC433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Mar 2022 02:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4gLMSet23rLOc0A62CBZ+G692fLfqLltaA46cFT6Ptw=;
 b=s9Gy3iXsvwsHm7onEkgKf9xWZSCcC8oAj5nJExirehbNNWMjGYTb9ST02fYWtvY1CnxR11+icL4y
   IInq/aMVNCHFPDmDv0Gw7eQfNQs7ZbrRRnwefyukJvPDrYXSec2ZkEgFMMLTYNHCQ5xCEixZWfrx
   Vks8D9kWccoxTsBrHjyfR4x4/du7+wqHq/5JeBvsmA3FvWUTkBjEhHCXTrk+emILXAB/U/JUSzK6
   Kvf33gYHiscHvXGzo/bi4sU/ayEIWljJ2tx3w/64BsazxAFQoWbiTxARfu0/j/dH4i/y5aeQJs/m
   fn4zeK9+BBAGwAkTJhY9HR42vC5vVgCscEv+hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4gLMSet23rLOc0A62CBZ+G692fLfqLltaA46cFT6Ptw=;
 b=WQGJi+K+rzxkr1pRxBDh20BwDmIPLaCijqDEBrVghInFdEHl+9s6HY8vxR0XU2Lv6x1W0e0Dw8XE
   9PoPxtoTD7z7Jsa84AHneg9uSEdB+crr91bTbZbQ6LzJl45Smd2indAz/NtkELSHDkUQOt36FpzP
   rPAG0agx7fKSQuzgI97VmAyQfZzm3rTQeuOrR/DmhPFYxTeOC6AiFh+DgtUSleutBKlkERw41QsL
   5xhLX/dar7nZPd5YvMa/B/14ugb4egtCE1Oqdr/OJkUJXZChROylnBgA+Zwir6Z5XqFnVm1UFqmH
   aSynGH+PD1e5p0UZrXJD4GxVh9KPPccBcugBgQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9400IL2JMIC480@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Mar 2022 02:15:54 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <5aefc78f-9a75-9b44-9471-87f42011b7c2@linux.alibaba.com>
Date: Tue, 22 Mar 2022 10:15:34 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Jakob Koschel <jakobkoschel@gmail.com>
References: <20220319203106.2541700-1-jakobkoschel@gmail.com>
 <abcbf5d2-c348-7dc0-cfd3-9bcc6431bc64@linux.alibaba.com>
 <A7AA04AA-6B4C-4211-99A6-0D3C04ED7B26@gmail.com>
In-reply-to: <A7AA04AA-6B4C-4211-99A6-0D3C04ED7B26@gmail.com>
X-Source-IP: 47.90.199.18
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=0 adultscore=0
 malwarescore=0 clxscore=223 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220010 domainage_hfrom=8377
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>,
 Masahiro Yamada <masahiroy@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix check if list iterator did	find
 an element
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=14; SR=0;
 TI=SMTPD_---0V7tYAbz_1647915334;
X-ServerName: out199-18.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: Lj96_-LUMHJQQivsE5MRxgPO4t4HKizr
X-Proofpoint-ORIG-GUID: Lj96_-LUMHJQQivsE5MRxgPO4t4HKizr
Reporting-Meta:
 AAGuUfGu+BQxYvXymcu+FzRxJ6vQRtI4i56UBHKnKbSJ1Ygmgnewpms9gv1YBLsY
 NgCyDkLizv64hTs7wiaA9p47HYInT2dPy45P0jkpi6iZP7k0VpwKFNvog8gdK/1H
 p5A5BPp7wLDWAQ8AKgp3WH+OAWZkg14acqfZToF1DJIlOMkM84h5DrociH8g2K6n
 zAuRezk0bFobQ+gXTOf0f4gQ2GK9diNnamNW4ufm3Dhu6l5SHjAfd25hRkasmFGd
 ZQfJXs+qFFpDlfT0NOM1hRSTc3DO+ld8iwVR+fqn7X9ZB/rL0oR+FTMO1wWFPmly
 fk81nezzBleLibroPfjLcQJmVK91A1awO19+t0LhzLFlsCXltENu5krd95Z0zkpk
 bucyjFoOB/4eIVKIepuNAJZ82WYpBTyS2K8TC4g+gP6Lenz7BtiHKt8mVy2s0O/a
 d1RHg+suvngzkYmLHbx6iIIjI/8Ry0JAgHUhu5zgil/fGPXAJJUr/asWfLuF91yO
 5CA6TowO3U6GZW6WBMwyy5zhlHydD0cSYtE6KOGPAsE=



On 3/21/22 9:34 PM, Jakob Koschel wrote:
> 
>> On 21. Mar 2022, at 02:50, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>>
>>
>> On 3/20/22 4:31 AM, Jakob Koschel wrote:
>>> Instead of setting 'res' to NULL, it should only be set if
>>> the suitable element was found.
>>>
>>> In the original code 'res' would have been set to an incorrect pointer
>>> if the list is empty.
>>>
>> The logic before iteration can make sure track_list won't be empty.
>> Please refer the discussion via:
>> https://lore.kernel.org/ocfs2-devel/bd0ec87e-b490-83dc-2363-5e5342c59fa4@linux.alibaba.com/T/#m96d4397930201d83d68677c33a9721ae8dbd8f15
> 
> ah yes, I just read up on the discussion there, sorry for having duplicated it
> here.
> 
> Was any conclusion reached there which fixes can/should be merged?
> 
> This code obviously can always be safe if the list cannot be empty.
> That's also not necessarily the reason I'm fixing this. The reason is that
> we want to get rid of any use of the list iterator variable after the loop
> ('res' in this case). This will allow moving the list iterator variable
> into the scope of the list iterator macro to forbid any invalid use of it
> at compile time. Like this you don't have to rely on assumptions that are
> hard to validate (e.g. that a certain list is never empty).
> 
> The patch here is the minimal change to simply do that but looking at
> Dan Carpenter patch there might be more things in this code that can
> be simplified.
> 
Agree, so I'm fine with this change.
So could you please update the description and send v2?

Thanks,
Joseph

> [CC'd Dan Carpenter]
> 
> See [1] for changes that have already been merged:
> 
> [1] https://lore.kernel.org/linux-kernel/20220308171818.384491-3-jakobkoschel@gmail.com/
> 
>>
>> Thanks,
>> Joseph
>>
>>> In preparation to limit the scope of the list iterator to the list
>>> traversal loop, use a dedicated pointer pointing to the found element [1].
>>>
>>> Link: https://lore.kernel.org/all/YhdfEIwI4EdtHdym@kroah.com/
>>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>>> ---
>>> fs/ocfs2/dlm/dlmdebug.c | 12 ++++++------
>>> 1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
>>> index d442cf5dda8a..be5e9ed7da8d 100644
>>> --- a/fs/ocfs2/dlm/dlmdebug.c
>>> +++ b/fs/ocfs2/dlm/dlmdebug.c
>>> @@ -541,7 +541,7 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>>> 	struct debug_lockres *dl = m->private;
>>> 	struct dlm_ctxt *dlm = dl->dl_ctxt;
>>> 	struct dlm_lock_resource *oldres = dl->dl_res;
>>> -	struct dlm_lock_resource *res = NULL;
>>> +	struct dlm_lock_resource *res = NULL, *iter;
>>> 	struct list_head *track_list;
>>>
>>> 	spin_lock(&dlm->track_lock);
>>> @@ -556,11 +556,11 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>>> 		}
>>> 	}
>>>
>>> -	list_for_each_entry(res, track_list, tracking) {
>>> -		if (&res->tracking == &dlm->tracking_list)
>>> -			res = NULL;
>>> -		else
>>> -			dlm_lockres_get(res);
>>> +	list_for_each_entry(iter, track_list, tracking) {
>>> +		if (&iter->tracking != &dlm->tracking_list) {
>>> +			dlm_lockres_get(iter);
>>> +			res = iter;
>>> +		}
>>> 		break;
>>> 	}
>>> 	spin_unlock(&dlm->track_lock);
>>>
>>> base-commit: 34e047aa16c0123bbae8e2f6df33e5ecc1f56601
>>> --
>>> 2.25.1
> 
> 	Jakob

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
