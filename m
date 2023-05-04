Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B045C7EE21
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 May 2023 07:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KGu8n17TdKEAX/oZwrlq2rohsFmJcCMTVIn4xRmLhlE=;
 b=eUQLxS4qz++IdQuZ1JoKOk2BmluKQ9RQ3+34LmMNCLIErAyLVuK6dhl28j/cOXWgIVUnO/C3GtQc
   GOJXk2zt6nvPT7EFI+fLvs3DvTyLZTW2vgGuzHovKtOb+QD9it65noK8u9O+rjJ4VcHquCKH+7Zk
   F6oRKNyFHSDJPrYd6J1+QJO31eeauxZ8vxPZbFV1E7HeUZYXqXf91CPT6hXbs0nqO3rxP9F4sElf
   4H1pKb/H6cmOEOpyjynHAhbVyakUAoCsS9lhWBApgt00PyYBKofGOhVD/uPXlwq4epXNgV9+1hj3
   Ob3U6VNvlsoMMOi+pz6ISCOqbDf2I+d+o+rPqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KGu8n17TdKEAX/oZwrlq2rohsFmJcCMTVIn4xRmLhlE=;
 b=cDTsBIXD6UbZGKOTRwFvKnluJuhcOcAxiEUeW10+CXzISxCuM1Db6jRPNiYsZwcDCROycqymY3Pw
   zzOllykg0XhFuaRlg/J4YvN0hl4W83sB1P7c/LCqnbEadV5RCGDl1psZJIaBCnD8Ro/RvQWQ0IKq
   z1f0LrL2at09YCfQJ3CqLoIXQcM9x/iChwI3DSZcdIqfguqC8a664TlmNnReTkGmDO1bNBQvW7rG
   6pqhnzzyQaNl1DE2eJAjoZydZWVqQJ7UwGGL72Nu19ZNeYwXycPPMY4G93L9uQXgJUQW7Vb3AQv3
   oHP8JF5iOxbPw2I0PaDtsNERZJlUVi65Z0UjHw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU4007UOIEMIX90@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 May 2023 07:35:11 +0000 (GMT)
Message-id: <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
Date: Thu, 4 May 2023 15:34:49 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
 <20230504062136.3d5x77fsms5kx6cs@c73>
In-reply-to: <20230504062136.3d5x77fsms5kx6cs@c73>
X-Source-IP: 115.124.30.118
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10699
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 priorityscore=70 adultscore=0 impostorscore=0 clxscore=143 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040061 domainage_hfrom=8785
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0Vhfhw18_1683185689;
X-ServerName: out30-118.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: cOkj1w08lWtUyCNok69qTt6gbaimN_Zn
X-Proofpoint-ORIG-GUID: cOkj1w08lWtUyCNok69qTt6gbaimN_Zn
Reporting-Meta:
 AAEkoZQiYt2Jcf+T0qYIoAFi+gqLuYf3vC2eMe8cEXzXfTkUHl4zmPyINNoYpMat
 w5QO6i9gMykolf5YyamM99EVYXMpPDuXcC41w0xdu3q4UHQUlCWbecI9B1k6mdNG
 ncsf069ppnoSpwcaliM+Jm9usUktkWgf5+eVBVxot5JmX2DTaOS+f1IpJk1GU1hW
 oQvW8KJLrNXxOkKWivDo61Z2cAaoADWBv64iJWh+zWZTLYPfO+tI9LsopCNzVXpZ
 zb2FW/klsNHM5XNY//k+k4WHs6I/Q6QmIMvdnLRDdIVD3TGjpJbOklP55YIh1xKW
 ibW2UChwgyZTyQUqUm5gVRmhJSU6eUt1ujIrwuK+40ubLDfR7Ny9eAhNa+LZqJFd
 GB8Z7Z2jmLd+6UtwczRj+n41g3lYvm766GWHLqMt34Jg9mbHijVOAdQPwo2UcrtX
 aNpZUO86qmxqXa8acUzflrdJ3ylCSJUVE+NwNBsOKO8/QekzfkyJPcC05ekGw2Pf
 2UKN+mECpX66OTGFftDjWTsWm34fLdLkVyM8TOy8jIMu



On 5/4/23 2:21 PM, Heming Zhao wrote:
> On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
>>
>>
>> On 4/30/23 11:13 AM, Heming Zhao wrote:
>>> fstest generic cases 347 361 628 629 trigger a same issue:
>>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
>>> journal.
>>
>> What's the end user impact?
> 
> There are two impacts:
> 
> 1. this issue makes unmount command hanging.
> 
> No one likes or accepts filesystem unmount failure when underlying devices meets
> error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
> successfully.
> 

