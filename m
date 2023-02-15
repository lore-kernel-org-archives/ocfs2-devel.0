Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C932C05027
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Feb 2023 02:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YNEs5pgKjmqpwZW6NnT64H0Z0DuzBDnVhqftiQlnSrs=;
 b=kS4L271y1s9Iv4MWhqT2xdluk4nk6e2mXICifRuLT6ygKC2ecSlcKTlnmGHYmOpnF8Q9bRUEZzk/
   keIl2V94zB//Pq/6Jr3TiHSczoGQoy7njVbP7CB1JXDXcPM6R4QUcGXytNbnShFz55p2vwwyFpbb
   6D4HNtQAAslXWc4GPgps5tXi5UL4lC96v4MhXA0KySkR3hk5MOfQaBqF61m38dhh0acu7u11leZU
   FQKJqzlDsS7h/N40oPU+Iej4k7f2u7nIxGhbVoDZ6eWy6ghVihUVDVZlfuuIurBqP0QBBo333knS
   K0utQ07PecmeYAVVytPqZIx/e+rxc6leh6HU5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YNEs5pgKjmqpwZW6NnT64H0Z0DuzBDnVhqftiQlnSrs=;
 b=LH+JPrt3vGpbH3yO7taAESH6Z2YS2boSB+V+G37tIHE7pDKSc28uVSrIg84OzqQlxVZ3RNldQAWx
   2pI6AU3nYovB621sZAC3pDWknJqhIrCw7wMH4l1k0rg7sEIvl8Hiy8zGazcwWJZ4nViuqETyAKZM
   UuvymsqpkmyFfn2H7UzPP8fLiCzkYLZmkhdPsb15kv+c/CuBrKmtFleDmLM5P9G6Dy3DtSs4hxbO
   LVvqnRd3QwqaNi7NpqgSRQ2I8R6jVyc+ybZpSInj6rEIl94BJa937e0ZHt/V6Qg1OBaNc54V22tW
   jG6YR6KQzUQHJy8kJhCyYD8oGinNG1kW9jlRFA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ300JF6N6W5Z50@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Feb 2023 02:06:32 +0000 (GMT)
Message-id: <6e2a7c7f-1318-b611-094c-71008d03be20@linux.alibaba.com>
Date: Wed, 15 Feb 2023 10:06:11 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20230210100457.xv5wchadnd7kkazb@c73>
 <9ceabc71-5b18-5a1f-12e2-ea63aecd78e5@linux.alibaba.com>
 <20230214043344.szvhwukkdkzsky5n@c73>
 <c60fddf7-f49d-3f7c-9383-5fee2ccf7a65@linux.alibaba.com>
 <20230214114829.zxemgnnb22sdba3l@c73>
In-reply-to: <20230214114829.zxemgnnb22sdba3l@c73>
X-Source-IP: 115.124.30.101
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10621
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=128 clxscore=6 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150018 domainage_hfrom=8707
Cc: jack@suse.com
Subject: Re: [Ocfs2-devel] discuss about jbd2 assertion in defragment path
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0Vbhv.Yd_1676426771;
X-ServerName: out30-101.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8l1qYpy7PYovvw1EMIMOXSkISEs1ek50
X-Proofpoint-ORIG-GUID: 8l1qYpy7PYovvw1EMIMOXSkISEs1ek50
Reporting-Meta:
 AAH+BvQRGarsMsyYyT/RJkX1lfUG61e51kx1I6QhIB2YQc7bi/NHS60C4qzjaG+x
 xyFWclMRINK+NcATl1W3nuE19m2zIsM26fFjb0K0ciHS3IBv2A4R9Y1WVdZfyu4I
 1SLqOTMTor5TIiHIZugmO3prE27HpdVupDEehSaGTJtx+HyTxI/JP6d2NpAK4mb5
 nOY/jaAvita8GaJqQPy7Dcd//ZMt5c7yKxJa++/7kXk0Ffdf4IzxSYypr9iOYTFV
 EkNpTMHIPWQPIpuz3iIQ5qwpeFbTIdU91lrDPJkJDK8m7Iq2xGyKIN1gN55gIExS
 HESmBMm4CZQy8B5nNs2yOnVd0thtD6D2lAQW1IXGF7HWSu4xko6Qc1UpDRMmhRZy
 c/LkSLNV3ydMu8qQH8DNhVpFiTlWM0vkoPkToO87jZToE/aBuxJBSanwBue/dP3T
 Z1dxo02XGHvqXJr6Co2NeBReP2gaFOT5YOLwU9odJ8B6jh1ASGv9DCttngKiPb9o
 Ud+T633BV4iofFPKYN8eMr0cbSrkgBNkgDYpD1ItWyM=



