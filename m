From: Gang He <ghe@suse.com>
Date: Wed, 03 Jan 2018 19:03:45 -0700
Subject: [Ocfs2-devel] [PATCH v2 2/2] ocfs2: add trimfs lock to avoid
 duplicated trims in cluster
In-Reply-To: <5A4D85CB.4020208@huawei.com>
References: <1513228484-2084-1-git-send-email-ghe@suse.com>
	<1513228484-2084-2-git-send-email-ghe@suse.com>
	<5A4D85CB.4020208@huawei.com>
Message-ID: <5A4DFC01020000F9000A1205@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.chen@huawei.com
Cc: jlbec@evilplan.org, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, mfasheh@versity.com, linux-kernel@vger.kernel.org

Hi Alex,


>>> 
> Hi Gang,
> 
> On 2017/12/14 13:14, Gang He wrote:
>> As you know, ocfs2 has support trim the underlying disk via
>> fstrim command. But there is a problem, ocfs2 is a shared disk
>> cluster file system, if the user configures a scheduled fstrim
>> job on each file system node, this will trigger multiple nodes
>> trim a shared disk simultaneously, it is very wasteful for CPU
>> and IO consumption, also might negatively affect the lifetime
>> of poor-quality SSD devices.
>> Then, we introduce a trimfs dlm lock to communicate with each
>> other in this case, which will make only one fstrim command to
>> do the trimming on a shared disk among the cluster, the fstrim
>> commands from the other nodes should wait for the first fstrim
>> to finish and returned success directly, to avoid running a the
>> same trim on the shared disk again.
>> 
> For the same purpose, can we take global bitmap meta lock EXMODE instead of
> add a new trimfs dlm lock?
I do not think using EXMODE lock to global bitmap meta can handle this case.
this patch's purpose is to avoid duplicated trim when the nodes in cluster are configured to a schedule fstrim (usually the administrator do like that).
But, there are lots of path to use EXMODE lock to global bitmap meta, we can not know which is used to trim fs.
Second, we can not use global bitmap meta lock to save fstrim related data and trylock.

Thanks
Gang 

> 
> Thanks,
> Alex
> 
>> Compare with first version, I change the fstrim commands' returned
>> value and behavior in case which meets a fstrim command is running
>> on a shared disk.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/alloc.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>> 
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index ab5105f..5c9c3e2 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -7382,6 +7382,7 @@ int ocfs2_trim_fs(struct super_block *sb, struct 
> fstrim_range *range)
>>  	struct buffer_head *gd_bh = NULL;
>>  	struct ocfs2_dinode *main_bm;
>>  	struct ocfs2_group_desc *gd = NULL;
>> +	struct ocfs2_trim_fs_info info, *pinfo = NULL;
>>  
>>  	start = range->start >> osb->s_clustersize_bits;
>>  	len = range->len >> osb->s_clustersize_bits;
>> @@ -7419,6 +7420,42 @@ int ocfs2_trim_fs(struct super_block *sb, struct 
> fstrim_range *range)
>>  
>>  	trace_ocfs2_trim_fs(start, len, minlen);
>>  
>> +	ocfs2_trim_fs_lock_res_init(osb);
>> +	ret = ocfs2_trim_fs_lock(osb, NULL, 1);
>> +	if (ret < 0) {
>> +		if (ret != -EAGAIN) {
>> +			mlog_errno(ret);
>> +			ocfs2_trim_fs_lock_res_uninit(osb);
>> +			goto out_unlock;
>> +		}
>> +
>> +		mlog(ML_NOTICE, "Wait for trim on device (%s) to "
>> +		     "finish, which is running from another node.\n",
>> +		     osb->dev_str);
>> +		ret = ocfs2_trim_fs_lock(osb, &info, 0);
>> +		if (ret < 0) {
>> +			mlog_errno(ret);
>> +			ocfs2_trim_fs_lock_res_uninit(osb);
>> +			goto out_unlock;
>> +		}
>> +
>> +		if (info.tf_valid && info.tf_success &&
>> +		    info.tf_start == start && info.tf_len == len &&
>> +		    info.tf_minlen == minlen) {
>> +			/* Avoid sending duplicated trim to a shared device */
>> +			mlog(ML_NOTICE, "The same trim on device (%s) was "
>> +			     "just done from node (%u), return.\n",
>> +			     osb->dev_str, info.tf_nodenum);
>> +			range->len = info.tf_trimlen;
>> +			goto out_trimunlock;
>> +		}
>> +	}
>> +
>> +	info.tf_nodenum = osb->node_num;
>> +	info.tf_start = start;
>> +	info.tf_len = len;
>> +	info.tf_minlen = minlen;
>> +
>>  	/* Determine first and last group to examine based on start and len */
>>  	first_group = ocfs2_which_cluster_group(main_bm_inode, start);
>>  	if (first_group == osb->first_cluster_group_blkno)
>> @@ -7463,6 +7500,13 @@ int ocfs2_trim_fs(struct super_block *sb, struct 
> fstrim_range *range)
>>  			group += ocfs2_clusters_to_blocks(sb, osb->bitmap_cpg);
>>  	}
>>  	range->len = trimmed * sb->s_blocksize;
>> +
>> +	info.tf_trimlen = range->len;
>> +	info.tf_success = (ret ? 0 : 1);
>> +	pinfo = &info;
>> +out_trimunlock:
>> +	ocfs2_trim_fs_unlock(osb, pinfo);
>> +	ocfs2_trim_fs_lock_res_uninit(osb);
>>  out_unlock:
>>  	ocfs2_inode_unlock(main_bm_inode, 0);
>>  	brelse(main_bm_bh);
>> 
