From: Gang He <ghe@suse.com>
Date: Tue, 28 Apr 2015 03:44:53 -0600
Subject: [Ocfs2-devel] Failed to upgrade ocfs2-tools to v1.8.4
Message-ID: <553FC715020000F9000082BB@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn and all,

I think that I have got the root cause, which let the test case run_backup_super() failed.
the test case failure was caused by execute the command "debugfs.ocfs2 /dev/mapper/cluster--vg1-big--lv -s 1"

+ /usr/bin/sudo -u root /usr/sbin/debugfs.ocfs2 /dev/mapper/cluster--vg1-big--lv -s 1
open: Device name specified was not found Can't get the blocksize from the device by the num 1

Now, let us look at the related backtrace under ocfs2-tools v1.8.3 (this version is good)
(gdb) bt
#0  get_blocksize (dev=0x65feb0 "/dev/mapper/cluster--vg1-big--lv", offset=1073741824, blocksize=0x7fffffffdf88, super_no=1) at commands.c:476  <<== pls note dev argument is OK
#1  0x0000000000404ea9 in process_open_args (args=0x65fe80, superblock=0x7fffffffe028, blocksize=0x7fffffffe020) at commands.c:567
#2  0x0000000000405230 in do_open (args=0x65fe80) at commands.c:679
#3  0x000000000040476f in do_command (cmd=0x65f0f0 "open /dev/mapper/cluster--vg1-big--lv -s 1") at commands.c:346
#4  0x00000000004043dc in main (argc=4, argv=0x7fffffffe218) at main.c:491

look at the related backtrace under ocfs2-tools v1.8.4
(gdb) bt
#0  get_blocksize (dev=0x65feb0 "-s", offset=1073741824, blocksize=0x7fffffffdff8, super_no=1) at commands.c:476  <<== pls note dev argument is not a device name, this is why the command will fail
#1  0x0000000000404f0d in process_open_args (args=0x65fe80, superblock=0x7fffffffe098, blocksize=0x7fffffffe090) at commands.c:567
#2  0x00000000004052a0 in do_open (args=0x65fe80) at commands.c:680
#3  0x00000000004047d3 in do_command (cmd=0x65f0f0 "open /dev/mapper/cluster--vg1-big--lv -s 1") at commands.c:346
#4  0x0000000000404440 in main (argc=4, argv=0x7fffffffe288) at main.c:492

then, look at the latest code changes from git log
commit 9233fb7eca586de1cad82488ef4a60dbf245f034
Author: Srinivas Eeda <srinivas.eeda@oracle.com>
Date:   Fri Jan 30 12:51:45 2015 -0800
    tools: Up version to 1.8.4
    Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
commit 9693851641bfcd0f2bab226e9f03d9ab05cb7edf
Author: piaojun <piaojun@huawei.com>
Date:   Sun Feb 15 08:51:45 2015 +0800
    debugfs.ocfs2: Fix memory leak problem in process_open_args() & main()  <<== here, the related code is modified.

526 static int process_open_args(char **args,
 527                  uint64_t *superblock, uint64_t *blocksize)
 528 {
 529     errcode_t ret = 0;
 530     uint32_t s = 0;
 531     char *ptr, *dev;
 532     uint64_t byte_off[OCFS2_MAX_BACKUP_SUPERBLOCKS];
 533     uint64_t blksize = 0;
 534     int num, argc, c;
 535
 536     for (argc = 0; (args[argc]); ++argc);
 537     optind = 0;
 538     while ((c = getopt(argc, args, "is:")) != EOF) {
 539         switch (c) {
 540             case 'i':
 541                 gbls.imagefile = 1;
 542                 break;
 543             case 's':
 544                 s = strtoul(optarg, &ptr, 0);
 545                 break;
 546             default:
 547                 return 1;
 548                 break;
 549         }
 550     }
 551
 552     if (!s)
 553         return 0;
 554
 555     num = ocfs2_get_backup_super_offsets(NULL, byte_off,
 556                          ARRAY_SIZE(byte_off));
 557     if (!num)
 558         return -1;
 559
 560     if (s < 1 || s > num) {
 561         fprintf(stderr, "Backup super block is outside of valid range"
 562             "(between 1 and %d)\n", num);
 563         return -1;
 564     }
 565
 566     dev = strdup(args[1]);     <<== pls note this line is moved here from line 537, but actually the args[] is changed by code (getopt()?), then the fix bring this issue, pls move this line back to line 537 and consider the memory leak problem again.     
 567     ret = get_blocksize(dev, byte_off[s-1], &blksize, s);
 568     if (ret) {
 569         com_err(args[0],ret, "Can't get the blocksize from the device"
 570             " by the num %u\n", s);
 571         goto bail;
 572     }
 573
 574     *blocksize = blksize;
 575     *superblock = byte_off[s-1]/blksize;


Thanks
Gang


>>> 
> Hi Goldwyn,
> 
> I did a upgrade ocfs2-tools to v1.8.4, the code change is here,
> https://api.opensuse.org/package/rdiff/home:ganghe:branches:network:ha-clust 
> ering:Factory/ocfs2-tools?opackage=ocfs2-tools&oproject=network%3Aha-clusteri
> ng%3AFactory&rev=3
> 
> But, the new build cannot pass the run_backup_super() test case, the 
> previous build v1.8.3 is OK.
> if you have time, please take a glance, I also continue to look at why this 
> case failed.
> The run_back_super() test failure log is attached.
> the code diff between v.1.8.3 and v1.8.4 is attached.
> the code diff between upstream and v1.8.4 is attached.
> tools/test packages are attached
> 
> 
> 
>  
> 
> 
> Thanks
> Gang
> 
> 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: run_back_super_failure.log
Type: application/octet-stream
Size: 11667 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150428/eace5abe/attachment-0003.obj 
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: v1.8.3_v1.8.4.diff
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150428/eace5abe/attachment.pl 
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: upstream_v1.8.4.diff
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150428/eace5abe/attachment-0001.pl 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-tools-1.8.3+git.1418704844.65fac00-85.1.x86_64.rpm
Type: application/octet-stream
Size: 480223 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150428/eace5abe/attachment-0004.obj 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-tools-1.8.4-87.1.x86_64.rpm
Type: application/octet-stream
Size: 481924 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150428/eace5abe/attachment-0005.obj 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-test.tgz
Type: application/x-compressed
Size: 4367016 bytes
Desc: GZIP
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150428/eace5abe/attachment-0001.bin 