On 2/14/23 7:48 PM, Heming Zhao wrote:
> On Tue, Feb 14, 2023 at 07:08:16PM +0800, Joseph Qi wrote:
>> Hi,
>>
>> On 2/14/23 12:33 PM, Heming Zhao wrote:
>>> On Tue, Feb 14, 2023 at 10:52:30AM +0800, Joseph Qi wrote:
>>>> Hi, Sorry about the late reply.
>>>> This thread is indeed a long time ago:(
>>>> It seems that I said the two ocfs2_journal_access_di() are for different
>>>> buffer head. Anyway, I have to recall the discussion before and get back
>>>> to you.
>>>>
>>> If you belive from [a] to [b.1] doesn't need any journal protection, my patch
>>> makes sense from theory.
>>>
>>> From code logic, if the defrag path (ocfs2_split_extent) doesn't call
>>> jbd2_journal_restart(), current code is absolute correct. Increasing credits
>>> can't help avoid jbd2 assert crash, but make more easily to trigger crash,
>>> because it makes jbd2_journal_extend() more easily to return "status > 0". In my
>>> view, the correct fix should delete the access/dirty pair and make sure the
>>> ocfs2_split_extent() is journal self-service.
>>>
>>> Different buffer head issue could be handled by rechecking ocfs2_split_extent(),
>>> make sure all journal handle branches are correct. I already checked
>>> ocfs2_split_extent, but I can't assure my eyes didn't miss any corner.
>>
>> ocfs2_split_extent are not just 'read' operations, it may grow the tree,
>> that's why we have to do a transaction here.
> 
> You misunderstand my meaning, my mean: from the caller __ocfs2_move_extent()
> calling ocfs2_journal_access_di() (below [a]) to (before) the handling
> ctxt.c_contig_type (below [b.1]) in ocfs2_split_extent, this area is purely read
> operations. It's the range [ [a], [b.1]) (include [a], not include [b.1])
> 
> __ocfs2_move_extent
>  + ocfs2_journal_access_di //[a]   <------+
>  + ocfs2_split_extent      //[b]          | [a, b.1) area is read operations
>  |  + if                   //[b.1] <------+
>  |  |  A
>  |  |  +---- from this line, this func starts r/w IOs & needs jbd2 operations
>  |  |  
>  |  |   ocfs2_replace_extent_rec()/ocfs2_split_and_insert()
>  |  + else
>  |      ocfs2_try_to_merge_extent ()
>  |
>  + ocfs2_journal_dirty     //[c]
> 
>>
>> The whole code flow:
>> ocfs2_ioctl_move_extents
>>   ocfs2_move_extents
>>     __ocfs2_move_extents_range
>>       ocfs2_defrag_extent  [1]
>>         ocfs2_start_trans  [a]
>>         __ocfs2_move_extent
>>           ocfs2_journal_access_di
>>           ocfs2_split_extent
>>           ocfs2_journal_dirty
>>         ocfs2_commit_trans
>>       ocfs2_move_extent  [2]
>>         ocfs2_start_trans
>>         __ocfs2_move_extent
>>           ocfs2_journal_access_di
>>           ocfs2_split_extent
>>           ocfs2_journal_dirty
>>         ocfs2_commit_trans
>>     ocfs2_start_trans  [b]
>>     ocfs2_journal_access_di
>>     ocfs2_journal_dirty
>>     ocfs2_commit_trans
>>
>> In above, [a] and [b] are different transaction start/commit pair, and
>> each allocates different journal credits, even they are operate the same
>> bh, they are still different operations.
> 
> I agree above writing, but it can't change my conclusion: ocfs2_split_extent()
> is journal self-service.

Don't understand what does 'journal self-service' mean.

> It seems the author meaning: he wanted [a] to protect defragging actions (extents
> changes), wanted [b] to protect inode ctime changes. the
> ocfs2_start_trans/ocfs2_commit_trans in [a] area is necessary. but the
> access/dirty pair in __ocfs2_move_extent() is potential crash risk.
> 
If so, what is transaction [a] protect? (no dirty buffer)

Thanks,
Joseph

>>
>> My another question is, __ocfs2_move_extent will be called by both
>> ocfs2_defrag_extent and ocfs2_move_extent, why this doesn't happen on the
>> other path?
> 
> The reason is userspace defragfs.ocfs2 never trigger ocfs2_move_extent().
> see do_file_defrag():
> 
> struct ocfs2_move_extents me = {
> 	.me_start = 0,
> 	.me_len = buf->st_size,
> 	.me_flags = OCFS2_MOVE_EXT_FL_AUTO_DEFRAG, //<-- It makes do_defrag becomes 1
> 	                                 //in kernel space __ocfs2_move_extents_range()
> };
> 
> Thanks,
> Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
