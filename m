From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date: Wed, 14 Oct 2015 06:53:13 -0500
Subject: [Ocfs2-devel] Ocfs2-devel Digest, Vol 138, Issue 31 review
In-Reply-To: <561E1902.507@huawei.com>
References: <mailman.1701.1440805574.13254.ocfs2-devel@oss.oracle.com>
	<2015101415485251084042@h3c.com> <561E0E8D.6070102@huawei.com>
	<2015101416441090805161@h3c.com> <561E1902.507@huawei.com>
Message-ID: <561E4229.7090804@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 10/14/2015 03:57 AM, Joseph Qi wrote:
> On 2015/10/14 16:45, Zhangguanghui wrote:
>> Hi,
>> "status = -30" means it has encountered EROFS when start transaction.
>> And system panic is because s_mount_opt is set to OCFS2_MOUNT_ERRORS_PANIC in  __ocfs2_abort,
>> ideal with OCFS2_MOUNT_ERRORS_PANIC first in ocfs2_handle_error.
>> so I think that it is not reasonable,  Therefore, this setting shall be canceled in __ocfs2_abort.
>>   thanks
>>
> The option is set when mounting and __ocfs2_abort does the check and
> then perform proper action.
> So if panic is not the behaviour you want, change the mount option to
> what you want.


No, this is a special case where the journal is aborted. So, we are 
calling ocfs2_abort() because we cannot proceed with the transaction 
because of journal abort. IOW, even if you use errors=continue, the 
operation will fail because the error is too dangerous to continue for 
any operation and hence the abort.

__ocfs2_abort does set OCFS2_MOUNT_ERRORS_PANIC in this case. This is a 
critical error and we don't want to continue in any state, even 
read-only. From the code comments:

         /* Force a panic(). This stinks, but it's better than letting
          * things continue without having a proper hard readonly
          * here. */


Please execute fsck to get the journal back in shape.

HTH,

-- 
Goldwyn


>
>> --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------!
 -!
> ---
>> zhangguanghui
>>
>>
>>      *From:* Joseph Qi <mailto:joseph.qi@huawei.com>
>>      *Date:* 2015-10-14 16:13
>>      *To:* zhangguanghui 10102 (CCPL) <mailto:zhang.guanghui@h3c.com>
>>      *CC:* mfasheh > <mailto:mfasheh@suse.de>; 'ocfs2-users at oss.oracle.com' (ocfs2-users at oss.oracle.com) <mailto:ocfs2-users@oss.oracle.com>; ocfs2-devel at oss.oracle.com <mailto:ocfs2-devel@oss.oracle.com>; rgoldwyn <mailto:rgoldwyn@suse.com>
>>      *Subject:* Re: [Ocfs2-devel] Ocfs2-devel Digest, Vol 138, Issue 31 review
>>
>>      On 2015/10/14 15:49, Zhangguanghui wrote:
>>      > OCFS2 is often used in high-availaibility systems, This patch enhances robustness for the filesystem.
>>      > but storage network is unstable?it still triggers a panic? such as ocfs2_start_trans -> __ocfs2_abort ->panic.
>>      > The 's_mount_opt' should depend on the mount option set, If errors=continue is set,
>>      > mark as a EIO error, change OCFS2_MOUNT_ERRORS_PANIC to OCFS2_MOUNT_ERRORS_CONT in __ocfs2_abort;
>>      > it's better than forcing a panic without decreasing availability,errors=continue seems be well to me.
>>      >
>>      > Finally, any feedback about this process (positive or negative) would be greatly appreciated.
>>      >
>>      >    Aug 11 11:32:25 cvknode73 kernel: [678904.787906] (pool,23256,12):ocfs2_start_trans:367 ERROR: status = -30
>>      >
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825046] CPU: 12 PID: 23256 Comm: pool Tainted: GF W IO 3.13.6 #1
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825050] Hardware name: HP ProLiant BL460c G7, BIOS I27 12/03/2012
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825054] ffffffffffffffe2 ffff88108c945a88 ffffffff81750690 ffff88180bacfff0
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825064] ffff88174196d000 ffff88108c945ad8 ffffffffa052f667 ffffffffffffffe2
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825072] 0000000000001000 ffff88108c945b58 ffff88175e870000 ffff8811ada4f000
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825087] Call Trace:
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825103] [<ffffffff81750690>] dump_stack+0x46/0x58
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825154] [<ffffffffa052f667>] ocfs2_start_trans+0x1d7/0x200 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825183] [<ffffffffa0505b60>] ocfs2_write_begin_nolock+0xda0/0x1c70 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825216] [<ffffffffa052b7cb>] ? ocfs2_read_inode_block_full+0x3b/0x60 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825248] [<ffffffffa051a82f>] ? ocfs2_inode_lock_full_nested+0x52f/0xc60 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825277] [<ffffffffa0516060>] ? ocfs2_should_refresh_lock_res+0x80/0x190 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825304] [<ffffffffa0506b36>] ocfs2_write_begin+0x106/0x230 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825330] [<ffffffffa05180ab>] ? __ocfs2_cluster_unlock.isra.27+0x9b/0xe0 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825342] [<ffffffff8115342b>] generic_file_buffered_write+0xfb/0x280
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825370] [<ffffffffa051a1c5>] ? ocfs2_rw_lock+0x75/0x1b0 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825398] [<ffffffffa0527f3f>] ocfs2_file_aio_write+0x79f/0x830 [ocfs2]
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825407] [<ffffffff811c14ba>] do_sync_write+0x5a/0x90
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825413] [<ffffffff811c1fc5>] vfs_write+0xc5/0x1f0
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825418] [<ffffffff811c24c2>] SyS_write+0x52/0xa0
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825426] [<ffffffff8176106d>] system_call_fastpath+0x1a/0x1f
>>      >     Aug 11 11:32:25 cvknode73 kernel: [678904.825431] OCFS2: abort (device sdu): ocfs2_start_trans: Detected aborted journal
>>      >
>>      "status = -30" means it has encountered EROFS when start transaction.
>>      And system panic is because you mount with option "errors=panic",
>>      while default is "errors=remount-ro" rather than panic.
>>      Change it to "errors=continue" will proceed even if filesystem
>>      encounters errors (default will set it to readonly).
>>
>>      Thanks,
>>      Joseph
>>
>>      >
>>      > -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------!
 --!
> ------!
>>      ---
>>      > zhangguanghui
>>
>>
>> -------------------------------------------------------------------------------------------------------------------------------------
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ???
>> This e-mail and its attachments contain confidential information from H3C, which is
>> intended only for the person or entity whose address is listed above. Any use of the
>> information contained herein in any way (including, but not limited to, total or partial
>> disclosure, reproduction, or dissemination) by persons other than the intended
>> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
>> by phone or email immediately and delete it!
>
>
>

-- 
Goldwyn
