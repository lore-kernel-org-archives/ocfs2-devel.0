Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F440C7EE22
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 May 2023 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=94YQyywuERxGnRwFElGhD9U0cRYJFtKal99q63YWzvQ=;
 b=GUMDe0rNaZeFiZEX1vZOLTrHQ7fw+tmfMiMVIG7TLoMqBZ13V3WBCUZhcABZb5mUXXj9xcaXV8xg
   nZyMqW+HVDgC/6EF1DrvMiDPHDAxnHVgLq/KA7WSbqSL30tWgWDIgdt2fEYPRg7lVXxyLvdxJuwp
   qoRpu6QfpsJCmJYS+445/NF8WdGLuo2YHzPnC+7udq6t7TF/4go0MWTu4GAmbai15BJIud7xN0gn
   sx8HOeY/wlDhfSGWx4YucEk9MzJ9MNeXQOkWbQKKvkkNaPfwEmvv8msJrKpsdI8tooSaTQLs1/nu
   r23eyDSK35JAqJ1xea1PZWIPEz9MzMlB8Ig5uA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=94YQyywuERxGnRwFElGhD9U0cRYJFtKal99q63YWzvQ=;
 b=nTp6fJTCsgMc0IZp7JxSDeCRPhIvlSrLh8iqm3v3qJ9+9ejKnIZjD0/utwWC+fmMN0XBA24eIYSc
   ODqNMmg4RCMg1FoGx2P2ATgoAww/Ey60T33NQ7xgBR1kEk/9fOU/IvDxsIZeUdCcd798t3GO9E2V
   PdVMdHVJA2va0vbww4C8wD1h1gRhCnZ2nwwEBH2BHvRcRAKeqZr/7VEEDPlVdUa+YgChA3KJ1rFT
   qVN/65JTFQf77QOgiiaf76qEoXT3KJVeveMBcskPy5/udrcX6KmRbVOWQaGy6k5Rq7D3PxwC22qw
   v6poAbrRUJP+rLDB7/EC7DU54A3Skd7M8qZUSg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RUD002BOBX49LD0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 09 May 2023 01:53:28 +0000 (GMT)
Message-id: <a8f712c1-1256-2cc3-ddb9-14f35b0afcba@linux.alibaba.com>
Date: Tue, 9 May 2023 09:53:06 +0800
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
 <faaed412-7577-ed61-bdb2-7751ced323d1@linux.alibaba.com>
 <20230504162022.jajkdgj2rgus2w3x@c73>
 <2b90546e-d23e-7d45-22dd-a887a73f3e61@linux.alibaba.com>
 <20230508164030.twkuuqr5l2pubqek@c73>
In-reply-to: <20230508164030.twkuuqr5l2pubqek@c73>
X-Source-IP: 115.124.30.100
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10704
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=115
 priorityscore=30 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090014 domainage_hfrom=8790
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0Vi8sv.j_1683597187;
X-ServerName: out30-100.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: C8U6fOK5OEEToZP7FDtuEgcRZmYltTo5
X-Proofpoint-ORIG-GUID: C8U6fOK5OEEToZP7FDtuEgcRZmYltTo5
Reporting-Meta:
 AAGBCRtArU5Pnf9dmr4gTBfIIHa+BQ61rRQHNeyybZPfpZ36hEun/KyhWW9wwgMo
 cKGUlF2HRm12mqiE5Ro+0PQnexYwohfdTeEdbDZx9WplISwQbIiSAeIs3y2LCA/J
 o+Z0juFOZQ299DRb+OetICIgHQ4Zojgo6tgGeBJPgwRf/1RxuGdWkDLJFpKSQMi8
 N7DuiG/1mVCfNgAa0n9PlOvEAI7I7M3SjOeX0miVme/QMFEQheRQJzTiGymq/Qwg
 f6aOAuz+VPo5ifxHCAopQkSqOMHheO2CD6SKK7PKsfL2hSwYx5Hi+n4h2gMBBvhE
 2R4KCiaD6u+siSghY8GzmKBzeNvkSQaipx/ZO95V5EbW4xwINDeEuW3KhF5WqwPX
 nliDty18DBkYQ9OpmhEKlukT1i0BHzlKYUbIW6yp/cr51pQjAj8tmkw1U2NReaQ7
 SNm3EuMyQ+scTN826u364BSMI+ScB/VEKoAcQNr8Jy6i/5bXhHwCgTgpCv8N0R1w
 Pnxkue8RVBeE4aYgADTi/Q6AOLYr9jw4VDjekxqR1iRP



