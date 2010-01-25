From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 25 Jan 2010 10:42:22 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Treat ocfs2 truncate as a
 special case of punching holes v1.
In-Reply-To: <4B5D02B3.5080303@oracle.com>
References: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
	<4B5CFE12.9010503@oracle.com> <4B5D02B3.5080303@oracle.com>
Message-ID: <4B5D050E.2020204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



tristan wrote:
> Wow, thanks for such quick review:)
> 
> Tao Ma wrote:
>> Hi Tristan,
>>     Thanks for the work.
>>     Some comments inlined.
>>> +        if (phys_cpos != 0) {
>>> +            status = ocfs2_remove_btree_range(inode, &et, cpos,
>>> +                              phys_cpos, alloc_size,
>>> +                              &tc->tc_dealloc);
>>> +            if (status) {
>>> +                mlog_errno(status);
>>> +                goto bail;
>>> +            }
>>> +        }
>> I would really appreciate it if we can start from the end to the 
>> beginning. You know, if we start from cpos, when we remove an extent, 
>> the b-tree codes will try to rotate_tree_left. So if there are many 
>> extents for us to truncate, the performance will decrease a lot. While 
>> in the old implementation, we remove extents from the tail, so no 
>> b-tree rotation at all.
> 
> Wow, it's a significant improvement! great catch, tao.
> 
> I just copied idea from punching holes code, it also starts from begin 
> to end, as what you said, maybe we can also do the same improvement for 
> existing punching holes code, to remove the extents from end to begin. 
> how do you think about it?
yeah, actually we can improve the punching holes code also if you can 
provide a fantastic performance number. ;)

Regards,
Tao
