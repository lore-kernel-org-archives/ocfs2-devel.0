From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 07 Aug 2013 22:07:19 +0800
Subject: [Ocfs2-devel] FIEMAP problem
In-Reply-To: <3326454.f4rt6OEXV7@o3-3>
References: <3326454.f4rt6OEXV7@o3-3>
Message-ID: <52025497.1090608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/07/2013 05:17 PM, David Weber wrote:

> Hi,
> 
> We are trying to use OCFS2 as VM storage. After running into problems with 
> qemu's disk_mirror feature we now think there could be a problem with the 
> FIEMAP ioctl in OCFS2.
> 
> As far as I understand the situation looks like this:
> Qemu inquiries the FS if the given section of the image is already allocated 
> via the FIEMAP ioctl [1]
> It especially checks if fm_mapped_extents is greater 0.
> OCFS2 reports on sections bigger 1048576 there would be 0 mapped_extents which 
> is wrong.
> 
> I extended a userspace FIEMAP util [2] a bit to specify the start and length 
> parameter [3] as an easier testcase.
> 
> When we create a big file which has no holes
> dd if=/dev/urandom of=/mnt/kvm-images/urandom.img bs=1M count=1000
> 
> We get on lower sections the expected output:
> ./a.out /mnt/kvm-images/urandom.img 10000 10
> start: 2710, length: a
> File /mnt/kvm-images/urandom.img has 1 extents:
> #       Logical          Physical         Length           Flags
> 0:      0000000000000000 0000004ca3f00000 000000000be00000 0000
> 
> But on sections >= 1048576 it reports there wouldn't be any extents which is 
> as far as I understand wrong:
> ./a.out /mnt/kvm-images/urandom.img 1048576 10
> start: 100000, length: a
> File /mnt/kvm-images/urandom.img has 0 extents:
> #       Logical          Physical         Length           Flags

Thanks for your report, looks this problem has existed over years.
As a quick response, could you please try the below fix?

From: Jie Liu <jeff.liu@oracle.com>

Call fiemap ioctl(2) with given start offset as well as an desired
mapping range should show extents if possible.  However, we calculate
the end offset of mapping via 'mapping_end -= cpos' before iterating
the extent records which would cause problems, e.g,

Cluster size 4096:
debugfs.ocfs2 1.6.3
        Block Size Bits: 12   Cluster Size Bits: 12

The extended fiemap test utility From David:
https://gist.github.com/anonymous/6172331

# dd if=/dev/urandom of=/ocfs2/test_file bs=1M count=1000
# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 0 extents:
#	Logical          Physical         Length           Flags
	^^^^^ <-- No extents

In this case, at ocfs2_fiemap(): cpos == mapping_end == 1. Hence the
loop of searching extent records was not executed at all.

This patch remove the in question 'mapping_end -= cpos', and loops
until the cpos is larger than the mapping_end instead.

# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000056a01000 0000000006a00000 0000

Reported-by: David Weber <wb@munzinger.de>
Cc: Mark Fashen <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/extent_map.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 2487116..8460647 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -781,7 +781,6 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
 					       map_start + map_len);
-	mapping_end -= cpos;
 	is_last = 0;
 	while (cpos < mapping_end && !is_last) {
 		u32 fe_flags;
-- 
1.7.9.5



> 
> We're running linux-3.11-rc4 plus the following patches:
> [PATCH V2] ocfs2: update inode size after zeroed the hole
> [PATCH RESEND] ocfs2: fix NULL pointer dereference in 
> ocfs2_duplicate_clusters_by_page
> NULL pointer dereference at	ocfs2_dir_foreach_blk_id
> [patch v3] ocfs2: ocfs2: fix recent memory corruption bug
> 
> o2info --volinfo  /dev/drbd0 
>        Label: kvm-images
>         UUID: BE7C101466AD4F2196A849C7A6031263
>   Block Size: 4096
> Cluster Size: 1048576
>   Node Slots: 8
>     Features: backup-super strict-journal-super sparse extended-slotmap 
>     Features: inline-data xattr indexed-dirs refcount discontig-bg unwritten
> 
> Thanks in advance!
> 
> Cheers,
> David
> 
> 
> [1] http://git.qemu.org/?p=qemu.git;a=blob;f=block/raw-posix.c;h=ba721d3f5bd98a6b62791c2e20dbf2894021ad76;hb=HEAD#l1087
> 
> [2] http://smackerelofopinion.blogspot.de/2010/01/using-fiemap-ioctl-to-get-file-extents.html
> 
> [3] https://gist.github.com/anonymous/6172331
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