On 5/9/23 12:40 AM, Heming Zhao wrote:
> Sorry for reply late, I am a little bit busy recently.
> 
> On Fri, May 05, 2023 at 11:42:51AM +0800, Joseph Qi wrote:
>>
>>
>> On 5/5/23 12:20 AM, Heming Zhao wrote:
>>> On Thu, May 04, 2023 at 05:41:29PM +0800, Joseph Qi wrote:
>>>>
>>>>
>>>> On 5/4/23 4:02 PM, Heming Zhao wrote:
>>>>> On Thu, May 04, 2023 at 03:34:49PM +0800, Joseph Qi wrote:
>>>>>>
>>>>>>
>>>>>> On 5/4/23 2:21 PM, Heming Zhao wrote:
>>>>>>> On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 4/30/23 11:13 AM, Heming Zhao wrote:
>>>>>>>>> fstest generic cases 347 361 628 629 trigger a same issue:
>>>>>>>>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
>>>>>>>>> journal.
>>>>>>>>
>>>>>>>> What's the end user impact?
>>>>>>>
>>>>>>> There are two impacts:
>>>>>>>
>>>>>>> 1. this issue makes unmount command hanging.
>>>>>>>
>>>>>>> No one likes or accepts filesystem unmount failure when underlying devices meets
>>>>>>> error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
>>>>>>> successfully.
>>>>>>>
>>>>>>
>>>>>> So umount hang should be in the patch description, right?
>>>>>
>>>>> OK.
>>>>>
>>>>>>
>>>>>>> 2. for developers to verify their patch doesn't make any regression.
>>>>>>>
>>>>>>> fstest is a famious & important fs testsuite.
>>>>>>> (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
>>>>>>>
>>>>>>> Current status, there are many test cases (about 9 in my env) cause fstest
>>>>>>> hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
>>>>>>> gfs2 only has 1 hanging case.
>>>>>>>
>>>>>>> In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
>>>>>>> testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
>>>>>>>
>>>>>>> On kernel 6.2.9-1, the fstest 'quick' test group result:
>>>>>>> (the result based on my two patches [1/2] & [2/2])
>>>>>>> ```
>>>>>>> ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
>>>>>>>
>>>>>>> Failures: generic/003 generic/013 generic/015 generic/040 generic/041
>>>>>>> generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
>>>>>>> generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
>>>>>>> generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
>>>>>>> generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
>>>>>>> generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
>>>>>>> generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
>>>>>>> generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
>>>>>>> generic/636 generic/702
>>>>>>> Failed 49 of 568 tests
>>>>>>> ```
>>>>>>>
>>>>>>>>
>>>>>>>> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
>>>>>>>> filesystem. And we should not commit any further transactions.
>>>>>>>> It seems that we may unify the behavior like:
>>>>>>>>
>>>>>>>> if (is_journal_aborted(journal))
>>>>>>>> 	return -EROFS;
>>>>>>>>
>>>>>>>>
>>>>>>> IIUC, do you mean add above code in ocfs2_commit_cache or in
>>>>>>> ocfs2_commit_thread?
>>>>>>
>>>>>> Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
>>>>>> Actually we've handled this case before, but just limit the print. But
>>>>>> it seems not enough now.
>>>>>
>>>>> I wrote in my previous mail. Follow your idea, The code should be:
>>>>>
>>>>> if (is_journal_aborted(journal)) {
>>>>> 	ocfs2_error(osb->sb, "jbd2 status: ABORT.\n"); //this line is important.
>>>>> 	return -EROFS;
>>>>> }
>>>>>
>>>>> Only return -EROFS then break loop in ocfs2_commit_thread() is not enough.
>>>>> Without ocfs2_error(), ocfs2 could accept new IOs from userspace, then the new
>>>>> IOs will trigger IO error then trigger RO status. This flow is wrong, we should
>>>>> mark RO as early as possible when JBD ABORT happens. In my view, the best place
>>>>> is my [2/2] patch code which in ocfs2_commit_cache().
>>>>>
>>>>
>>>> Agree, but ocfs2_abort() is more appropriate here, see
>>>> ocfs2_start_trans(). But ocfs2_abort() may panic system, I'm afraid it
>>>> has to change to read-only accordingly.
>>>
>>> You are right. I ever used ocfs2_abort() then got panic. :)
>>> So I changed to ocfs2_error(). I also sent two mails in 2023-4-30 (the first
>>> mail has mess format by thunderbird). I copy the mail content here:
>>> ```
>>> More info for this patch, maybe I should write below info in commit log.
>>>
>>> From the comment of __ocfs2_abort(), there is another way to handle
>>> journal ABORT: panic.
>>> And fstest generic test NO. 648 will trigger ocfs2_abort then make
>>> kernel panic. I don't like the panic style, ocfs2 should elegantly
>>> handle journal abnormal case.
>>> ```
>>>
>>> fstest NO. 648 could trigger ocfs2_abort from ocfs2_start_trans(). So you could
>>> find my previous mail, I ran the fstest with parameter '-e generic/648', which
>>> means fstest excludes NO. 648.
>>>
>>> The only different between ocfs2_abort and ocfs2_error is set
>>> OCFS2_MOUNT_ERRORS_PANIC, which could trigger panic. If you think panic is
>>> brute, I suggest to use ocfs2_error.
>>>
>>
>> Looked back the history, it is designed to panic in cluster mode:
>> a2f2ddbf2baf ocfs2: __ocfs2_abort() should not enable panic for local mounts
> 
> About the panic action from ocfs2_abort(), in my view, it's too scared to
> acceptable. I am not familar with o2cb stack, in pcmk stack, there is
> resource-agents RA Filesystem[1], which includes two level to detect fs abormal:
> - Filesystem_monitor_10 : read the device
> - Filesystem_monitor_20 : write and read a status file
> 
> if ocfs2 enters abort status, Filesystem RA will detect it and trigger HA stack
> to do the handover resources job.
> if Filesystem RA doesn't apply monitor_[10|20] level, a readonly fs (not panic
> then generate a coredump) could give administrator more info to locate the
> rootcause.
> 
> I write above base on gfs2 fstest result: gfs2 doesn't panic for the ocfs2 panic
> cases.
> 
> [1]:
> https://github.com/ClusterLabs/resource-agents/blob/main/heartbeat/Filesystem
> 

