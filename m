From: yangwenfang <vicky.yangwenfang@huawei.com>
Date: Mon, 22 Dec 2014 20:01:56 +0800
Subject: [Ocfs2-devel] [patch 03/15] ocfs2: call
 ocfs2_journal_access_di() before ocfs2_journal_dirty() in
 ocfs2_write_end_nolock()
In-Reply-To: <20141217230032.GS7238@wotan.suse.de>
References: <548f65d1.4P/QIizRlX/OfJ/p%akpm@linux-foundation.org>
	<20141217133331.282ffc6f592fb329f3b7edad@linux-foundation.org>
	<20141217230032.GS7238@wotan.suse.de>
Message-ID: <54980834.7040006@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/12/18 7:00, Mark Fasheh wrote:
> On Wed, Dec 17, 2014 at 01:33:31PM -0800, Andrew Morton wrote:
>>
>> So I now have a mess on my hands due to reordering
>> ocfs2-fix-journal-commit-deadlock.patch ahead of this patch.
>>
>> It concerns the label "out:".  Should it be placed before or after the
>> call to ocfs2_unlock_pages()?
>>
>> My current copy of ocfs2_write_end_nolock() is below, followed by my
>> current version of
>> ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
> 
> You want "out:" after ocfs2_unlock_pages() to give us a chance to free any
> locked pages on the write contesxt.
> 
> Btw, I have the following notes for this patch:
> 
> 
> Putting the journal_access_di in ocfs2_write_end is the correct thing to do,                                                  
> thanks. I think we want to keep the journal_access_di in ocfs2_write_begin                                                    
> though as we may change the disk inode when marking unwritten extents                                                         
> (see the call to ocfs2_mark_extent_written()). So:                                                                            
>                                                                                                                               
> - I would remove the comment above journal_access_di in write_begin but not                                                   
>   the actual call as we may dirty the inode buffer later.                                                                     
>
Hi, Mark,
About this patch, do you mean that: keep the journal_access_di() in ocfs2_write_begin,
and call journal_access_di() in the top ocfs2_write_end() again?
But I don't think it as a good idea. In some scenario, jbd2_journal_restart() might be
called after we call ocfs2_journal_access_di. and jbd2_journal_commit_transaction()
will commit the transaction. So calling ocfs2_journal_access_di() in ocfs2_write_end()
will lead to buffer_uptodate(bh) == 0, so BUG.

Am I right?

Thanks,
yangwenfang

> - Move the call to journal_access_di to the top of ocfs2_write_end_nolock as                                                  
>   I believe you might be missing some inode buffer updates there too.                                                         
> 
> 
> Thanks Andrew,
> 	--Mark
> 
> --
> Mark Fasheh
> 
> .
> 
