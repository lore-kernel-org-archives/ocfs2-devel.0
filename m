From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 30 Mar 2018 00:50:06 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't evaluate buffer head to NULL
 managed by caller
References: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
	<20180329144523.91722a7b35c8ad17d3f1375e@linux-foundation.org>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2958D26@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "mfasheh@versity.com" <mfasheh@versity.com>, "jiangqi903@gmail.com" <jiangqi903@gmail.com>, "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "piaojun@huawei.com" <piaojun@huawei.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

Hi Andrew,

On 2018/3/30 5:45, Andrew Morton wrote:
> On Thu, 29 Mar 2018 10:06:02 +0800 Changwei Ge <ge.changwei@h3c.com> wrote:
> 
>> ocfs2_read_blocks() is used to read several blocks from disk.
>> Currently, the input argument *bhs* can be NULL or NOT. It depends on
>> the caller's behavior. If the function fails in reading blocks from
>> disk, the corresponding bh will be assigned to NULL and put.
>>
>> Obviously, above process for non-NULL input bh is not appropriate.
>> Because the caller doesn't even know its bhs are put and re-assigned.
>>
>> If buffer head is managed by caller, ocfs2_read_blocks should not
>> evaluate it to NULL. It will cause caller accessing illegal memory,
>> thus crash.
> 
> (What about ocfs2_read_blocks_sync()?)

ocfs2_read_blocks_sync() seems to have the same issue,too.

> 
> Passing non-NULL entries in bhs[] looks like a weird thing to do.  Do
> any callers actually do this?  And of they do, do they actually care

Yes, some callers actually pass non-NULL entries in bhs[].
In ocfs2, _slot map_ keeps the mapping relationship between *node number* and 
*slot number* which identifies a dedicated disk resource(usually metadata or 
journal).

_Slot map_ is loaded from disk during mount in function ocfs2_map_slot_buffers() 
where ->si_bh[] are allocated with NULL filled. Then it invokes 
ocfs2_read_blocks() to read a block from disk and assign the returned bh to 
->si_bh[i].

If ocfs2 needs to refresh _slot map_ via ocfs2_refresh_slot_info(), ->si_bh is 
directly passed in. So the weird thing happens. :(

> about the alteration of bhs[] if the call failed?

Unfortunately, the alternation is ignored and that's what my patch wants to fix.

A thing deserved to be noticed is that a caller may pass bhs[] with mixed NULL 
and non-NULL entries in. That really bothers me, so I add a WARN check to notice 
the caller to pass a proper pattern of bhs[] in. After that, ocfs2_read_blocks() 
can handle read failure easily.
And do you have any advice for how to fix this?

Thanks,
Changwei

> 
> 
