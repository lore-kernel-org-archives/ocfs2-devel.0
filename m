From: Younger Liu <younger.liu@huawei.com>
Date: Fri, 28 Jun 2013 14:30:27 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: need rollback when
 journal_access failed in ocfs2_orphan_add()
In-Reply-To: <20130626144939.7c0a916c3bd507b3c6926e6a@linux-foundation.org>
References: <51C2B662.2000206@huawei.com>
	<20130626144939.7c0a916c3bd507b3c6926e6a@linux-foundation.org>
Message-ID: <51CD2D83.1050607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/27 5:49, Andrew Morton wrote:
> On Thu, 20 Jun 2013 15:59:30 +0800 Younger Liu <younger.liu@huawei.com> wrote:
> 
>> While adding a file into orphan dir in ocfs2_orphan_add(),
>> it calls __ocfs2_add_entry() before ocfs2_journal_access_di(). 
>> If ocfs2_journal_access_di() failed, the file is added into 
>> orphan dir, and orphan dir dinode updated, but file dinode 
>> has not been updated.
>> Accordingly, the data is not consistent between file dinode 
>> and orphan dir.
>>
>> So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(),
>> and if ocfs2_journal_access_di() failed, orphan_fe and 
>> orphan_dir_inode->i_nlink need rollback. 
>>
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -2012,6 +2012,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
> 
> ocfs2_orphan_add() will call mlog_errno(status) two times for the same
> error in many cases.  That's not a big problem, but is sloppy and asks
> for a cleanup.
> 
> 
> 
Thanks for your review, I will resent the patch in a moment.
					Younger 
