From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 28 Dec 2010 23:38:00 +0800
Subject: [Ocfs2-devel] [PATCH 2/8] Ocfs2: Add basic framework and source
 files for extent moving.
In-Reply-To: <4D19FE23.1050900@tao.ma>
References: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
	<1293536448-20516-3-git-send-email-tristan.ye@oracle.com>
	<4D19FE23.1050900@tao.ma>
Message-ID: <4D1A0458.5020700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/28/2010 11:11 PM, Tao Ma wrote:
> Hi Tristan,
>     Some comments inlined.

Tao,

     It's good to see your comments here, very nice;)


> On 12/28/2010 07:40 PM, Tristan Ye wrote:
> <snip>
>> +static int ocfs2_move_extents(struct ocfs2_move_extents_context 
>> *context)
>> +{
>> +    int status;
>> +    handle_t *handle;
>> +    struct inode *inode = context->inode;
>> +    struct buffer_head *di_bh = NULL;
>> +    struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +
>> +    if (!inode)
>> +        return -ENOENT;
>> +
>> +    if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
>> +        return -EROFS;
>> +
>> +    mutex_lock(&inode->i_mutex);
>> +
>> +    /*
>> +     * This prevents concurrent writes from other nodes
>> +     */
>> +    status = ocfs2_rw_lock(inode, 1);
>> +    if (status) {
>> +        mlog_errno(status);
>> +        goto out;
>> +    }
>> +
>> +    status = ocfs2_inode_lock(inode,&di_bh, 1);
>> +    if (status) {
>> +        mlog_errno(status);
>> +        goto out_rw_unlock;
>> +    }
>> +
>> +    /*
>> +     * rememer ip_xattr_sem also needs to be held if necessary
>> +     */
>> +    down_write(&OCFS2_I(inode)->ip_alloc_sem);
>> +
>> +    /*
>> +     * real extents moving codes will be fulfilled later.
>> +     *
>> +     * status = __ocfs2_move_extents_range(di_bh, context);
>> +     */
> OK, so this function does nothing by now? ;)

Actually, this function will be added in following patches, I commented 
this for a better understanding ONLY.

So without collecting the last patch, it did nothing actually;-)

>> +
>> +    up_write(&OCFS2_I(inode)->ip_alloc_sem);
>> +    if (status) {
>> +        mlog_errno(status);
>> +        goto out_inode_unlock;
>> +    }
>> +
>> +    /*
>> +     * We update mtime for these changes
>> +     */
>> +    handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>> +    if (IS_ERR(handle)) {
>> +        status = PTR_ERR(handle);
>> +        mlog_errno(status);
>> +        goto out_inode_unlock;
>> +    }
>> +
>> +    inode->i_mtime = CURRENT_TIME;
>> +    status = ocfs2_mark_inode_dirty(handle, inode, di_bh);
> We really need such a heavy function in case you just want to set 
> di->i_mtime and di->i_mtime_nsec?


These above codes were almost borrowed from __ocfs2_change_file_space(), 
it just called
ocfs2_mark_inode_dirty() when updating the mtime/ctime.

Maybe you're right, I'll rethink about it.


>> +    if (status<  0)
>> +        mlog_errno(status);
>> +
>> +    ocfs2_commit_trans(osb, handle);
>> +
>> +out_inode_unlock:
>> +    brelse(di_bh);
>> +    ocfs2_inode_unlock(inode, 1);
>> +out_rw_unlock:
>> +    ocfs2_rw_unlock(inode, 1);
>> +out:
>> +    mutex_unlock(&inode->i_mutex);
>> +
>> +    return status;
>> +}
>> +
>> +int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>> +{
>> +    int status;
>> +
>> +    struct inode *inode = filp->f_path.dentry->d_inode;
>> +    struct ocfs2_move_extents range;
>> +    struct ocfs2_move_extents_context *context = NULL;
>> +
>> +    status = mnt_want_write(filp->f_path.mnt);
>> +    if (status)
>> +        return status;
>> +
>> +    status = -EINVAL;
>> +
>> +    if (!S_ISREG(inode->i_mode)) {
>> +        goto out;
>> +    } else {
>> +        if (!(filp->f_mode&  FMODE_WRITE))
>> +            goto out;
>> +    }
> these can be just changed to:
>     if (!S_ISREG(inode->i_mode) || !(filp->f_mode & FMODE_WRITE))
>         goto out;

Good point.

>> +
>> +    if (inode->i_flags&  (S_IMMUTABLE|S_APPEND)) {
>> +        status = -EPERM;
>> +        goto out;
>> +    }
>> +
>> +    context = kzalloc(sizeof(struct ocfs2_move_extents_context), 
>> GFP_NOFS);
>> +    if (!context) {
>> +        status = -ENOMEM;
>> +        mlog_errno(status);
>> +        goto out;
>> +    }
>> +
>> +    context->inode = inode;
>> +    context->file = filp;
>> +
>> +    if (!argp) {
>> +        memset(&range, 0, sizeof(range));
>> +        range.me_len = (u64)-1;
>> +        range.me_flags |= OCFS2_MOVE_EXT_FL_AUTO_DEFRAG;
>> +        context->auto_defrag = 1;
>> +    } else {
>> +        if (copy_from_user(&range, (struct ocfs2_move_extents *)argp,
>> +                   sizeof(range))) {
>> +            status = -EFAULT;
>> +            goto out;
>> +        }
>> +    }
>> +
>> +    context->range =&range;
>> +
>> +    if (range.me_flags&  OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
>> +        context->auto_defrag = 1;
>> +        if (!range.me_thresh)
>> +            range.me_thresh = 1024 * 1024;
>> +    } else {
>> +        /*
>> +         * TO-DO XXX: validate the range.me_goal here.
>> +         *
>> +         * - should be cluster aligned.
>> +         * - should contain enough free clusters around range.me_goal.
>> +         * - strategy of moving extent to an appropriate goal is still
>> +         *   being discussed.
>> +         */
>> +    }
>> +
>> +    /*
>> +     * returning -EINVAL here.
>> +     */
>> +    if (range.me_start>  i_size_read(inode))
> Do we allow overlap here? If no, I guess it should be
>     if (range.me_start + range.me_len > i_size_read(inode))


What did you mean? 'range.me_start + range.me_len>  i_size_read(inode)' 
will be judged by following codes,


It has nothing to do with the overlap issue, range.me_start was not 
range.me_new_start;)

>> +        goto out;
>> +
>> +    if (range.me_start + range.me_len>  i_size_read(inode))
>> +            range.me_len = i_size_read(inode) - range.me_start;
>> +
>> +    status = ocfs2_move_extents(context);
>> +    if (status)
>> +        mlog_errno(status);
>> +
>> +    if (argp) {
>> +        if (copy_to_user((struct ocfs2_move_extents *)argp,&range,
>> +                sizeof(range)))
>> +            status = -EFAULT;
>> +    }
>> +out:
>> +    mnt_drop_write(filp->f_path.mnt);
>> +
>> +    kfree(context);
>> +
>> +    return status;
>> +}
>
> Regards,
> Tao