So umount hang should be in the patch description, right?

> 2. for developers to verify their patch doesn't make any regression.
> 
> fstest is a famious & important fs testsuite.
> (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
> 
> Current status, there are many test cases (about 9 in my env) cause fstest
> hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
> gfs2 only has 1 hanging case.
> 
> In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
> testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
> 
> On kernel 6.2.9-1, the fstest 'quick' test group result:
> (the result based on my two patches [1/2] & [2/2])
> ```
> ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
> 
> Failures: generic/003 generic/013 generic/015 generic/040 generic/041
> generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
> generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
> generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
> generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
> generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
> generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
> generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
> generic/636 generic/702
> Failed 49 of 568 tests
> ```
> 
>>
>> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
>> filesystem. And we should not commit any further transactions.
>> It seems that we may unify the behavior like:
>>
>> if (is_journal_aborted(journal))
>> 	return -EROFS;
>>
>>
> IIUC, do you mean add above code in ocfs2_commit_cache or in
> ocfs2_commit_thread?

Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
Actually we've handled this case before, but just limit the print. But
it seems not enough now.
BTW, the basic rule here is, we don't want to change journal to prevent
other nodes corrupting the filesystem.

> 1>
> If in ocfs2_commit_cache, this fix doesn't take any effect for unmount
> failure(hanging).
> When return -EROFS, the caller ocfs2_commit_thread just print error message and
> keep going to retry.
> 2>
> If in ocfs2_commit_thread, it makes commit thread exit/stop without notifying
> other ocfs2 paths. Later wake_up(&osb->checkpoint_event) won't take effect,
> ocfs2 will enter chaose. 
> 
> In my view, there is missing a place to set fs RO. So [2/2] in
> ocfs2_commit_cache, uses ocfs2_error to mark RO before returning status (<0
> value). The ocfs2_error is the right place to mark RO.
> 
> - Heming
> 
>>>
>>> This commit gives ocfs2 ability to handle jbd2 ABORT case.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>  fs/ocfs2/alloc.c      | 10 ++++++----
>>>  fs/ocfs2/journal.c    |  5 +++++
>>>  fs/ocfs2/localalloc.c |  3 +++
>>>  3 files changed, 14 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>>> index 51c93929a146..d90961a1c433 100644
>>> --- a/fs/ocfs2/alloc.c
>>> +++ b/fs/ocfs2/alloc.c
>>> @@ -6308,11 +6308,13 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
>>>  
>>>  	if (tl_inode) {
>>>  		cancel_delayed_work(&osb->osb_truncate_log_wq);
>>> -		flush_workqueue(osb->ocfs2_wq);
>>> +		if (!is_journal_aborted(osb->journal->j_journal)) {
>>> +			flush_workqueue(osb->ocfs2_wq);
>>>  
>>> -		status = ocfs2_flush_truncate_log(osb);
>>> -		if (status < 0)
>>> -			mlog_errno(status);
>>> +			status = ocfs2_flush_truncate_log(osb);
>>> +			if (status < 0)
>>> +				mlog_errno(status);
>>> +		}
>>>  
>>>  		brelse(osb->osb_tl_bh);
>>>  		iput(osb->osb_tl_inode);
>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>> index 25d8072ccfce..2798067a2f66 100644
>>> --- a/fs/ocfs2/journal.c
>>> +++ b/fs/ocfs2/journal.c
>>> @@ -312,11 +312,16 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
>>>  	status = jbd2_journal_flush(journal->j_journal, 0);
>>>  	jbd2_journal_unlock_updates(journal->j_journal);
>>>  	if (status < 0) {
>>> +		if (is_journal_aborted(journal->j_journal)) {
>>> +			ocfs2_error(osb->sb, "jbd2 status: ABORT.\n");
>>> +			goto reset;
>>> +		}
>>>  		up_write(&journal->j_trans_barrier);
>>>  		mlog_errno(status);
>>>  		goto finally;
>>>  	}
>>>  
>>> +reset:
>>>  	ocfs2_inc_trans_id(journal);
>>>  
>>>  	flushed = atomic_read(&journal->j_num_trans);
>>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>>> index c4426d12a2ad..e2e3400717b0 100644
>>> --- a/fs/ocfs2/localalloc.c
>>> +++ b/fs/ocfs2/localalloc.c
>>> @@ -378,6 +378,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>>>  	if (osb->ocfs2_wq)
>>>  		flush_workqueue(osb->ocfs2_wq);
>>>  
>>> +	if (is_journal_aborted(osb->journal->j_journal))
>>> +		goto out;
>>> +
>>>  	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
>>>  		goto out;
>>>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
