From: Gang He <ghe@suse.com>
Date: Tue, 23 May 2017 20:05:44 -0600
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix a static checker warning
In-Reply-To: <20170523153023.9831db2fd6d5403445509cf3@linux-foundation.org>
References: <1495516634-1952-1-git-send-email-ghe@suse.com>
	<20170523153023.9831db2fd6d5403445509cf3@linux-foundation.org>
Message-ID: <59255AF8020000F900077D21@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, mfasheh@versity.com, linux-kernel@vger.kernel.org

Hello Andrew,

I am sorry that I did not write which static code checker tool, since I did not get the name from Dan, I think the tool should be like Coverity code checking tool.
Second, set the initial value of local variable rc to -ESTALE from zero, this change will make the code logic is strict consistent with before the  commit d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check"), although it is very difficult to meet this problem in the real environment. 


Thanks
Gang 


>>> 
> On Tue, 23 May 2017 13:17:14 +0800 Gang He <ghe@suse.com> wrote:
> 
>> This patch will fix a static code checker warning, which looks 
>> like below,
>> fs/ocfs2/inode.c:179 ocfs2_iget()
>> warn: passing zero to 'ERR_PTR'
>> 
>> this warning was caused by the 
>> commit d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check").
>> after apply this patch, the error return value will not be NULL(zero).
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 382401d..1a1e007 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -136,7 +136,7 @@ struct inode *ocfs2_ilookup(struct super_block *sb, u64 
> blkno)
>>  struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned 
> flags,
>>  			 int sysfile_type)
>>  {
>> -	int rc = 0;
>> +	int rc = -ESTALE;
>>  	struct inode *inode = NULL;
>>  	struct super_block *sb = osb->sb;
>>  	struct ocfs2_find_inode_args args;
> 
> hm, OK, thanks.  The resulting code still looks rather weird.  Could
> someone who works in this area please take a look?
