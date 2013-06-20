From: Li Zefan <lizefan@huawei.com>
Date: Thu, 20 Jun 2013 09:42:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: need rollback when journal_access
 failed in ocfs2_orphan_add()
In-Reply-To: <51C25A0E.8070702@huawei.com>
References: <51C17263.5020601@huawei.com> <51C18DB7.4090003@oracle.com>
	<51C25A0E.8070702@huawei.com>
Message-ID: <51C25DEA.6060608@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

? 2013/6/20 9:25, Younger Liu ??:
> Hi Jeff
> 
> On 2013/6/19 18:53, Jeff Liu wrote:
>> Hey Younger,
>>
>> On 06/19/2013 04:57 PM, Younger Liu wrote:
>>
>>> While adding a file into orphan dir in ocfs2_orphan_add(),
>>> it calls __ocfs2_add_entry() before ocfs2_journal_access_di(). 
>>> If ocfs2_journal_access_di() failed, the file is added into 
>>> orphan dir, and orphan dir dinode updated, but file dinode 
>>> has not been updated.
>>> Accordingly, the data is not consistent between file dinode 
>>> and orphan dir.
>>>
>>> So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(),
>>> and if ocfs2_journal_access_di() failed, orphan_fe and 
>>> orphan_dir_inode->i_nlink need rollback.
>>
>> Yes, and this has been introduced by commits 3939fda4.
> 
> I do not find the patch with 3939fda4. Can you tell me the link?
> Thanks.
> 

# git show 3939fda4
commit 3939fda4b389993caf8741df5739b3e49f33a263
Author: Tristan Ye <tristan.ye@oracle.com>
Date:   Fri Mar 19 09:21:09 2010 +0800

    Ocfs2: Journaling i_flags and i_orphaned_slot when adding inode to orphan dir.

    Currently, some callers were missing to journal the dirty inode after
    adding it to orphan dir.

    Now we're going to journal such modifications within the ocfs2_orphan_add()
    itself, It's safe to do so, though some existing caller may duplicate this,
    and it makes the logic look more straightforward anyway.

    Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
    Signed-off-by: Joel Becker <joel.becker@oracle.com>
