From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 04 Nov 2008 09:34:40 +0800
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Add clusters free in
	dealloc_ctxt.
In-Reply-To: <20081104011652.GH22137@mail.oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-2-git-send-email-tao.ma@oracle.com>
	<20081104011652.GH22137@mail.oracle.com>
Message-ID: <490FA6B0.5010303@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:

>> +{
>> +	int ret = 0;
>> +	struct ocfs2_cached_block_free *item;
>> +
>> +	item = kmalloc(sizeof(*item), GFP_NOFS);
>> +	if (item == NULL) {
>> +		ret = -ENOMEM;
>> +		mlog_errno(ret);
>> +		return ret;
>> +	}
>> +
>> +	mlog(0, "Insert clusters: (bit %u, blk %llu)\n",
>> +	     bit, (unsigned long long)blkno);
>> +
>> +	item->free_blk = blkno;
>> +	item->free_bit = bit;
>> +	item->free_next = ctxt->c_clusters_list;
> 
> 	You need to push item on to the list too.
> 
>   +	ctxt->c_clusters_list = item;
yeah, this is obviously a bug. thanks.
> 
>> +
>> +	return ret;
>> +}
>> +
>> +static int ocfs2_free_clusters_list(struct ocfs2_super *osb,
>> +				    struct ocfs2_cached_block_free *head)
> 
> 	Call this 'ocfs2_free_cached_clusters' and change
> 'ocfs2_free_cached_items' to 'ocfs2_free_cached_blocks'.
> 
>> +{
>> +	struct ocfs2_cached_block_free *tmp;
>> +	struct inode *tl_inode = osb->osb_tl_inode;
>> +	handle_t *handle;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&tl_inode->i_mutex);
>> +
>> +	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
>> +	if (IS_ERR(handle)) {
>> +		ret = PTR_ERR(handle);
>> +		mlog_errno(ret);
>> +		goto out_mutex;
>> +	}
>> +
>> +	while (head) {
>> +		ret = ocfs2_truncate_log_append(osb, handle, head->free_blk,
>> +						head->free_bit);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			break;
>> +		}
> 
> 	What happens if the truncate log fills up?
currently, it is only used in one xattr set. So the total size is only 
64K bytes and I don't think the chance is very high. I have also gone 
through ocfs2_commit_truncate, no error handler there, and even if it is 
filled up and error out, fsck should be able to find them. But you are 
probably right, if in future we use it in truncating file, it may be a 
very high risk. But it could be in another separate patch, agree?

btw, I will fix other typos according to your advice, thanks.

Regards,
Tao
