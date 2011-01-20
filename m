From: Tao Ma <tm@tao.ma>
Date: Thu, 20 Jan 2011 21:59:47 +0800
Subject: [Ocfs2-devel] useless tools - tunefs.ocfs2,fsck.ocfs2
In-Reply-To: <4D383BDC.4050400@mp.pl>
References: <4D383BDC.4050400@mp.pl>
Message-ID: <4D383FD3.7000602@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/20/2011 09:42 PM, Pawel wrote:
>    One of ocfs2 filesystem has some errors.
> 1. fsck.ocfs2  informs me that :    "I/O error on channel while reading
> .. " It was NOT TRUE - I was able to read and write  entire storage over
> the network multiple times.
It means it meet I/O error in some ocfs2 disk structure, not the disk.
> 2. becouse of CRC  errors and suggestion to disable metaecc I run
> tunefs.ocfs2 --fs-features=nometaecc /dev/xxx
> funefs allocate 9,89 GB of virtual memory and 95% of phisical memory
> (4GB). After 4 hours process has been killed - because of out of memory.
>
> I have to recreate new filesystem and restore data from backup.
>
> I try to use tools in version 1.4  and 1.6 (newest)
> Filesystem is quite small 250GB and less than 10 000 files, exported by aoe.
> Additionally  on the new clean FS -  running tunefs.ocfs2
> --fs-features=nosparse behave in the same way
I knew a similar bug in fsck.ocfs2, but didn't meet any similar issue in 
tunefs.ocfs2.
The bug in fsck is fixed by b987ee2 "fsck.ocfs2: Only ask available 
pages in o2fsck_init_cache."

A new clean FS will cause so much memory, strange?
would you mind run o2image and give us the image?
Then I can test it locally.
anyway, thanks for the test.

Regards,
Tao
