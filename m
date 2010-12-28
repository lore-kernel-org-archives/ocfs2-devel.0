From: Massimo Cetra <ctrixk@navynet.it>
Date: Tue, 28 Dec 2010 12:38:32 +0100
Subject: [Ocfs2-devel] disk full when it shouldn't
In-Reply-To: <4D18B54E.1030203@tao.ma>
References: <4CD813D3.4080106@navynet.it>
	<4CD89E86.5010404@oracle.com>	<4CF7D578.1060201@navynet.it>
	<4CF84658.8040002@oracle.com> <4D18A327.7030709@navynet.it>
	<4D18B54E.1030203@tao.ma>
Message-ID: <4D19CC38.9030703@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Il 27/12/2010 16:48, Tao Ma ha scritto:
> oh, it isn't that easy by just upgrading the kernel. ;)
> So you have to enable that feature by tunefs.ocfs2. I am afraid Oracle 
> didn't release a new ocfs2-tools now(I had left Oracle and I don't 
> know the release detail now), so you need to download the latest 
> source and compile the ocfs2-tools by yourself.
> git clone git://oss.oracle.com/git/ocfs2-tools.git
> and after you compile it, just do
> tunefs.ocfs2 --fs-features=discontig-bg /dev/sdx.
> And you will enable this feature(it will require you to umount the 
> volume among all the nodes) and enjoy it.:)

Oh perfect.
Thanks, i really didn't realize that fs_discontig was a flag.
The old tools didn't report it in the docs so i didn't find it anywhere.

Now: sorry to be so annoying but i have googled without success ( i only 
found the patch that adds the following error).

I cannot find nor the reason for this error:

tunefs.ocfs2: Chain allocator is corrupt while opening device "/dev/drbd2"

Nor the cause, anywhere.
fsck doesn't seems to find the problem.

Thanks again. I hope thise questions will help other people as well.

Massimo


----------------------------------------------

sheet3-1:~# tunefs.ocfs2 --fs-features=discontig-bg /dev/drbd2
tunefs.ocfs2: Chain allocator is corrupt while opening device "/dev/drbd2"

sheet3-1:~# fsck.ocfs2 /dev/drbd2
fsck.ocfs2 1.6.3
Checking OCFS2 filesystem in /dev/drbd2:
   Label:              mail-storage
   UUID:               7BB7636E26A7457192657E6521A5AFDC
   Number of blocks:   9174751
   Block size:         4096
   Number of clusters: 9174751
   Cluster size:       4096
   Number of slots:    4

/dev/drbd2 is clean.  It will be checked after 20 additional mounts.
