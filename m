From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Tue Apr 13 18:49:47 2004
Subject: [Ocfs2-devel] 
	FW: [Bug 55] New: Ungracefull handling of mounting with a bad
	journal file
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E03EA01D2@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Started looking deeper into the 2.6 port wackiness around mounting, and
realized that part of the problem relates to both 2.4 and 2.6, so here
is a bug that isolates the general problem of ungracefully failing a
mount when a bad journal file is detected.

-----Original Message-----
From: bugzilla-daemon@oss.oracle.com
[mailto:bugzilla-daemon@oss.oracle.com] 
Sent: Tuesday, April 13, 2004 3:57 PM
To: Lynch, Rusty
Subject: [Bug 55] New: Ungracefull handling of mounting with a bad
journal file

http://oss.oracle.com/bugzilla/show_bug.cgi?id=55

           Summary: Ungracefull handling of mounting with a bad journal
file
           Product: OCFS v2 (WIP)
           Version: unspecified
          Platform: PC
        OS/Version: other
            Status: NEW
          Severity: normal
          Priority: P2
         Component: stability
        AssignedTo: kurt.hackel@oracle.com
        ReportedBy: rusty.lynch@intel.com


The 2.6 kernel already has a bug documenting a crash that occurs
sometimes
when mounting a volume, see bug #54, "[kernel 2.6 porting] system halt
when
mount a ocfs volume...",
which basically comes down to ocfs not generating a proper journal file.

If the scope of bug #54 is limited to "why is the 2.6 port messing up
the
journal file?", then this bug is covering the ungracefull failure while
mounting a journal with a bad journal file.

To reproduce the bug on a 2.4 system ==>

Step 1: Make a fresh ocfs2 volume
Step 2: Mount the volume
Step 3: Unmount the volume
Step 4: Clear the journal magic number (Details below)

First, find the disk offset of the journal file using debugocfs

[root@ocfs1 root]# debugocfs -c 0 /dev/sda1
debugocfs 1.1.1-BETA2 Thu Mar 25 19:20:23 PST 2004 (build
fcb0206676afe0fcac47a99c90de0e7b)
cleanup_log_0:
        file_number = 224
        disk_offset = 1482752
        curr_master = 0
        file_lock = OCFS_DLM_ENABLE_CACHE_LOCK
        oin_node_map = 10000000000000000000000000000000
        seq_num = 0
        local_ext = true
        granularity = -1
        filename = CleanUpLogFile224
        filename_len = 0
        file_size = 8388608
        alloc_size = 8388608
        attribs =
        prot_bits =
        uid = 0
        gid = 0
        create_time = Wed Dec 31 16:00:00 1969
        modify_time = Wed Dec 31 16:00:00 1969
        dir_node_ptr = 0
        this_sector = 1482752
        last_ext_ptr = 0
        sync_flags = OCFS_SYNC_FLAG_VALID
        link_cnt = 0
        next_del = 0
        next_free_ext = 1
        extent[0].file_off = 0
        extent[0].num_bytes = 8388608
        extent[0].disk_off = 7790592
        extent[1].file_off = 0
        extent[1].num_bytes = 0
        extent[1].disk_off = 0
        extent[2].file_off = 0
        extent[2].num_bytes = 0
        extent[2].disk_off = 0
 
        file_size = 8388608
        alloc_size = 8388608
        log_id = 288230376151711744
        log_type = unknown log type (0)


From above, we see that the file data starts at offset 7790592 
(extent[0].disk_off), which is 0x76e000 in hexadecimal.

Now use a hex editor to directly edit the partition.  I use hexedit by
typing:
hexedit /dev/sda1

...and then press control-g and then type 0x75e000 to have the editor
take me to the correct offset.  You should see "c0 3b 39 98" (the
JFS_MAGIC_NUMBER). 

Use the hexeditor to zero out the magic number.  With hexedit just press
0 eight times and then control-X to exit and save.

Step 5: Attempt to mount the volume again

The mount command will fail with the following in dmesg...

