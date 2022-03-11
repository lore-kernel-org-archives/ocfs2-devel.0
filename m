Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42320C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 11 Mar 2022 03:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5rurAeefxlBQtWt5+HqACF+d2UClbGrsWxv5C7r//8k=;
 b=NE2RAMmWsRj+NCwtF3plEeNSHDPFAUYMgC7msrKdXEVC8hvLgOL+h4WEV++Rx5wmTCbILYh3wK+0
   7eI7zbIGDx0FUaC0V9VphtOqewy9LJiOyd5/89DMbQEMihyn4PWfZih2AV8Q9mT980F6wff/0W4I
   EkiVv1k6Zn0dXal9zMKSOtxS9uhVS0idPrNhjvsSeVqaSotx5ZIzp9Qf489Hc2V/+A7Z/QWVK8hy
   DB1D6MLFpdbF3/m8+bHe/3hVetfLONsqCCoL4tY3lRQNfQJZlhX5/gKOqzZpUxTC0VLe/nJEtuF1
   ZY2ngTfuCUVUiYHsMWMCDgUy4ll4CufmFyRPjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5rurAeefxlBQtWt5+HqACF+d2UClbGrsWxv5C7r//8k=;
 b=icc+weBNj7byPK5gNfmH4biC2HGz7W3DiMQSiQJ2u+QpG5MWZGvdGZ87WnXClkpujLQHgve2BENf
   SDEFRKuocvu5K/hBc05H165U3RZ9OPWW29Ocuz7fdcAbMcKS6pBCEpjYK4s5/U8/yUsWvL8KSAyE
   MUhnFn1uN7xj4tFTuuYMMTI9ipWJVTELnjVuqfyKN6VT2pa+hqdbNWev+qhy+H/PagwSGcCyJNl4
   5udIRikh8Y2zTcHswjAA/DixmHlo8U+kZWblFS42B6tapkMMmFvsgulgCKl2HE85pKWgdpUNchf3
   2OicmEyczQEjVFLuO2OWXrmGVZVSg4lLjOjmvg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8K00CI98RKJ900@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 11 Mar 2022 03:09:20 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <bd0ec87e-b490-83dc-2363-5e5342c59fa4@linux.alibaba.com>
Date: Fri, 11 Mar 2022 11:08:54 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Joseph Qi <jiangqi903@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>
References: <20220307145138.GA22641@kili>
 <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com> <20220309145717.GX3315@kadam>
 <5a5933bb-3078-2cfa-9403-a6b497199449@linux.alibaba.com>
 <20220310133918.GH3315@kadam> <eecb818a-538a-0201-c3f1-19d7c36b8dff@gmail.com>
In-reply-to: <eecb818a-538a-0201-c3f1-19d7c36b8dff@gmail.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282
 signatures=692556
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=217 priorityscore=70 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110013 domainage_hfrom=8366
Cc: Jakob Koschel <jakobkoschel@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [bug report] ocfs2/dlm: Fix race in adding/removing
 lockres' to/from the tracking list
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R831e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0V6rzwSo_1646968134;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: QTOKH6So-dIy-a7RvTyYjPUHlH1BHUbI
X-Proofpoint-GUID: QTOKH6So-dIy-a7RvTyYjPUHlH1BHUbI
Reporting-Meta:
 AAFoaQuxJWdlYE2JjbOVpVsUGVoPGeW4fTxi92sfN6ycL22s//qhS28j0DM7eDtJ
 594+XKGX2JqrdHc/5ZnFCBwUcvYiG9dQQQNTK17lOluSiWOCeR9FohFv0q1lfhM+
 GHyLaeuWsT7q4quzuQvxPSGsGYIB+/8f4xzMrt7c1vc9r0Ygi9nGEmZNZpcGdeYp
 L/tL/XToiVf0sZRzb0fnAorjucZh4//t6JgmyJRZi5/IoaJ6s2RdJuYVj66Ywm0+
 yuGdFu/FhRVYiOj3HBijVq4x08knLTQvm/pOyyy9jmrC+bD27RiKQ4Z9qYRbZ6pA
 iJJI3UDMR56udPEsnhHoAD2xtVEg/ei0ocdB4g6PqZLY1bmZw9aqk3YK6BMK9qW9
 r6rdSwDgWFr5cgMJnQNz5c8wrRzflE/1jTAl8wfJyFRcy+sNSq75jeDUzFIFmles
 TrAwql59KucJoKYTBM+/VN4vF6K9qNTsBa/5zDA6aBXLyJQ1hsWS9et6IhpfVHPQ
 7cvdJurwbDg7jZ5pLoHSAp5JiwcZXw4YxTKpG+q060mV



