From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 3 Nov 2008 19:01:57 -0800
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Add clusters free
	in	dealloc_ctxt.
In-Reply-To: <490FA6B0.5010303@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-2-git-send-email-tao.ma@oracle.com>
	<20081104011652.GH22137@mail.oracle.com>
	<490FA6B0.5010303@oracle.com>
Message-ID: <20081104030157.GC16483@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 04, 2008 at 09:34:40AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>>> +{
>>> +	struct ocfs2_cached_block_free *tmp;
>>> +	struct inode *tl_inode = osb->osb_tl_inode;
>>> +	handle_t *handle;
>>> +	int ret = 0;
>>> +
>>> +	mutex_lock(&tl_inode->i_mutex);
>>> +
>>> +	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
>>> +	if (IS_ERR(handle)) {
>>> +		ret = PTR_ERR(handle);
>>> +		mlog_errno(ret);
>>> +		goto out_mutex;
>>> +	}
>>> +
>>> +	while (head) {
>>> +		ret = ocfs2_truncate_log_append(osb, handle, head->free_blk,
>>> +						head->free_bit);
>>> +		if (ret) {
>>> +			mlog_errno(ret);
>>> +			break;
>>> +		}
>>
>> 	What happens if the truncate log fills up?
> currently, it is only used in one xattr set. So the total size is only  
> 64K bytes and I don't think the chance is very high. I have also gone  
> through ocfs2_commit_truncate, no error handler there, and even if it is  
> filled up and error out, fsck should be able to find them. But you are  
> probably right, if in future we use it in truncating file, it may be a  
> very high risk. But it could be in another separate patch, agree?

	ocfs2_commit_truncate() is a loop from start: to bail:.  It
calls ocfs2_do_truncate() for each extent it removes.  Before each call
to ocfs2_do_truncate(), it checks ocfs2_truncate_log_needs_flush().
That is, it never adds more than one record to the truncate log at a
time, and it checks for a full log before adding each record.
	Your 64K can be 16 clusters at a 4K cluster size.  That's 16
records.  What if the truncate log had only space for three records from
a previous operation?  Your fourth call to ocfs2_truncate_log_append()
will mlog_bug_on_msg() like so:

5319         mlog_bug_on_msg(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||

	That is not acceptable.  We don't introduce known bugs and say
they are OK if they are rare.

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
