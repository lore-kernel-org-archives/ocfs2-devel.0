From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 31 Mar 2016 12:26:56 +0800
Subject: [Ocfs2-devel] kernel BUG in function ocfs2_truncate_file
In-Reply-To: <56FD026B020000F90002FF77@prv-mh.provo.novell.com>
References: <56FAF066020000F900028BB2@prv-mh.provo.novell.com>
	<56FD026B020000F90002FF77@prv-mh.provo.novell.com>
Message-ID: <56FCA710.4060607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,
I haven't found any related information about this BUG.
Which kernel version are you using? It seems inode size mismatch between
disk and memory, so any further log about these?

Thanks,
Joseph

On 2016/3/31 10:56, Gang He wrote:
> Hello Joseph and Junxiao,
> 
> Did you encounter this issue in the past? I doubt this is possible a race condition bug (rather than data inconsistency).
> 
> Thanks
> Gang
> 
> 
>>>>
>> Hello Guys,
>>
>> I got a bug, which reported a kernel BUG in function ocfs2_truncate_file,
>> Base on my initial analysis, this bug looks like a race condition problem.
>> Unfortunately, there was no kernel crash dump caught, just got some kernel 
>> log as below,
>>
>> kernel BUG at /usr/src/packages/BUILD/ocfs2-1.6/default/ocfs2/file.c:466!
>> Oct 21 13:02:19 uii316 [ 1766.831230] Supported: Yes
>> Oct 21 13:02:19 uii316 [ 1766.831234]
>> Oct 21 13:02:19 uii316 [ 1766.831238] Pid: 7134, comm: saposcol Not tainted 
>> 3.0.101-0.47.67-default #1
>> Oct 21 13:02:19 uii316 HP ProLiant BL460c G1
>> Oct 21 13:02:19 uii316
>> Oct 21 13:02:19 uii316 [ 1766.831247] RIP: 0010:[<ffffffffa0744b95>]
>> Oct 21 13:02:19 uii316 [<ffffffffa0744b95>] ocfs2_truncate_file+0xa5/0x490 
>> [ocfs2]
>> Oct 21 13:02:19 uii316 [ 1766.831312] RSP: 0018:ffff880f39d79b68  EFLAGS: 
>> 00010296
>> Oct 21 13:02:19 uii316 [ 1766.831321] RAX: 000000000000008f RBX: 
>> ffff880f39c5e240 RCX: 00000000000039fd
>> Oct 21 13:02:19 uii316 [ 1766.831326] RDX: 0000000000000000 RSI: 
>> 0000000000000007 RDI: 0000000000000246
>> Oct 21 13:02:19 uii316 [ 1766.831331] RBP: 1000000000000000 R08: 
>> ffffffff81da0ac0 R09: 0000000000000000
>> Oct 21 13:02:19 uii316 [ 1766.831336] R10: 0000000000000003 R11: 
>> 00000000ffffffff R12: ffff880f3949bc78
>> Oct 21 13:02:19 uii316 [ 1766.831342] R13: ffff880f39c5e888 R14: 
>> ffff880f3d481000 R15: 00000000000e43bc
>> Oct 21 13:02:19 uii316 [ 1766.831347] FS:  00007f11cda9d720(0000) 
>> GS:ffff880fefd40000(0000) knlGS:0000000000000000
>> Oct 21 13:02:19 uii316 [ 1766.831353] CS:  0010 DS: 0000 ES: 0000 CR0: 
>> 0000000080050033
>> Oct 21 13:02:19 uii316 [ 1766.831358] CR2: 00007f11cdad4000 CR3: 
>> 0000000f39d35000 CR4: 00000000000007e0
>> Oct 21 13:02:19 uii316 [ 1766.831363] DR0: 0000000000000000 DR1: 
>> 0000000000000000 DR2: 0000000000000000
>> Oct 21 13:02:19 uii316 [ 1766.831368] DR3: 0000000000000000 DR6: 
>> 00000000ffff0ff0 DR7: 0000000000000400
>> Oct 21 13:02:19 uii316 [ 1766.831374] Process saposcol (pid: 7134, 
>> threadinfo ffff880f39d78000, task ffff880f39c5e240)
>> Oct 21 13:02:19 uii316 [ 1766.831379] Stack:
>> Oct 21 13:02:19 uii316 [ 1766.831383]  000000000002433c
>> Oct 21 13:02:19 uii316 00000000000e43bc
>> Oct 21 13:02:19 uii316 00000000000eab40
>> Oct 21 13:02:19 uii316 ffff880f00000001
>> Oct 21 13:02:19 uii316
>> Oct 21 13:02:19 uii316 [ 1766.831397]  ffff880f394956e0
>> Oct 21 13:02:19 uii316 ffff880f8e0d1000
>> Oct 21 13:02:19 uii316 ffff880f3949b800
>> Oct 21 13:02:19 uii316 0000000000000000
>> Oct 21 13:02:19 uii316
>> Oct 21 13:02:19 uii316 [ 1766.831410]  ffff880f39454980
>> Oct 21 13:02:19 uii316 0000000000000001
>> Oct 21 13:02:19 uii316 000000000002433c
>> Oct 21 13:02:19 uii316 0000000000000008
>> Oct 21 13:02:19 uii316
>> Oct 21 13:02:19 uii316 [ 1766.831423] Call Trace:
>> Oct 21 13:02:19 uii316 [ 1766.831492]  [<ffffffffa074742e>] 
>> ocfs2_setattr+0x26e/0xa90 [ocfs2]
>> Oct 21 13:02:19 uii316 [ 1766.831522]  [<ffffffff81178faf>] 
>> notify_change+0x19f/0x2f0
>> Oct 21 13:02:19 uii316 [ 1766.831534]  [<ffffffff8115d517>] 
>> do_truncate+0x57/0x80
>> Oct 21 13:02:19 uii316 [ 1766.831544]  [<ffffffff8116c053>] 
>> do_last+0x603/0x800
>> Oct 21 13:02:19 uii316 [ 1766.831551]  [<ffffffff8116ceb9>] 
>> path_openat+0xd9/0x420
>> Oct 21 13:02:19 uii316 [ 1766.831558]  [<ffffffff8116d33c>] 
>> do_filp_open+0x4c/0xc0
>> Oct 21 13:02:19 uii316 [ 1766.831566]  [<ffffffff8115de5f>] 
>> do_sys_open+0x17f/0x250
>> Oct 21 13:02:19 uii316 [ 1766.831575]  [<ffffffff8146e1f2>] 
>> system_call_fastpath+0x16/0x1b
>> Oct 21 13:02:19 uii316 [ 1766.831588]  [<00007f11ccb07080>] 0x7f11ccb0707f
>> Oct 21 13:02:19 uii316 [ 1766.831592] Code:
>>
>>  The source code in question is as below,
>>  444 static int ocfs2_truncate_file(struct inode *inode,
>>  445                                struct buffer_head *di_bh,
>>  446                                u64 new_i_size)
>>  447 {
>>  448         int status = 0;
>>  449         struct ocfs2_dinode *fe = NULL;
>>  450         struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>  451
>>  452         /* We trust di_bh because it comes from ocfs2_inode_lock(), 
>> which
>>  453          * already validated it */
>>  454         fe = (struct ocfs2_dinode *) di_bh->b_data;
>>  455
>>  456         trace_ocfs2_truncate_file((unsigned long 
>> long)OCFS2_I(inode)->ip_blkno,
>>  457                                   (unsigned long 
>> long)le64_to_cpu(fe->i_size),
>>  458                                   (unsigned long long)new_i_size);
>>  459
>>  460         mlog_bug_on_msg(le64_to_cpu(fe->i_size) != i_size_read(inode),    
>>  <<= here
>>  461                         "Inode %llu, inode i_size = %lld != di "
>>  462                         "i_size = %llu, i_flags = 0x%x\n",
>>  463                         (unsigned long long)OCFS2_I(inode)->ip_blkno,
>>  464                         i_size_read(inode),
>>  465                         (unsigned long long)le64_to_cpu(fe->i_size),
>>  466                         le32_to_cpu(fe->i_flags));
>>  467
>>
>> If your encountered the similar issue in the past, please let me know, to 
>> see if there is any patch/discussion for this bug.
>>
>> Thanks a lot.
>> Gang
>>
>>  
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> .
> 
