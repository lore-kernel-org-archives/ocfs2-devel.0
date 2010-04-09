From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 09 Apr 2010 15:56:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered
In-Reply-To: <4BBEDE38.3030207@suse.de>
References: <201004081547.24593.lidongyang@novell.com>	<4BBE2356.4010103@oracle.com>
	<4BBEDE38.3030207@suse.de>
Message-ID: <4BBEDDA0.5020201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi coly,

Coly Li wrote:
> 
> On 04/09/2010 02:41 AM, Sunil Mushran Wrote:
>> I cannot read the bugzilla. Now it maybe that that bz
>> cannot be made public. That's ok. But if that's the case,
>> can you explain the problem encountered. I am not qs
>> the fix... rather trying to understand why this has not
>> been reported before.
>>
> 
> Hi Sunil,
> 
> This issue was reported by Jiaju Zhang, another Novell ocfs2/dlm developer. When he did I/O pressure test (fsstress from
> ltp package), the following dmesg was observed,
> 
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717421] (11411,2):ocfs2_truncate_file:465 ERROR: bug expression:
> le64_to_cpu(fe->i_size) != i_size_read(inode)
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717437] (11411,2):ocfs2_truncate_file:465 ERROR: Inode 241893, inode i_size =
> 1540096 != di i_size = 1535498, i_flags = 0x1
Why do you guys think this is caused by the directIO fall back?
IMHO, we should update inode->i_size and fe->i_size simultaneously. So 
do you find a place where we don't sync them? I guess that should be the 
root cause.

Regards,
Tao
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717462] ------------[ cut here]------------
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717465] kernel BUG at /usr/src/packages/BUILD/ocfs2-1.4/xen/ocfs2/file.c:465!
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717468] invalid opcode: 0000 [#2] SMP
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717471] last sysfs file: /sys/kernel/uevent_seqnum
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717474] Modules linked in: ocfs2 jbd2 ocfs2_nodemanager quota_tree
> ocfs2_stack_user ocfs2_stackglue dlm configfs sg sd_mod crc_t10dif crc32c ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad
> ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod af_packet microcode softdog fuse loop
> dm_mod rtc_core rtc_lib joydev xennet ext3 mbcache jbd processor thermal_sys hwmon xenblk cdrom
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717516] Supported: Yes
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717518]
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717521] Pid: 11411, comm: fsstress Tainted: G      D      (2.6.32.9-0.5-xen #1)
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717525] EIP: 0061:[<d24701ba>] EFLAGS: 00010296 CPU: 2
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717538] EIP is at ocfs2_setattr+0xc1a/0x1d10 [ocfs2]
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717542] EAX: 00000089 EBX: cd8e25f0 ECX: c056c0ec EDX: 00000000
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717545] ESI: cc4c2000 EDI: cae4e908 EBP: 00068f02 ESP: c0a43e54
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717548]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717552] Process fsstress (pid: 11411, ti=c0a42000 task=cd8e25f0  task.ti=c0a42000)
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717555] Stack:
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717557]  d24cfc30 00002c93 00000002 d24c809c 000001d1 0003b0e5 00000000 00178000
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717564] <0> 00000000 00176e0a 00000000 00000001 00110f02 00000000 00000000 00000000
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717572] <0> 00000000 00000000 00000000 00110f02 d24628e9 00008282 c0a43f44 ca5c4000
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717582] Call Trace:
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717606]  [<c00d6191>] notify_change+0x141/0x320
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717614]  [<c00bf1a8>] do_truncate+0x68/0xa0
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717619]  [<c00bf547>] do_sys_truncate+0x177/0x220
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717624]  [<c000666d>] syscall_call+0x7/0xb
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717629]  [<f57fe424>] 0xf57fe424
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717631] Code: 69 e8 ed f6 05 82 9f d7
> d1 80 75 09 f6 05 84 9f d7 d1 01 74 16 f6 05 8a 9f d7 d1 80 75 0d f6 05 8c 9f
> d7 d1 01 0f 84 48 06 00 00 <0f> 0b eb fe 66 90 8b 44 24 68 31 c9 e8 b5 2f c9 ed
> 31 c9 89 44
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717675] EIP: [<d24701ba>] ocfs2_setattr+0xc1a/0x1d10 [ocfs2] SS:ESP 0069:c0a43e54
> Mar 24 15:59:07 xen-sp1-2 kernel: [ 2309.717688] ---[ end trace cce1004f6a64f124 ]---
> 
> 
> The above error can be reproduced by Jiaju, Dongyang, and me. Dongyang also reproduced this issue on vanilla kernel. We
> find these steps is easier to reproduce the error: 1) fill the ocfs2 volume to 97%-98% full (dd a big file on ocfs2
> volume)  2) then ran fsstress
> 
> Jan Kara also helps to review Dongyang's patch, no objection from him.
> 
> Hope the explanation is informative.
> 
