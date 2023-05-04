Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8541EC77B7C
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 May 2023 09:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mzM1WfkWnKStfrqRY1/Ifq4+7aa+I9gClZWsRgEMjr8=;
 b=C0ZOhVsjHQ47NUtOTWlGAJndbUWUlUNkkaYFGIqX1lboKwO/b7fajl/D4zL727gJ99FLDvxTOeH0
   VJ6LBjSOfgQ/2iSBJduqtJ0+CDVf4epZyX1Z6hq7zwu3RP/pIPTfV8GJo+C8wurYms6cfzsFtHqb
   veEiTexXPH8pPqIr5azHlkP0wZWBtdo/mmFvdip2sCEh+g44GFedlZQPXgF14q7tqtlvYzfp91CC
   hRoO+jzmiXjSlrjCNjC8aaZKkaBb/1SnH/CQQBtep+p8jGwCl+lo0wTKzENIb0LKGfMdAzy6hPq1
   230EyvKDvJe2m4nlMG+dLx/WhC8M0N5M/9c/zA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mzM1WfkWnKStfrqRY1/Ifq4+7aa+I9gClZWsRgEMjr8=;
 b=TJKgsmeZmtjIDQtR3VZHx5GNCT6bbw9tqq6aMHjLZl9VBLPCOGtvtLR5+574afziCdzCOnPBXJ/N
   EF983ml9N4XXOYePwAbLWJf7acVi8j0Iz+aliQSxWGuuB3sZQwW167QfWAYsfuWyphGW6YgvmWEV
   cTqfOFKWPe+1JufmXW+UheEXeE3hO8VSWQKnOuSZ6GFBt55iJlcSnea0TQF4W3a7c9msZ1STOQbd
   +LYaFFE3kfFpKdsgKCievKoyZKxOz3gjQdbQe16SAE3+pNVcZyusjraBO+vlkxrqDDtRw0UZwLqc
   66tb5DYZVKJQVvzAKctLGa6W3Px3QS9u3wsVUA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU400OATO9PPU50@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 May 2023 09:41:49 +0000 (GMT)
Message-id: <faaed412-7577-ed61-bdb2-7751ced323d1@linux.alibaba.com>
Date: Thu, 4 May 2023 17:41:29 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
 <20230504062136.3d5x77fsms5kx6cs@c73>
 <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
 <20230504080232.5a6suqn2hvtfz52b@c73>
In-reply-to: <20230504080232.5a6suqn2hvtfz52b@c73>
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10699
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 priorityscore=78 adultscore=0 impostorscore=0 clxscore=144 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040079 domainage_hfrom=8785
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: add error handling path when jbd2
 enter ABORT status
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VhhfYGd_1683193289;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ip-TE4rSc0hZ8qfvzqqDHaqee4pghxdb
X-Proofpoint-GUID: ip-TE4rSc0hZ8qfvzqqDHaqee4pghxdb
Reporting-Meta:
 AAGN7/elOazUPPXIyzXM+Pmi61P5S9S99jNIy6kGdQp1AMF4VZV0hcK8/pOFV0AF
 +chZWK5iYIi57rcT49hCEdYpk0EntDZo9v8keX7yWuL+i82pbIRe3Dijwd8Fs8Ny
 2Rerle6sWQhbPEwqOL0nHGc7PKxk5K7aClTiX5GseqTxc7voekiU18FxPlwzIDwj
 eo+2b7MUo/wdiqvahmpHaD/AM11lisY8W8NsVQ5j+a4Vga2tY161KSpm9oQBMwB6
 Y2MjzmWBz2YficeLvZyXpbOmYz0GeeVOn+GL3J89GWQipuJ78jG7sfHJ1usJ2WM/
 YyHmkac3s6BGw5Vtzndv7zptUyXa9YTrTn5vLAnwBvKbQtwRapNA43AWJ53F/fih
 I6Up0S0US+Evn5ZrvY7YwIQRMBLY0PylcZ166IrCBm+a0ZLpKS0jH50cVrGBT60L
 bUu3SAwg7tWKtXNudqTz0G0zSSYNHNbVZk4iyzy5KA12MPRcvmyvyoCcayun33EN
 qhbW2t+SuLPQXCXr672PXRfYIa5lrjXQcJwRhrvPkBR9KA==



On 5/4/23 4:02 PM, Heming Zhao wrote:
> On Thu, May 04, 2023 at 03:34:49PM +0800, Joseph Qi wrote:
>>
>>
>> On 5/4/23 2:21 PM, Heming Zhao wrote:
>>> On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
>>>>
>>>>
>>>> On 4/30/23 11:13 AM, Heming Zhao wrote:
>>>>> fstest generic cases 347 361 628 629 trigger a same issue:
>>>>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
>>>>> journal.
>>>>
>>>> What's the end user impact?
>>>
>>> There are two impacts:
>>>
>>> 1. this issue makes unmount command hanging.
>>>
>>> No one likes or accepts filesystem unmount failure when underlying devices meets
>>> error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
>>> successfully.
>>>
>>
>> So umount hang should be in the patch description, right?
> 
> OK.
> 
>>
>>> 2. for developers to verify their patch doesn't make any regression.
>>>
>>> fstest is a famious & important fs testsuite.
>>> (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
>>>
>>> Current status, there are many test cases (about 9 in my env) cause fstest
>>> hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
>>> gfs2 only has 1 hanging case.
>>>
>>> In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
>>> testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
>>>
>>> On kernel 6.2.9-1, the fstest 'quick' test group result:
>>> (the result based on my two patches [1/2] & [2/2])
>>> ```
>>> ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
>>>
>>> Failures: generic/003 generic/013 generic/015 generic/040 generic/041
>>> generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
>>> generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
>>> generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
>>> generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
>>> generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
>>> generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
>>> generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
>>> generic/636 generic/702
>>> Failed 49 of 568 tests
>>> ```
>>>
>>>>
>>>> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
>>>> filesystem. And we should not commit any further transactions.
>>>> It seems that we may unify the behavior like:
>>>>
>>>> if (is_journal_aborted(journal))
>>>> 	return -EROFS;
>>>>
>>>>
>>> IIUC, do you mean add above code in ocfs2_commit_cache or in
>>> ocfs2_commit_thread?
>>
>> Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
>> Actually we've handled this case before, but just limit the print. But
>> it seems not enough now.
> 
> I wrote in my previous mail. Follow your idea, The code should be:
> 
> if (is_journal_aborted(journal)) {
> 	ocfs2_error(osb->sb, "jbd2 status: ABORT.\n"); //this line is important.
> 	return -EROFS;
> }
> 
> Only return -EROFS then break loop in ocfs2_commit_thread() is not enough.
> Without ocfs2_error(), ocfs2 could accept new IOs from userspace, then the new
> IOs will trigger IO error then trigger RO status. This flow is wrong, we should
> mark RO as early as possible when JBD ABORT happens. In my view, the best place
> is my [2/2] patch code which in ocfs2_commit_cache().
> 

Agree, but ocfs2_abort() is more appropriate here, see
ocfs2_start_trans(). But ocfs2_abort() may panic system, I'm afraid it
has to change to read-only accordingly.

>> BTW, the basic rule here is, we don't want to change journal to prevent
>> other nodes corrupting the filesystem.
> 
> If my memory is correct, every node has itself special journal partition.
> If the HA stack assigns the same (before fenced) nodeid to JBD ABORTed machine, 
> No other node could corrupting the fs.
> 
I don't think it's a good idea to modify journal even flush fails. Why
not catch EROFS in commit thread and break? Now we can only expect
umount continues with error, right?


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
