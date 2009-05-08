From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 08 May 2009 09:41:54 +0800
Subject: [Ocfs2-devel] [PATCH 22/39] ocfs2: Add refcount tree lock
	mechanism.
In-Reply-To: <20090508011735.GC31624@mail.oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-22-git-send-email-tao.ma@oracle.com>
	<20090508011735.GC31624@mail.oracle.com>
Message-ID: <4A038DE2.30607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Thu, Apr 30, 2009 at 06:58:34AM +0800, Tao Ma wrote:
>> +/*
>> + * Lock the refcount tree pointed by ref_blkno and return the tree.
>> + * In most case, we lock the tree and read the refcount block.
>> + * So read it here if the caller really need it.
>> + */
>> +int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
>> +			     struct ocfs2_refcount_tree **ret_tree,
>> +			     struct buffer_head **ref_bh)
>> +{
>> +	int ret;
>> +	struct ocfs2_refcount_tree *tree = NULL;
>> +
>> +	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>> +
>> +	ret = ocfs2_refcount_lock(&tree->rf_lockres, rw);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>> +
>> +	if (rw)
>> +		down_write(&tree->rf_sem);
>> +	else
>> +		down_read(&tree->rf_sem);
>> +
>> +	if (ref_bh) {
>> +		ret = ocfs2_read_refcount_block(&tree->rf_ci,
>> +						ref_blkno, ref_bh);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			ocfs2_unlock_refcount_tree(osb, tree, rw);
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	*ret_tree = tree;
>> +out:
>> +	return ret;
>> +}
>> +
>> +void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
>> +				struct ocfs2_refcount_tree *tree, int rw)
>> +{
>> +	ocfs2_refcount_unlock(&tree->rf_lockres, rw);
>> +
>> +	if (rw)
>> +		up_write(&tree->rf_sem);
>> +	else
>> +		up_read(&tree->rf_sem);
>> +}
> 
> 	You lock "cluster, mutex", but you also unlock "cluster, mutex".
> I would think you'd want to unlock "mutex, cluster".
yeah, I should use the reverse order.

Thanks.

Regards,
Tao