Agree, so a more elegant way is to make the journal abort node behaves
like node down, e.g. set hard readonly so that heartbeat also can not
update normally.

In xfstests, it uses device mapper to simulate disk down, so it will
also trigger node down recover since heartbeat won't update normally?

Also, I'm not sure pcmk supports fence other node by only rejecting IOs.
The built-in ocfs2 fence policy only supports fence self through panic
or reset.

Thanks,
Joseph 

>>
>>>>
>>>>>> BTW, the basic rule here is, we don't want to change journal to prevent
>>>>>> other nodes corrupting the filesystem.
>>>>>
>>>>> If my memory is correct, every node has itself special journal partition.
>>>>> If the HA stack assigns the same (before fenced) nodeid to JBD ABORTed machine, 
>>>>> No other node could corrupting the fs.
>>>>>
>>>> I don't think it's a good idea to modify journal even flush fails. Why
>>>> not catch EROFS in commit thread and break? Now we can only expect
>>>> umount continues with error, right?
>>>>
>>>
>>> With your idea, I spent more than two hours for coding & testing. The result is
>>> my patch [2/2] is correct. Please believe my patch [2/2].
>>>
>>
>> I am not arguing if your patch can pass the testcases above. I am
>> talking about whether we do it this way is right.
>>
>> Now journal flush actually fails since journal is abort, which means
>> journal data are not reflected in filesystem. But after your change, it
>> behaves like we've done a normal checkpoint.
>>
>> Take the following scenario into consideration:
>> N0 does some changes on file1, but now disk down and journal is abort,
>> and checkpoint behaves successfully even it does nothing.
>> N1 get the access right on file1 and does other changes, and checkpoint
>> normally.
>> N0 is crash, and N1 begins to recover N0, then data corruption happens.
>>
>> I've fixed a similar issue in the past:
>> 6f6a6fda2945 jbd2: fix ocfs2 corrupt when updating journal superblock fails
>>
> 
> I agree with above description. Thank you for pointing out my mistake, I forgot
> the dlm layer callback for node-down case.
> 
> - Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
