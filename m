From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 03 Jun 2011 09:05:47 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add readonly check in
	ocfs2_quota_on().
In-Reply-To: <20110602165001.GA13668@quack.suse.cz>
References: <1306916346-29510-1-git-send-email-tristan.ye@oracle.com>
	<4DE68415.3040309@oracle.com> <20110602124425.GB5718@quack.suse.cz>
	<4DE7B87A.7010307@oracle.com>
	<20110602165001.GA13668@quack.suse.cz>
Message-ID: <4DE8336B.1090407@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/03/2011 12:50 AM, Jan Kara wrote:
> On Fri 03-06-11 00:21:14, Tristan Ye wrote:
>> On 06/02/2011 08:44 PM, Jan Kara wrote:
>>> On Wed 01-06-11 11:25:25, Sunil Mushran wrote:
>>>> looks good.
>>>   Yes, looks OK to me as well. Only I'd be interested what NULL pointer
>>> dereference happened because I don't see how it could. Tristan, do you have
>>> the trace?
>>
>> Sure,
>> 	StackTrace attached.
>   Ah, right, I see now... Thanks for info.


And I believe another patch is being on its way now;-)


> 
> 								Honza
> 
>>>> On 06/01/2011 01:19 AM, Tristan Ye wrote:
>>>>> Enabling quota on a readonly ocfs2 fs caused a 'NULL pointer dereference' in
>>>>> dquot_enable(), a very straightforward fix is to check readonly at the very
>>>>> beginning of ocfs2_quota_on(), which calls dquot_enable().
>>>>>
>>>>> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
>>>>> ---
>>>>>  fs/ocfs2/super.c |    4 ++++
>>>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>>>> index 029c4cd..3cade2a 100644
>>>>> --- a/fs/ocfs2/super.c
>>>>> +++ b/fs/ocfs2/super.c
>>>>> @@ -995,6 +995,10 @@ static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
>>>>>  	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
>>>>>  		return -EINVAL;
>>>>>
>>>>> +	if (ocfs2_is_hard_readonly(OCFS2_SB(sb))) {
>>>>> +		return -EROFS;
>>>>> +	}
>>>>> +
>>>>>  	return dquot_enable(sb_dqopt(sb)->files[type], type,
>>>>>  			    format_id, DQUOT_LIMITS_ENABLED);
>>>>>  }
>>>>
>>
> 
>> Jun  1 12:38:08 ocfs2-box4 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
>> Jun  1 12:38:08 ocfs2-box4 kernel: IP: [<ffffffff8110dc88>] dquot_enable+0x19/0xf4
>> Jun  1 12:38:08 ocfs2-box4 kernel: PGD 0
>> Jun  1 12:38:08 ocfs2-box4 kernel: Oops: 0000 [#1] SMP
>> Jun  1 12:38:08 ocfs2-box4 kernel: CPU 1
>> Jun  1 12:38:08 ocfs2-box4 kernel: Modules linked in: ocfs2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs i915 drm_kms_helper drm i2c_algo_bit video deflate zlib_deflate ctr camellia cast5 rmd160 crypto_null netconsole ccm serpent blowfish twofish_generic twofish_x86_64 twofish_common ecb xcbc cbc md5 sha256_generic sha512_generic des_generic aes_x86_64 aes_generic ah6 ah4 esp6 esp4 xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 sunrpc p4_clockmod speedstep_lib ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_mod uinput snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm ppdev snd_timer i2c_i801 iTCO_wdt ehci_hcd tg3 snd parport_pc parport libphy sg i2c_core soundcore snd_page_alloc uhci_hcd pc
spkr serio_raw dcdbas ext4 jbd2 crc1
>> 6 sd_mod
>> Jun  1 12:38:08 ocfs2-box4 kernel: pata_acpi ata_generic ata_piix libata scsi_mod ide_cd_mod cdrom button [last unloaded: scsi_wait_scan]
>> Jun  1 12:38:08 ocfs2-box4 kernel:
>> Jun  1 12:38:08 ocfs2-box4 kernel: Pid: 3911, comm: quotaon Not tainted 2.6.39+ #3 Dell Inc.                 OptiPlex GX620               /0FH884
>> Jun  1 12:38:08 ocfs2-box4 kernel: RIP: 0010:[<ffffffff8110dc88>]  [<ffffffff8110dc88>] dquot_enable+0x19/0xf4
>> Jun  1 12:38:08 ocfs2-box4 kernel: RSP: 0018:ffff88007b971e18  EFLAGS: 00010246
>> Jun  1 12:38:08 ocfs2-box4 kernel: RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000002
>> Jun  1 12:38:08 ocfs2-box4 kernel: RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000000
>> Jun  1 12:38:08 ocfs2-box4 kernel: RBP: 0000000000000001 R08: 0000000000000004 R09: ffffffff817254e0
>> Jun  1 12:38:08 ocfs2-box4 kernel: R10: 0000000001c044d0 R11: ffff88007b971d34 R12: 0000000000000002
>> Jun  1 12:38:08 ocfs2-box4 kernel: R13: 0000000000000002 R14: 00007f28de3bc24e R15: ffff88007b971f28
>> Jun  1 12:38:08 ocfs2-box4 kernel: FS:  00007f28de38b700(0000) GS:ffff88007f480000(0000) knlGS:0000000000000000
>> Jun  1 12:38:08 ocfs2-box4 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Jun  1 12:38:08 ocfs2-box4 kernel: CR2: 0000000000000018 CR3: 0000000078f5f000 CR4: 00000000000006e0
>> Jun  1 12:38:08 ocfs2-box4 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> Jun  1 12:38:08 ocfs2-box4 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Jun  1 12:38:08 ocfs2-box4 kernel: Process quotaon (pid: 3911, threadinfo ffff88007b970000, task ffff8800794a6100)
>> Jun  1 12:38:08 ocfs2-box4 kernel: Stack:
>> Jun  1 12:38:08 ocfs2-box4 kernel: ffff88007b971f28 0000000000000001 00007f28de3bc24e ffff880078c39400
>> Jun  1 12:38:08 ocfs2-box4 kernel: 0000000000000001 0000000000800002 0000000000000002 00007f28de3bc24e
>> Jun  1 12:38:08 ocfs2-box4 kernel: ffff88007b971f28 ffffffff811103ac ffff880078f7c0e0 0000000400000001
>> Jun  1 12:38:08 ocfs2-box4 kernel: Call Trace:
>> Jun  1 12:38:08 ocfs2-box4 kernel: [<ffffffff811103ac>] ? do_quotactl+0x1ae/0x42a
>> Jun  1 12:38:08 ocfs2-box4 kernel: [<ffffffff810de0eb>] ? dput+0x27/0x152
>> Jun  1 12:38:08 ocfs2-box4 kernel: [<ffffffff81110753>] ? sys_quotactl+0x12b/0x160
>> Jun  1 12:38:08 ocfs2-box4 kernel: [<ffffffff8132097b>] ? system_call_fastpath+0x16/0x1b
>> Jun  1 12:38:08 ocfs2-box4 kernel: Code: 04 fd ff 8b 44 24 08 48 83 c4 18 5b 5d 41 5c 41 5d c3 41 57 41 56 41 55 41 54 41 89 cc 55 89 f5 53 48 89 fb 48 83 ec 18 f6 c1 04 <4c> 8b 6f 18 74 04 0f 0b eb fe 45 31 f6 85 c9 0f 84 b4 00 00 00
>> Jun  1 12:38:08 ocfs2-box4 kernel: RIP  [<ffffffff8110dc88>] dquot_enable+0x19/0xf4
>> Jun  1 12:38:08 ocfs2-box4 kernel: RSP <ffff88007b971e18>
>> Jun  1 12:38:08 ocfs2-box4 kernel: CR2: 0000000000000018
>> Jun  1 12:38:08 ocfs2-box4 kernel: ---[ end trace 317402b4fb3b74e7 ]---
>>
> 
