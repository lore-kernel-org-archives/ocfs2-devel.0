From: Massimo Cetra <ctrixk@navynet.it>
Date: Mon, 27 Dec 2010 15:31:03 +0100
Subject: [Ocfs2-devel] disk full when it shouldn't
In-Reply-To: <4CF84658.8040002@oracle.com>
References: <4CD813D3.4080106@navynet.it> <4CD89E86.5010404@oracle.com>
	<4CF7D578.1060201@navynet.it> <4CF84658.8040002@oracle.com>
Message-ID: <4D18A327.7030709@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Il 03/12/2010 02:22, Tao Ma ha scritto:
> I have to say that df is only an approximate way to get the real info
> of an ocfs2 volume.
> df -i use statfs(2). And since there is no easy way to calculate all
> the inodes without
> locking every node's inode allocator, it just searchs the
> global_bitmap and gives a rough number.
>
>>
>> The filesystem was not full:
>>
>> sheet3-1:/var/mail/virtual# dd if=/dev/zero of=TEST bs=1024 count=1024
>> dd: scrittura di `TEST': No space left on device
>> 1009+0 records in
>> 1008+0 records out
>> 1032192 bytes (1,0 MB) copied, 0,454305 s, 2,3 MB/s
>> sheet3-1:/var/mail/virtual#
> So this is node2? From the stat_sysdir output you attached,
> inode_alloc:0001 is full.
> It has no free inodes and the creation will fail.
>
> So you are meeting with the problem of fragmentation. Discontig block
> group should fix it.
>

Hi Tao,

back again.

I have decided to install 2.6.36.1 on all clusters to see if the 
fragmentation problem has gone.

Unfortunately the problem persists, even if with different sympthoms.

Last week i had the same enospace problem but this time it was 
consistent on both nodes (on both of them i couldn't even "touch" a 
single file".
Previously i was able to touch it and sometimes to write several Mb to a 
single file.

This time df was reporting about 49% of disk usage.

I'm attaching the stat_sysdir output for both nodes. Kernel is a vanilla 
2.6.36.1.

Am i missing something ?
Is this fragmentation ?
Did i hit a bug or rhe problem is between the keyboard and the chair ?

Thanks for your help.

Massimo

P.S.: if you could explain how to interpret the stat_sysdir output i 
could be less tedius and write less mails!


-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: 23dic-OCFS-DRBD2-s2.txt
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101227/fc6941e2/attachment-0002.txt 
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: 23dic-OCFS-DRBD2-s1.txt
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101227/fc6941e2/attachment-0003.txt 
