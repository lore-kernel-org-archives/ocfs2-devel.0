From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 13 Sep 2016 10:14:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix trans extend while flush
 truncate log
In-Reply-To: <57D75EC4.9020501@huawei.com>
References: <1473674623-11810-1-git-send-email-junxiao.bi@oracle.com>
	<57D75EC4.9020501@huawei.com>
Message-ID: <f08567ab-79ae-829d-4c55-6dddcb92beed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/13/2016 10:04 AM, Joseph Qi wrote:
> Hi Junxiao,
> 
> On 2016/9/12 18:03, Junxiao Bi wrote:
>> Every time,  ocfs2_extend_trans() included a credit for truncate log inode,
>> but as that inode had been managed by jbd2 running transaction first time,
>> it will not consume that credit until jbd2_journal_restart(). Since total
>> credits to extend always included the un-consumed ones, there will be more
>> and more un-consumed credit, at last jbd2_journal_restart() will fail due
>> to credit number over the half of max transction credit.
>>
>> The following error was caught when unlink a large file with many extents.
>>
>> [233096.013936] ------------[ cut here ]------------
>> [233096.018586] WARNING: CPU: 0 PID: 13626 at fs/jbd2/transaction.c:269 start_this_handle+0x4c3/0x510 [jbd2]()
>> [233096.028335] Modules linked in: ocfs2 nfsd lockd grace nfs_acl auth_rpcgss sunrpc autofs4 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sd_mod sg ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ppdev xen_kbdfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea parport_pc parport pcspkr i2c_piix4 i2c_core acpi_cpufreq ext4 jbd2 mbcache xen_blkfront floppy pata_acpi ata_generic ata_piix dm_mirror dm_region_hash dm_log dm_mod
>> [233096.081751] CPU: 0 PID: 13626 Comm: unlink Tainted: G        W       4.1.12-37.6.3.el6uek.x86_64 #2
>> [233096.088556] Hardware name: Xen HVM domU, BIOS 4.4.4OVM 02/11/2016
>> [233096.093125]  000000000000010d ffff88000018b768 ffffffff816bc5bc 000000000000010d
>> [233096.099082]  0000000000000000 ffff88000018b7a8 ffffffff81081475 ffff88000018b788
>> [233096.105038]  ffff88007a99a000 ffff88007b573390 00000000000000fb 0000000000000050
>> [233096.110540] Call Trace:
>> [233096.111893]  [<ffffffff816bc5bc>] dump_stack+0x48/0x5c
>> [233096.114637]  [<ffffffff81081475>] warn_slowpath_common+0x95/0xe0
>> [233096.117797]  [<ffffffff810814da>] warn_slowpath_null+0x1a/0x20
>> [233096.120984]  [<ffffffffa0080993>] start_this_handle+0x4c3/0x510 [jbd2]
>> [233096.124505]  [<ffffffffa0088f95>] ? __jbd2_log_start_commit+0xe5/0xf0 [jbd2]
>> [233096.128115]  [<ffffffff810c4eb3>] ? __wake_up+0x53/0x70
>> [233096.130924]  [<ffffffffa0080b41>] jbd2__journal_restart+0x161/0x1b0 [jbd2]
>> [233096.134523]  [<ffffffffa0080ba3>] jbd2_journal_restart+0x13/0x20 [jbd2]
>> [233096.137986]  [<ffffffffa06d1d94>] ocfs2_extend_trans+0x74/0x220 [ocfs2]
>> [233096.141407]  [<ffffffffa06d156a>] ? ocfs2_journal_dirty+0x3a/0x90 [ocfs2]
>> [233096.144921]  [<ffffffffa0692943>] ocfs2_replay_truncate_records+0x93/0x360 [ocfs2]
>> [233096.148819]  [<ffffffffa0697ace>] __ocfs2_flush_truncate_log+0x13e/0x3a0 [ocfs2]
>> [233096.152644]  [<ffffffffa0697304>] ? ocfs2_reserve_blocks_for_rec_trunc.clone.0+0x44/0x1f0 [ocfs2]
>> [233096.157310]  [<ffffffffa069f768>] ocfs2_remove_btree_range+0x458/0x7f0 [ocfs2]
>> [233096.161099]  [<ffffffffa0696777>] ? __ocfs2_find_path+0x187/0x2d0 [ocfs2]
>> [233096.164612]  [<ffffffffa06a2673>] ocfs2_commit_truncate+0x1b3/0x6f0 [ocfs2]
>> [233096.168204]  [<ffffffffa0744ac0>] ? ocfs2_xattr_tree_et_ops+0x60/0xfffffffffffe8c20 [ocfs2]
>> [233096.172539]  [<ffffffffa06d1a00>] ? ocfs2_journal_access_eb+0x20/0x20 [ocfs2]
>> [233096.176285]  [<ffffffff81202303>] ? __sb_end_write+0x33/0x70
>> [233096.179226]  [<ffffffffa06ca61d>] ocfs2_truncate_for_delete+0xbd/0x380 [ocfs2]
>> [233096.183009]  [<ffffffffa06ca294>] ? ocfs2_query_inode_wipe+0xf4/0x320 [ocfs2]
>> [233096.186738]  [<ffffffffa06caf76>] ocfs2_wipe_inode+0x136/0x6a0 [ocfs2]
>> [233096.190165]  [<ffffffffa06ca294>] ? ocfs2_query_inode_wipe+0xf4/0x320 [ocfs2]
>> [233096.193846]  [<ffffffffa06cb782>] ocfs2_delete_inode+0x2a2/0x3e0 [ocfs2]
>> [233096.197274]  [<ffffffff812298c9>] ? __inode_wait_for_writeback+0x69/0xc0
>> [233096.200736]  [<ffffffffa0732180>] ? __PRETTY_FUNCTION__.112282+0x20/0xffffffffffffb520 [ocfs2]
>> [233096.205146]  [<ffffffffa06cc298>] ocfs2_evict_inode+0x28/0x60 [ocfs2]
>> [233096.208462]  [<ffffffff8121b81b>] evict+0xab/0x1a0
>> [233096.211020]  [<ffffffffa0732180>] ? __PRETTY_FUNCTION__.112282+0x20/0xffffffffffffb520 [ocfs2]
>> [233096.215396]  [<ffffffff8121ba06>] iput_final+0xf6/0x190
>> [233096.218169]  [<ffffffff8121bb68>] iput+0xc8/0xe0
>> [233096.220586]  [<ffffffff8120f9b7>] do_unlinkat+0x1b7/0x310
>> [233096.223487]  [<ffffffff8106ae5b>] ? __do_page_fault+0x18b/0x480
>> [233096.226655]  [<ffffffff81126dbc>] ? __audit_syscall_entry+0xac/0x110
>> [233096.230009]  [<ffffffff810236cc>] ? do_audit_syscall_entry+0x6c/0x70
>> [233096.233346]  [<ffffffff81023823>] ? syscall_trace_enter_phase1+0x153/0x180
>> [233096.237103]  [<ffffffff8120fb26>] SyS_unlink+0x16/0x20
>> [233096.239800]  [<ffffffff816c122e>] system_call_fastpath+0x12/0x71
>> [233096.244346] ---[ end trace 28aa7410e69369cf ]---
>> [233096.247798] JBD2: unlink wants too many credits (251 > 128)
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>  fs/ocfs2/alloc.c |   29 ++++++++++-------------------
>>  1 file changed, 10 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 7dabbc31060e..51128789a661 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5922,7 +5922,6 @@ bail:
>>  }
>>  
>>  static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>> -					 handle_t *handle,
>>  					 struct inode *data_alloc_inode,
>>  					 struct buffer_head *data_alloc_bh)
>>  {
>> @@ -5935,11 +5934,19 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>>  	struct ocfs2_truncate_log *tl;
>>  	struct inode *tl_inode = osb->osb_tl_inode;
>>  	struct buffer_head *tl_bh = osb->osb_tl_bh;
>> +	handle_t *handle;
>>  
>>  	di = (struct ocfs2_dinode *) tl_bh->b_data;
>>  	tl = &di->id2.i_dealloc;
>>  	i = le16_to_cpu(tl->tl_used) - 1;
>>  	while (i >= 0) {
>> +		handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
>> +		if (IS_ERR(handle)) {
>> +			status = PTR_ERR(handle);
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +
>>  		/* Caller has given us at least enough credits to
>>  		 * update the truncate log dinode */
> So we do not need this comment any more, am I right?
Yes, that comment can be dropped.

Thanks,
Junxiao.
> Anyway it looks good to me.
> 
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> 
>>  		status = ocfs2_journal_access_di(handle, INODE_CACHE(tl_inode), tl_bh,
>> @@ -5974,12 +5981,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>>  			}
>>  		}
>>  
>> -		status = ocfs2_extend_trans(handle,
>> -				OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
>> -		if (status < 0) {
>> -			mlog_errno(status);
>> -			goto bail;
>> -		}
>> +		ocfs2_commit_trans(osb, handle);
>>  		i--;
>>  	}
>>  
>> @@ -5994,7 +5996,6 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>>  {
>>  	int status;
>>  	unsigned int num_to_flush;
>> -	handle_t *handle;
>>  	struct inode *tl_inode = osb->osb_tl_inode;
>>  	struct inode *data_alloc_inode = NULL;
>>  	struct buffer_head *tl_bh = osb->osb_tl_bh;
>> @@ -6038,21 +6039,11 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>>  		goto out_mutex;
>>  	}
>>  
>> -	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
>> -	if (IS_ERR(handle)) {
>> -		status = PTR_ERR(handle);
>> -		mlog_errno(status);
>> -		goto out_unlock;
>> -	}
>> -
>> -	status = ocfs2_replay_truncate_records(osb, handle, data_alloc_inode,
>> +	status = ocfs2_replay_truncate_records(osb, data_alloc_inode,
>>  					       data_alloc_bh);
>>  	if (status < 0)
>>  		mlog_errno(status);
>>  
>> -	ocfs2_commit_trans(osb, handle);
>> -
>> -out_unlock:
>>  	brelse(data_alloc_bh);
>>  	ocfs2_inode_unlock(data_alloc_inode, 1);
>>  
>>
> 
> 
