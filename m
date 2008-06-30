From: Coly Li <coyli@suse.de>
Date: Mon, 30 Jun 2008 18:45:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix oops in mmap_truncate testing
Message-ID: <4868B959.7000106@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes a mmap_truncate bug which was found by ocfs2 test suite.

In an ocfs2 cluster more than 1 node, run program mmap_truncate compiled from bellow source code:
mmap_truncate.c:
============================================
#define _XOPEN_SOURCE 500
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>
#include <sys/mman.h>
#include <signal.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define DEFAULT_CSIZE_BITS      12

static unsigned int clustersize_bits = DEFAULT_CSIZE_BITS;
#define clustersize             (1 << clustersize_bits)
static char *fname;
static void *mapped;
static unsigned int seconds = 300;

static void usage(void)
{
         printf("Usage: mmap_truncate [-c csize_bits] [-s seconds] FILE\n\n"
                "Stress file system stability by testing end of file boundary\n"
                "conditions with mmap by racing truncates and writes to a\n"
                "shared writeable region.\n\n"
                "FILE\ta path to a file that will be created and truncated if "
                "it already exists.\n"
                "-c\tsets the fs clustersize used by the test.\n"
                "\tThe default is to use a csize_bits of 12 (4096 bytes).\n"
                "-s\tsets the number of seconds to run the test.\n"
                "\tThe default is to run for 300 seconds.\n");
         exit(0);
}

static int parse_opts(int argc, char **argv)
{
         int c;

         while (1) {
                 c = getopt(argc, argv, "c:s:");
                 if (c == -1)
                         break;

                 switch (c) {
                 case 'c':
                         clustersize_bits = atoi(optarg);
                         break;
                 case 's':
                         seconds = atoi(optarg);
                         break;
                 default:
                         return EINVAL;
                 }
         }

         if (argc - optind != 1)
                 return EINVAL;

         fname = argv[optind];

         return 0;
}

int main(int argc, char *argv[])
{
         int ret, fd;
         unsigned long trunc_size, file_size;
         unsigned long offset;

         if (argc < 2) {
                 usage();
                 return 1;
         }

         ret = parse_opts(argc, argv);
         if (ret) {
                 usage();
                 return 1;
         }

         file_size = 2 * clustersize;
         trunc_size = file_size - clustersize;
         fd = open(fname, O_RDWR|O_CREAT|O_TRUNC,
                   S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
         ret = ftruncate(fd, file_size);
         mapped = mmap(0, file_size, PROT_WRITE, MAP_SHARED, fd, 0);
         offset = file_size - 1;
         memset(mapped + offset, 'a', 1);

         while(1);
         return 0;
}
============================================

If every node mounts ocfs2 partition on /mnt/lun, and run bellow command on one node,
/mmap_truncate -c 4096 /mnt/lun/TEST_FILE

while mmap_truncate running, execute stat on other node of the cluster as,
stat /mnt/lun/TEST_FILE

Now the node running mmap_truncate generates an oops message as listed:
============================================
Kernel BUG@fs/ocfs2/aops.c:180
invalid opcode: 0000 [1] SMP
last sysfs file: /o2cb/interface_revision
CPU 0
Modules linked in: ocfs2 ocfs2_dlmfs ocfs2_dlm ocfs2_nodemanager configfs ipv6
loop dm_mod ext3 jbd xenblk xennet
Pid: 2226, comm: ocfs2dc Tainted: G     U 2.6.16.60-xen #1
RIP: e030:[<ffffffff8812f35d>]
<ffffffff8812f35d>{:ocfs2:ocfs2_get_block+2071}RSP: e02b:ffff880009f79c20
EFLAGS: 00010282
RAX: 000000000000003b RBX: 0000000100020000 RCX: 00000000000016ea
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8033f69c
RBP: ffff880009bc2c38 R08: ffffffff8041e140 R09: 0000000000000020
R10: 0000000000000000 R11: 0000000100020000 R12: ffff880006e68ce8
R13: 0000000000000000 R14: 0000000000000001 R15: ffff880009bc2880
FS:  00002b23468d6e00(0000) GS:ffffffff803ad000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000
Process ocfs2dc (pid: 2226, threadinfo ffff880009f78000, task ffff88000f452850)
Stack: ffff880006e68ce8 0000000c8017bdd1 ffff88000d36a000 000000008017c557
        ffff8800011f58a0 ffff8800011f58a0 0000000000000001 0000000000000000
        0000000000000000 ffff880006e68ce8
Call Trace: <ffffffff8017d749>{__block_write_full_page+189}
        <ffffffff8812eb46>{:ocfs2:ocfs2_get_block+0}
<ffffffff8812e93e>{:ocfs2:ocfs2_writepage+112}
        <ffffffff8019d0e9>{mpage_writepages+416}
<ffffffff8812e8ce>{:ocfs2:ocfs2_writepage+0}
        <ffffffff80165899>{zap_page_range+211}
<ffffffff801ea66f>{prio_tree_next+274}
        <ffffffff80165919>{unmap_mapping_range_vma+86}
<ffffffff8015d47c>{do_writepages+41}
        <ffffffff801584f7>{__filemap_fdatawrite_range+81}
<ffffffff8813ce03>{:ocfs2:ocfs2_data_convert_worker+86}
        <ffffffff8813b130>{:ocfs2:ocfs2_downconvert_thread+1174}
        <ffffffff80140a6d>{autoremove_wake_function+0}
<ffffffff80140692>{keventd_create_kthread+0}
        <ffffffff8813ac9a>{:ocfs2:ocfs2_downconvert_thread+0}
        <ffffffff80140692>{keventd_create_kthread+0}
<ffffffff80140936>{kthread+212}
        <ffffffff8010ab44>{child_rip+10}
<ffffffff80140692>{keventd_create_kthread+0}
        <ffffffff80140862>{kthread+0} <ffffffff8010ab3a>{child_rip+0}

Code: 0f 0b 68 54 5f 16 88 c2 b4 00 48 8b 54 24 38 48 85 d2 74 26
RIP <ffffffff8812f35d>{:ocfs2:ocfs2_get_block+2071} RSP <ffff880009f79c20>
============================================

This patch fixed the bug by clear dirty and uptodate bits in buffer, leave the buffer unmapped and 
return.
Fix is suggested by Mark Fasheh, and I code up the patch.


Signed-off-by: Coly Li <coyli@suse.de>
Cc: Mark Fesheh <mfasheh@suse.com>
Cc: Sunil Mushran <Sunil.Mushran@oracle.com>
---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 17964c0..f59ebfd 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -169,15 +169,14 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
  	if (max_blocks < count)
  		count = max_blocks;

-	/*
-	 * ocfs2 never allocates in this function - the only time we
-	 * need to use BH_New is when we're extending i_size on a file
-	 * system which doesn't support holes, in which case BH_New
-	 * allows block_prepare_write() to zero.
+	/* In this case just clear the buffer's dirty and update bits, leave it
+	 * unmapped and return.
  	 */
-	mlog_bug_on_msg(create && p_blkno == 0 && ocfs2_sparse_alloc(osb),
-			"ino %lu, iblock %llu\n", inode->i_ino,
-			(unsigned long long)iblock);
+	if(create && p_blkno == 0 && ocfs2_sparse_alloc(osb)) {
+		clear_buffer_dirty(bh_result);
+		clear_buffer_uptodate(bh_result);
+		goto bail;
+	}

  	/* Treat the unwritten extent as a hole for zeroing purposes. */
  	if (p_blkno && !(ext_flags & OCFS2_EXT_UNWRITTEN))

-- 
Coly Li
SuSE PRC Labs
