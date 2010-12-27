From: Tao Ma <tm@tao.ma>
Date: Mon, 27 Dec 2010 23:48:30 +0800
Subject: [Ocfs2-devel] disk full when it shouldn't
In-Reply-To: <4D18A327.7030709@navynet.it>
References: <4CD813D3.4080106@navynet.it>
	<4CD89E86.5010404@oracle.com>	<4CF7D578.1060201@navynet.it>
	<4CF84658.8040002@oracle.com> <4D18A327.7030709@navynet.it>
Message-ID: <4D18B54E.1030203@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Massimo,
On 12/27/2010 10:31 PM, Massimo Cetra wrote:
>
> Il 03/12/2010 02:22, Tao Ma ha scritto:
>> I have to say that df is only an approximate way to get the real info
>> of an ocfs2 volume.
>> df -i use statfs(2). And since there is no easy way to calculate all
>> the inodes without
>> locking every node's inode allocator, it just searchs the
>> global_bitmap and gives a rough number.
>>
>>>
>>> The filesystem was not full:
>>>
>>> sheet3-1:/var/mail/virtual# dd if=/dev/zero of=TEST bs=1024 count=1024
>>> dd: scrittura di `TEST': No space left on device
>>> 1009+0 records in
>>> 1008+0 records out
>>> 1032192 bytes (1,0 MB) copied, 0,454305 s, 2,3 MB/s
>>> sheet3-1:/var/mail/virtual#
>> So this is node2? From the stat_sysdir output you attached,
>> inode_alloc:0001 is full.
>> It has no free inodes and the creation will fail.
>>
>> So you are meeting with the problem of fragmentation. Discontig block
>> group should fix it.
>>
>
> Hi Tao,
>
> back again.
>
  > I have decided to install 2.6.36.1 on all clusters to see if the
> fragmentation problem has gone.
>
> Unfortunately the problem persists, even if with different sympthoms.
>
> Last week i had the same enospace problem but this time it was
> consistent on both nodes (on both of them i couldn't even "touch" a
> single file".
> Previously i was able to touch it and sometimes to write several Mb to a
> single file.
>
> This time df was reporting about 49% of disk usage.
>
> I'm attaching the stat_sysdir output for both nodes. Kernel is a vanilla
> 2.6.36.1.
>
> Am i missing something ?
> Is this fragmentation ?
yes, it is, I have checked your attached statsysdir output.
> Did i hit a bug or rhe problem is between the keyboard and the chair ?
oh, it isn't that easy by just upgrading the kernel. ;)
So you have to enable that feature by tunefs.ocfs2. I am afraid Oracle 
didn't release a new ocfs2-tools now(I had left Oracle and I don't know 
the release detail now), so you need to download the latest source and 
compile the ocfs2-tools by yourself.
git clone git://oss.oracle.com/git/ocfs2-tools.git
and after you compile it, just do
tunefs.ocfs2 --fs-features=discontig-bg /dev/sdx.
And you will enable this feature(it will require you to umount the 
volume among all the nodes) and enjoy it.:)
>
> Thanks for your help.
>
> Massimo
>
> P.S.: if you could explain how to interpret the stat_sysdir output i
> could be less tedius and write less mails!
ok. So you can check inode_alloc:000x which is used to create inodes. 
And in your case, both inode_alloc:0000 and inode_alloc:0001 is 
full(check the line "Bitmap" for these inode_allocs), so no new file can 
be created now.

Regards,
Tao
