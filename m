From: Tristan Ye <tristan.ye@oracle.com>
Date: Wed, 29 Dec 2010 14:30:59 +0800
Subject: [Ocfs2-devel] [PATCH 2/8] Ocfs2: Add basic framework and source
 files for extent moving.
In-Reply-To: <20101229054550.GA12275@laptop.jp.oracle.com>
References: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
	<1293536448-20516-3-git-send-email-tristan.ye@oracle.com>
	<4D19FE23.1050900@tao.ma> <4D1A0458.5020700@oracle.com>
	<20101229054550.GA12275@laptop.jp.oracle.com>
Message-ID: <4D1AD5A3.9060605@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> Hi,
>
> On 10-12-28 23:38, Tristan Ye wrote:
>> On 12/28/2010 11:11 PM, Tao Ma wrote:
>>
>>>> +
>>>> +    up_write(&OCFS2_I(inode)->ip_alloc_sem);
>>>> +    if (status) {
>>>> +        mlog_errno(status);
>>>> +        goto out_inode_unlock;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * We update mtime for these changes
>>>> +     */
>>>> +    handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>>>> +    if (IS_ERR(handle)) {
>>>> +        status = PTR_ERR(handle);
>>>> +        mlog_errno(status);
>>>> +        goto out_inode_unlock;
>>>> +    }
>>>> +
>>>> +    inode->i_mtime = CURRENT_TIME;
>>>> +    status = ocfs2_mark_inode_dirty(handle, inode, di_bh);
>>> We really need such a heavy function in case you just want to set 
>>> di->i_mtime and di->i_mtime_nsec?
>>
>> These above codes were almost borrowed from __ocfs2_change_file_space(), 
>> it just called
>> ocfs2_mark_inode_dirty() when updating the mtime/ctime.
>>
>> Maybe you're right, I'll rethink about it.
>>
>
> Do we really need to update modify time or change time?
> modify time is "Time of last file write". no need I think since it's not a
> write(no touch on file contents).
> change time is "Time of last inode change". I think here, the inode
> status includes mode, gid, uid, size, ino..... no change in those area,
> right? so I guess no need to update mtime nor ctime.
>
> Also, even we need to update them, shall we check a status of the
> __ocfs2_move_extents_range() whether there is really a movement. think
> the case another node just finished defragmenting on this file.

    Actually I borrowed these codes from ocfs2_change_file_space()
at the very beginning, your comments did make sense, but wait, 
dedragmentation
has the possibility of changing dinode a bit,  it's the btree root, right?

    mtime may not be updated as you said;)


>
> And likely we have modified di_bh in __ocfs2_move_extents_range() and
> journaled it(though not checked yet). So if need, we'd better merge the
> transactins

Good point.
   
>
> BTW, just a thought, not checked all, do we only allow root to do this?
> Seems no security risk for the task to FS its self... attacks?

    I did allow ordinary users to do this in this patch, didn't I?

>
> thanks,
> wengang.
