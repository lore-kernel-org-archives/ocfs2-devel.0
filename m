From: Younger Liu <younger.liu@huawei.com>
Date: Thu, 11 Jul 2013 20:42:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: update inode size after zeroed the
 hole
In-Reply-To: <51DD036E.9010903@oracle.com>
References: <1373418214-18661-1-git-send-email-junxiao.bi@oracle.com>
	<51DD036E.9010903@oracle.com>
Message-ID: <51DEA840.3040108@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/7/10 14:47, Junxiao Bi wrote:
> Sometimes, this patch will cause a call trace, see following, this code
> snippet is referenced from ocfs2_write_end(), I am not familiar with
> jbd, anybody know why?
> 
> 
> JBD: sda7-523: jh->b_next_transaction (58645,           (null), 0) !=
> transaction (ffff88014fa75ec0, 59276)
> ------------[ cut here ]------------
> WARNING: at fs/jbd2/transaction.c:1237
> jbd2_journal_dirty_metadata+0xf6/0x250()
> Modules linked in: ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack ipt_REJECT iptable_filter ip_tables bridge stp llc
> autofs4 hidp rfcomm bluetooth rfkill lockd sunrpc cpufreq_ondemand
> ip6t_REJECT ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs ib_iser
> rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic
> uio ipv6 cxgb3i libcxgbi cxgb3 mdio libiscsi_tcp libiscsi
> scsi_transport_iscsi sbs sbshc hed acpi_pad acpi_ipmi ipmi_msghandler
> parport_pc lp parport i915 snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss
> drm_kms_helper snd_seq_midi_event drm snd_seq sg snd_seq_device
> snd_pcm_oss snd_mixer_oss e1000e iTCO_wdt snd_pcm iTCO_vendor_support
> i2c_algo_bit sr_mod cdrom snd_timer snd i2c_i801 ptp dcdbas soundcore
> pcspkr lpc_ich pps_core acpi_cpufreq serio_raw i2c_core video
> snd_page_alloc mfd_core freq_table mperf dm_snapshot(F) dm_zero(F)
> dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) shpchp(F) ahci(F)
> libahci(F) sd_mod(F) crc_t10dif(F) ext3(F) jbd(F) mbcache(F)
> CPU: 2 PID: 6940 Comm: tar Tainted: PF            3.10.0-rc6 #2
> Hardware name: Dell Inc. OptiPlex 790/0PG55N, BIOS A11 12/30/2011
>  ffffffff8184f02f ffff880214c29808 ffffffff8132e369 ffff880214c29848
>  ffffffff81041e10 0000000000001000 ffff88014f8ff600 00000000ffffffea
>  ffff88014fa75ec0 ffff88021e275000 ffff88020a0b4338 ffff880214c29858
> Call Trace:
>  [<ffffffff8132e369>] dump_stack+0x19/0x20
>  [<ffffffff81041e10>] warn_slowpath_common+0x70/0xa0
>  [<ffffffff81041e5a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff811e0eb6>] jbd2_journal_dirty_metadata+0xf6/0x250
>  [<ffffffff812304ef>] ocfs2_journal_dirty+0x2f/0x70
>  [<ffffffff81224571>] ocfs2_write_zero_page+0x301/0x3e0
>  [<ffffffff812246e8>] ocfs2_zero_extend_range+0x98/0x160
>  [<ffffffff81224872>] ocfs2_zero_extend+0xc2/0x220
>  [<ffffffff812049cc>] ocfs2_zero_tail+0x2c/0x40
>  [<ffffffff81207fbb>] ocfs2_write_begin_nolock+0xfb/0xc80
>  [<ffffffff81229220>] ? ocfs2_read_inode_block+0x10/0x20
>  [<ffffffff81217d8a>] ? ocfs2_assign_bh+0x2a/0xb0
>  [<ffffffff8121c5a9>] ? ocfs2_inode_lock_full_nested+0xa9/0x470
>  [<ffffffff81208c76>] ocfs2_write_begin+0x136/0x200
>  [<ffffffff8110c444>] generic_perform_write+0xd4/0x1e0
>  [<ffffffff8110c5b5>] generic_file_buffered_write+0x65/0xa0
>  [<ffffffff812266b1>] ocfs2_file_aio_write+0x691/0x7b0
>  [<ffffffff81163ea7>] do_sync_write+0x97/0xe0
>  [<ffffffff811647a5>] vfs_write+0xe5/0x1e0
>  [<ffffffff81164ae1>] SyS_write+0x61/0xa0
>  [<ffffffff81604cc2>] system_call_fastpath+0x16/0x1b
> ---[ end trace edb3aa856f6f3cde ]---
> 
Could you put out the issue code? and tell us which line of code trigger the bug.
From "fs/jbd2/transaction.c:1237", I could not find the details.

