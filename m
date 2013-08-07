From: David Weber <wb@munzinger.de>
Date: Wed, 07 Aug 2013 11:17:42 +0200
Subject: [Ocfs2-devel] FIEMAP problem
Message-ID: <3326454.f4rt6OEXV7@o3-3>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

We are trying to use OCFS2 as VM storage. After running into problems with 
qemu's disk_mirror feature we now think there could be a problem with the 
FIEMAP ioctl in OCFS2.

As far as I understand the situation looks like this:
Qemu inquiries the FS if the given section of the image is already allocated 
via the FIEMAP ioctl [1]
It especially checks if fm_mapped_extents is greater 0.
OCFS2 reports on sections bigger 1048576 there would be 0 mapped_extents which 
is wrong.

I extended a userspace FIEMAP util [2] a bit to specify the start and length 
parameter [3] as an easier testcase.

When we create a big file which has no holes
dd if=/dev/urandom of=/mnt/kvm-images/urandom.img bs=1M count=1000

We get on lower sections the expected output:
./a.out /mnt/kvm-images/urandom.img 10000 10
start: 2710, length: a
File /mnt/kvm-images/urandom.img has 1 extents:
#       Logical          Physical         Length           Flags
0:      0000000000000000 0000004ca3f00000 000000000be00000 0000

But on sections >= 1048576 it reports there wouldn't be any extents which is 
as far as I understand wrong:
./a.out /mnt/kvm-images/urandom.img 1048576 10
start: 100000, length: a
File /mnt/kvm-images/urandom.img has 0 extents:
#       Logical          Physical         Length           Flags


We're running linux-3.11-rc4 plus the following patches:
[PATCH V2] ocfs2: update inode size after zeroed the hole
[PATCH RESEND] ocfs2: fix NULL pointer dereference in 
ocfs2_duplicate_clusters_by_page
NULL pointer dereference at	ocfs2_dir_foreach_blk_id
[patch v3] ocfs2: ocfs2: fix recent memory corruption bug

o2info --volinfo  /dev/drbd0 
       Label: kvm-images
        UUID: BE7C101466AD4F2196A849C7A6031263
  Block Size: 4096
Cluster Size: 1048576
  Node Slots: 8
    Features: backup-super strict-journal-super sparse extended-slotmap 
    Features: inline-data xattr indexed-dirs refcount discontig-bg unwritten

Thanks in advance!

Cheers,
David


[1] http://git.qemu.org/?p=qemu.git;a=blob;f=block/raw-posix.c;h=ba721d3f5bd98a6b62791c2e20dbf2894021ad76;hb=HEAD#l1087

[2] http://smackerelofopinion.blogspot.de/2010/01/using-fiemap-ioctl-to-get-file-extents.html

[3] https://gist.github.com/anonymous/6172331