On 3/11/22 9:50 AM, Joseph Qi wrote:
> 
> 
> On 3/10/22 9:39 PM, Dan Carpenter wrote:
>> On Thu, Mar 10, 2022 at 11:13:05AM +0800, Joseph Qi wrote:
>>>>>>     557         }
>>>>>>     558 
>>>>>>     559         list_for_each_entry(res, track_list, tracking) {
>>>>>>     560                 if (&res->tracking == &dlm->tracking_list)
>>>>>>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>> This should never be possible.  How is it possible?  If
>>>>>> &dlm->tracking_list is the list head the it's not possible without
>>>>>> memory corruption.  If &oldres->tracking is the list head then I do not
>>>>>> see how it is possible without memory corruption.  We can't mix different
>>>>>> types of list entries on the same list head?>
>>>>> In case of oldres, and the iterator points to dlm_ctxt.
>>>>> In this case, the lockres is not a valid one.
>>>>
>>>> That doesn't make sense.  :/  This condition is doing pointer math.
>>>> The offset of ->tracking is 136 bytes and ->tracking list is 88 bytes
>>>> into the dlm struct.
>>>>
>>> Now track_list is oldres->tracking, which is already linked to
>>> dlm->tracking_list?
>>
>> Are you saying or are you guessing?  :P
>>
> Honestly speaking, since these are debug code and not used often,
> I'm not quite sure it's the case described above.
> I'll dig it more later.
> 
Say there are totally 3 lockres now, and they are linked to dlm->tracking_list
when initializing:
head -> lockresA -> lockresB -> lockresC

now dump lockres:
cat /sys/kernel/debug/o2dlm/<domain>/locking_state

Round1:
oldres is NULL, track_list is dlm->tracking_list
dump lockresA

Round2:
oldres is lockresA, track_list is lockresA->tracking
put ref of lockresA
dump lockresB

Round3:
oldres is lockresB, track_list is lockresB->tracking
put ref of lockresB
dump lockresC

Round4:
oldres is lockresC, track_list is lockresC->tracking
now it is the end of tracking list
put ref of lockresC

Thanks,
Joseph

>> It's not impossible to set this condition up so that it's true.  But
>> it's bug if someone does that.
>>
>> I really think that condition can be deleted.  If you look at the commit
>> which added it b0d4f817ba5d ("ocfs2/dlm: Fix race in adding/removing
>> lockres' to/from the tracking list") the it's easy to imagine that it
>> was a copy and pasted pasted by mistake.
>> You may test your changes simply by:
> mkfs.ocfs2 -b 4k -C 1M -T datafiles /dev/vdc
> mount /dev/vdc /mnt/ocfs2
> cat /sys/kernel/debug/o2dlm/<domain>/locking_state
> 
> Thanks,
> Joseph
> 
>> Or another possibility is that it was debug code that was committed
>> accidentally.  After all if you remove the locking a delete the last
>> entry at the right time then it would be easy enough for the condition
>> to be true.  Hopefully, these days the locking prevents that condition
>> from being possible.
>>
>> regards,
>> dan carpenter

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