> 
> On 07/10/2013 09:03 AM, Junxiao Bi wrote:
>> fs-writeback will release the dirty pages without page lock
>> whose offset are over inode size, the release happens at
>> block_write_full_page_endio(). If not update, dirty pages
>> in file holes may be released before flushed to the disk,
>> then file holes will contain some non-zero data, this will
>> cause sparse file cksum error.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>  fs/ocfs2/file.c |   25 ++++++++++++++++++++-----
>>  1 file changed, 20 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index ff54014..d1264ef 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -756,7 +756,7 @@ out:
>>   * to be too fragile to do exactly what we need without us having to
>>   * worry about recursive locking in ->write_begin() and ->write_end(). */
>>  static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>> -				 u64 abs_to)
>> +				 u64 abs_to, struct buffer_head *di_bh)
>>  {
>>  	struct address_space *mapping = inode->i_mapping;
>>  	struct page *page;
>> @@ -764,6 +764,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>>  	handle_t *handle = NULL;
>>  	int ret = 0;
>>  	unsigned zero_from, zero_to, block_start, block_end;
>> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>  
>>  	BUG_ON(abs_from >= abs_to);
>>  	BUG_ON(abs_to > (((u64)index + 1) << PAGE_CACHE_SHIFT));
>> @@ -823,8 +824,22 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>>  			ret = 0;
>>  	}
>>  
>> -	if (handle)
>> +	if (handle) {
>> +		/*
>> +		 * fs-writeback will release the dirty pages without page lock
>> +		 * whose offset are over inode size, the release happens at
>> +		 * block_write_full_page_endio().
>> +		 */
>> +		i_size_write(inode, abs_to);
>> +		inode->i_blocks = ocfs2_inode_sector_count(inode);
>> +		di->i_size = cpu_to_le64((u64)i_size_read(inode));
>> +		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>> +		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>> +		di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>> +		di->i_mtime_nsec = di->i_ctime_nsec;
>> +		ocfs2_journal_dirty(handle, di_bh);
>>  		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
>> +	}
>>  
>>  out_unlock:
>>  	unlock_page(page);
>> @@ -920,7 +935,7 @@ out:
>>   * has made sure that the entire range needs zeroing.
>>   */
>>  static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
>> -				   u64 range_end)
>> +				   u64 range_end, struct buffer_head *di_bh)
>>  {
>>  	int rc = 0;
>>  	u64 next_pos;
>> @@ -936,7 +951,7 @@ static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
>>  		next_pos = (zero_pos & PAGE_CACHE_MASK) + PAGE_CACHE_SIZE;
>>  		if (next_pos > range_end)
>>  			next_pos = range_end;
>> -		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos);
>> +		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos, di_bh);
>>  		if (rc < 0) {
>>  			mlog_errno(rc);
>>  			break;
>> @@ -982,7 +997,7 @@ int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
>>  			range_end = zero_to_size;
>>  
>>  		ret = ocfs2_zero_extend_range(inode, range_start,
>> -					      range_end);
>> +					      range_end, di_bh);
>>  		if (ret) {
>>  			mlog_errno(ret);
>>  			break;
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> .
> 
