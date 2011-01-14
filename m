From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 14 Jan 2011 14:38:12 -0800
Subject: [Ocfs2-devel] Problems with fsck
In-Reply-To: <4D300363.6080004@tao.ma>
References: <4D2DCCF1.4080303@navynet.it> <4D2DD3E0.7080509@oracle.com>
	<4D300363.6080004@tao.ma>
Message-ID: <4D30D054.9050804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao,
Thanks. Mark signed off the first two. I can sign off the other two.

Tiger,
Please can you take these four patches and test enabling indexdirs
on a volume. Please do this ASAP. I want this in the git tree by early
next week.

Thanks
Sunil

On 01/14/2011 12:03 AM, Tao Ma wrote:
> On 01/13/2011 12:16 AM, Sunil Mushran wrote:
>> fsck is failing because it is encountering block(s) with incorrect
>> checksums. An easy solution is to disable checksums and rerun
>> fsck. Checksums can be renabled later.
>>
>> The problem started with the segfault when activating indexed-dirs.
>> Do you have the coredump?
> I met with segfault when enabling indexed-dirs severl months ago. They are still pending for review and integration.
> http://oss.oracle.com/pipermail/ocfs2-tools-devel/2010-September/003574.html
>
> Regards,
> Tao
>>
>> On 01/12/2011 07:46 AM, Massimo Cetra wrote:
>>> Hi List,
>>>
>>> i'd like to share with you what happened yesterday.
>>>
>>> Kernel 2.6.36.1
>>> ocfs2-tools 1.6.3 (latest).
>>>
>>> I had an old OCFS2 partition created with a 2.6.32 kernel and ocfs2
>>> tools 1.4.5.
>>>
>>> I unmounted all partitions on all nodes in order to enable discontig-bg.
>>>
>>> I then used tunefs to add discontig-bg, inline-data and indexed-dirs.
>>>
>>> During indexed-dirs tunefs segfaulted and since then, fsck didn't work
>>> anymore.
>>>
>>> I managed to mount the partition again but after some errors like the
>>> following
>>>
>>> Jan 11 23:11:56 www1 kernel: [ 2339.642683]
>>> (mc,3305,0):ocfs2_block_check_validate:443 ERROR: CRC32 failed: stored:
>>> 0x76176db1, computed 0x9e4c2434. Applying ECC.
>>> Jan 11 23:11:56 www1 kernel: [ 2339.645074]
>>> (mc,3305,0):ocfs2_block_check_validate:457 ERROR: Fixed CRC32 failed:
>>> stored: 0x76176db1, computed 0x91119fb2
>>> Jan 11 23:11:56 www1 kernel: [ 2339.647196]
>>> (mc,3305,0):ocfs2_validate_extent_block:903 ERROR: Checksum failed for
>>> extent block 6924877
>>> Jan 11 23:11:56 www1 kernel: [ 2339.649212]
>>> (mc,3305,0):__ocfs2_find_path:1837 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.650409]
>>> (mc,3305,0):ocfs2_remove_rightmost_path:3090 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.651719]
>>> (mc,3305,0):ocfs2_rotate_tree_left:3225 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.653076]
>>> (mc,3305,0):ocfs2_truncate_rec:5442 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.654272]
>>> (mc,3305,0):ocfs2_remove_extent:5526 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.655531]
>>> (mc,3305,0):ocfs2_remove_btree_range:5717 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.656908]
>>> (mc,3305,0):ocfs2_commit_truncate:7117 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.658152]
>>> (mc,3305,0):ocfs2_truncate_for_delete:622 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.659423]
>>> (mc,3305,0):ocfs2_wipe_inode:793 ERROR: status = -5
>>> Jan 11 23:11:56 www1 kernel: [ 2339.660700]
>>> (mc,3305,0):ocfs2_delete_inode:1085 ERROR: status = -5
>>>
>>>
>>> Jan 11 23:15:41 www1 kernel: [ 2565.101905] OCFS2: ERROR (device drbd1):
>>> ocfs2_commit_truncate: Inode 7418891 has an empty extent record, depth 2
>>> Jan 11 23:15:41 www1 kernel: [ 2565.101908].
>>> Jan 11 23:15:41 www1 kernel: [ 2565.105104] File system is now read-only
>>> due to the potential of on-disk corruption. Please run fsck.ocfs2 once
>>> the file system is unmounted.
>>> Jan 11 23:15:41 www1 kernel: [ 2565.108155]
>>> (kworker/u:3,3361,0):ocfs2_truncate_for_delete:622 ERROR: status = -30
>>> Jan 11 23:15:41 www1 kernel: [ 2565.110190]
>>> (kworker/u:3,3361,0):ocfs2_wipe_inode:793 ERROR: status = -30
>>> Jan 11 23:15:41 www1 kernel: [ 2565.111772]
>>> (kworker/u:3,3361,0):ocfs2_delete_inode:1085 ERROR: status = -30
>>> Jan 11 23:15:41 www1 kernel: [ 2565.134131] OCFS2: ERROR (device drbd1):
>>> ocfs2_commit_truncate: Inode 7418889 has an empty extent record, depth 2
>>> Jan 11 23:15:41 www1 kernel: [ 2565.134133].
>>>
>>> i wasn't able to mount the filesystem anymore in RW.
>>> I could mount only in RO.
>>>
>>> fsck was failing like this:
>>>
>>> www1:~# fsck.ocfs2 -f /dev/drbd1
>>> fsck.ocfs2 1.6.3
>>> Checking OCFS2 filesystem in /dev/drbd1:
>>>      Label:              www-code
>>>      UUID:               03F008AFA8BA458E9C8614A9B4A3E6E8
>>>      Number of blocks:   26213582
>>>      Block size:         2048
>>>      Number of clusters: 13106791
>>>      Cluster size:       4096
>>>      Number of slots:    8
>>>
>>> /dev/drbd1 was run with -f, check forced.
>>> Pass 0a: Checking cluster allocation chains
>>> Pass 0b: Checking inode allocation chains
>>> Pass 0c: Checking extent block allocation chains
>>> Pass 1: Checking inodes and blocks.
>>> extent.c: I/O error on channel reading extent block at 9590812 in owner
>>> 3231503 for verification
>>> extent.c: I/O error on channel reading extent block at 6924320 in owner
>>> 3231503 for verification
>>> pass1: I/O error on channel while iterating over the blocks for inode
>>> 3231503
>>> fsck.ocfs2: I/O error on channel while performing pass 1
>>> www1:~#
>>>
>>> -----------------------------------------------
>>>
>>> It was late and i didn't have time to investigate more on a production
>>> server so i did a complete backup, used mkfs to wipe everything and
>>> restore the backup.
>>>
>>> I'm sorry i can't provide more data on the problem. I tried to google
>>> and search the mailing list archives but i didn't find anything interesting.
>>>
>>> Obviously i was quite disappointed by this problem and i hope those
>>> informations may, in some way, help identifying and fix the problem.
>>>
>>> Thanks for your work,
>>>
>>> Massimo
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