(2795) ENTRY: ocfs_check_volume() 
(2795) ENTRY: ocfs_journal_init() 
lockres: lockid=1482752.0, this=0, master=0, locktype=8, flags=40004001,
ronode=-1, romap=00000000
new_lock_function: set lockid=1482752.0, locktype=8->2, master=0->0
(2795) TRACE: ocfs_journal_init() fe->file_size = 0.8388608
(2795) TRACE: ocfs_journal_init() fe->alloc_size = 0.8388608
(2795) TRACE: ocfs_journal_init() fe->this_sector = 0.1482752
(2795) TRACE: ocfs_journal_init() inode->i_size = 8388608
(2795) TRACE: ocfs_journal_init() oin->alloc_size = 0.8388608
(2795) TRACE: ocfs_journal_init() Returned from journal_init_inode
(2795) TRACE: ocfs_journal_init() k_journal->j_maxlen = 16384
(2795) EXIT : ocfs_journal_init() = 0 
(2795) TRACE: ocfs_check_volume() Node config states a journal version
of 1
(2795) ENTRY: ocfs_journal_wipe() 
JBD: no valid journal superblock found
(2795) EXIT : ocfs_journal_wipe() = -22 
(2795) ERROR: status = -22, osb.c, 407
(2795) EXIT : ocfs_check_volume() = -22 
(2795) ERROR: status = -22, super.c, 1024
(2795) EXIT : ocfs_mount_volume() = -22 
(2795) EXIT : __ocfs_read_super() = -22 
------------[ cut here ]------------
kernel BUG at ll_rw_blk.c:1027!
invalid operand: 0000
sd_mod ocfs2 parport_pc lp parport autofs nfs lockd sunrpc e100
ipt_REJECT
ipt_state ip_conntrack iptable_filter ip_tables floppy sg sr_mod
microcode sbp2 ide
CPU:    0
EIP:    0060:[<c01bda27>]    Not tainted
EFLAGS: 00010246

EIP is at __make_request [kernel] 0xb7 (2.4.22-1.2115.nptl)
eax: 0000000c   ebx: 00000000   ecx: 00000000   edx: cc4d9880
esi: 00000001   edi: 000620b9   ebp: cfc16214   esp: cc59bdd8
ds: 0068   es: 0068   ss: 0068
Process ocfs2nm-0 (pid: 2797, stackpage=cc59b000)
Stack: 0000006d cd4ca880 cd4ca880 cd46b6b8 00000000 cd46b600 d09e2460
ccb79e80 
       cf6f0980 00000080 00000000 00000000 cfc16244 000007f9 00000000
00000001 
       0000002a cc59be54 cc4d9880 00000001 000620b9 0000002a c01be1ea
cfc16214 
Call Trace:   [<d09e2460>] ocfs_bh_sem_lookup [ocfs2] 0x134 (0xcc59bdf0)
[<c01be1ea>] generic_make_request [kernel] 0xda (0xcc59be30)
[<d09e27f3>] ocfs_bh_sem_unlock [ocfs2] 0x2f (0xcc59be40)
[<c01be297>] submit_bh [kernel] 0x57 (0xcc59be58)
[<c011b389>] context_switch [kernel] 0x79 (0xcc59be70)
[<d09ea9ec>] ocfs_read_bhs [ocfs2] 0x5b0 (0xcc59be80)
[<d09e28e4>] ocfs_bh_sem_hash_prune [ocfs2] 0xdc (0xcc59bec0)
[<d09f8a5c>] ocfs_volume_thread [ocfs2] 0x294 (0xcc59bee0)
[<c0119c51>] schedule [kernel] 0x31 (0xcc59bf88)
[<c0109c4d>] reschedule [kernel] 0x5 (0xcc59bfc0)
[<d09f87c8>] ocfs_volume_thread [ocfs2] 0x0 (0xcc59bfe0)
[<c010741d>] kernel_thread_helper [kernel] 0x5 (0xcc59bff0)


Code: 0f 0b 03 04 44 4f 29 c0 8b 4c 24 64 8b 15 f0 f8 3d c0 8b 41 

At this point (unlike a debug build of the 2.6 kernel) the system is
still 
running until you try to either:
* mount the volume again
* unload the ocfs2 module
* shutdown

... then the system hangs.



------- You are receiving this mail because: -------
You reported the bug, or are watching the reporter.
