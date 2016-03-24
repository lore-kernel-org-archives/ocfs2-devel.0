From: Gang He <ghe@suse.com>
Date: Wed, 23 Mar 2016 23:49:06 -0600
Subject: [Ocfs2-devel] File system is read-only review
In-Reply-To: <56F269B6.5050504@huawei.com>
References: <2015112019003413274371@h3c.com> <565263EA.5040306@huawei.com>
	<56F2D687020000F90002EE56@prv-mh.provo.novell.com>
	<56F269B6.5050504@huawei.com>
Message-ID: <56F3F052020000F90002F109@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeseph and Jiufei,


>>> 
> Hi Gang?
> 
> On 2016/3/23 17:46, Gang He wrote:
>> Hello Joseph and Jiufei,
>> 
>> I got a customer issue, ocfs2: filesystem goes read-only after node restart.
>> The symptom is very similar with this bug, when the ocfs2 file system called 
> ocfs2_recover_orphans() during mounting period, 
>> Then, encountered this issue, the stack likes,
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.689531] ocfs2: Mounting device 
> (253,1) on (node 1770803, slot 0) with writeback data mode.
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.695279] OCFS2: ERROR (device 
> dm-1): ocfs2_commit_truncate: Inode 1075718 has empty extent block at 1075718
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.695283]
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.695287] File system is now 
> read-only due to the potential of on-disk corruption. Please run fsck.ocfs2 
> once the file system is unmounted.
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.695297] 
> (kworker/u:36,913,16):ocfs2_truncate_for_delete:585 ERROR: status = -30
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.695302] 
> (kworker/u:36,913,16):ocfs2_wipe_inode:754 ERROR: status = -30
>> Mar 10 17:45:11 mipkhpch2bl07 kernel: [   81.695308] 
> (kworker/u:36,913,16):ocfs2_delete_inode:1039 ERROR: status = -30
>> 
>> I saw your mails, Jiufei ever tried to fix this bug, but these three patches 
> were not all accepted by Linux git tree.
>> Then, I want to know what is this bug's final status? 
> OCFS2 readonly due to corrupted extent block or extent record.
> 
>> Second, as you said, misusing jbd2_journal_restart() possibly results in 
> this issue, by now, which patch can fix this misusing?
> The patch series submitted by Jiufei.
> https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010768.html 
> There are still two patches are pending in the next tree:
> ocfs2: extend enough credits for freeing one truncate record while replaying 
> truncate records
> ocfs2: extend transaction for ocfs2_remove_rightmost_path() and 
> ocfs2_update_edge_lengths() before to avoid inconsistency between inode and 
> et
Thank for your comments, one more question.
Only merging these three patches can fix this bug? my means is , are there any other dependent patch need to be merge firstly?
since we saw Jiufei submited a few patches continuously in this area in the past year.

Thanks a lot.
Gang 

> 
>> Finally, if the customers have hit this case (very bad, start ocfs2 file 
> system and get read-only), 
>> how to get the file system back? unmount the file system and run fsck.ocfs2, 
> or patch the kernel code and bypass this logic(which patch can do this?). 
> Merge these patches can only correct the logic in the future.
> For the corrupted filesystem, you should run fsck.
> 
> Thanks,
> Joseph
> 
>>  
>> 
>> Thanks
>> Gang 
>> 
>> 
>> 
>>>>>
>>> Hi Guanghui,
>>> Misusing jbd2_journal_restart() may cause this issue.
>>> You can find details and patches we sent before.
>>>
>>> ocfs2: fix some inconsistency problems caused by jbd2_journal_restart()
>>> https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010768.html 
>>>
>>> On 2015/11/20 19:00, Zhangguanghui wrote:
>>>>
>>>> File system is read-only when deleting the inode, So I try fsck.ocfs2 -f and 
> 
>>> success,
>>>> Anybody ever see this, how to avoid this, Thanks 
>>>>
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.362978] OCFS2: ERROR (device dm-2): 
>>> ocfs2_commit_truncate: Inode 24772873 has empty extent block at 24772873
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.362978]
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.362986] File system is now read-only 
>>> due to the potential of on-disk corruption. Please run fsck.ocfs2 once the 
>>> file system is unmounted.
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.362991] 
>>> (kworker/u129:0,32928,0):ocfs2_truncate_for_delete:574 ERROR: status = -30
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.362993] 
>>> (kworker/u129:0,32928,0):ocfs2_wipe_inode:743 ERROR: status = -30
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.362996] 
>>> (kworker/u129:0,32928,0):ocfs2_delete_inode:1022 ERROR: status = -30
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.434249] OCFS2: ERROR (device dm-2): 
>>> ocfs2_commit_truncate: Inode 1445125 has empty extent block at 1445125
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.434249]
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.434256] 
>>> (kworker/u129:0,32928,1):ocfs2_truncate_for_delete:574 ERROR: status = -30
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.434258] 
>>> (kworker/u129:0,32928,1):ocfs2_wipe_inode:743 ERROR: status = -30
>>>> Nov 18 11:04:30 cvk110 kernel: [144411.434261] 
>>> (kworker/u129:0,32928,1):ocfs2_delete_inode:1022 ERROR: status = -30
>>>>
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> 
> -----------------------------------------------------------------------------
>>> ---------------------------------------------------------------!
>>> ---
>>>> zhangguanghui
>>>>
>>> 
> -----------------------------------------------------------------------------
>>> --------------------------------------------------------
>>>> ???????????????????????????????????????
>>>> ????????????????????????????????????????
>>>> ????????????????????????????????????????
>>>> ???
>>>> This e-mail and its attachments contain confidential information from H3C, 
>>> which is
>>>> intended only for the person or entity whose address is listed above. Any 
>>> use of the
>>>> information contained herein in any way (including, but not limited to, 
>>> total or partial
>>>> disclosure, reproduction, or dissemination) by persons other than the 
>>> intended
>>>> recipient(s) is prohibited. If you receive this e-mail in error, please 
>>> notify the sender
>>>> by phone or email immediately and delete it!
>>>>
>>>>
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com 
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com 
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>> 
>> .
>> 
