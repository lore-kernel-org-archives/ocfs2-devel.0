From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Feb 2009 21:36:10 -0800
Subject: [Ocfs2-devel] [PATCH 04/40] ocfs2: move ip_last_trans to
	struct	ocfs2_caching_info
In-Reply-To: <4998BC46.2040908@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
	<1234563387-17101-5-git-send-email-joel.becker@oracle.com>
	<4998BC46.2040908@oracle.com>
Message-ID: <20090217053610.GB5489@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 16, 2009 at 09:07:18AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>> We have the read side of metadata caching isolated to struct
>> ocfs2_caching_info, now we need the write side.  This means the journal
>> functions.  The journal only does a couple of things with struct inode.
>>
>> This change moves the ip_last_trans field onto struct
>> ocfs2_caching_info as ci_last_trans.  This field tells the journal
>> whether a pending journal flush is required.
>>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>> ---
>>  fs/ocfs2/inode.c    |   10 +++++-----
>>  fs/ocfs2/inode.h    |    2 --
>>  fs/ocfs2/journal.h  |    5 +++--
>>  fs/ocfs2/ocfs2.h    |    4 ++++
>>  fs/ocfs2/super.c    |    1 -
>>  fs/ocfs2/uptodate.c |   22 +++++++++++++++++++---
>>  fs/ocfs2/uptodate.h |    1 +
>>  7 files changed, 32 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index fc55fcf..9cefa54 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1063,13 +1063,14 @@ void ocfs2_clear_inode(struct inode *inode)
>>  	ocfs2_lock_res_free(&oi->ip_inode_lockres);
>>  	ocfs2_lock_res_free(&oi->ip_open_lockres);
>>  -	ocfs2_metadata_cache_purge(INODE_CACHE(inode));
>> +	ocfs2_metadata_cache_exit(INODE_CACHE(inode));
>>  -	mlog_bug_on_msg(oi->ip_metadata_cache.ci_num_cached,
>> +	mlog_bug_on_msg(INODE_CACHE(inode)->ci_num_cached,
>>  			"Clear inode of %llu, inode has %u cache items\n",
>> -			(unsigned long long)oi->ip_blkno, oi->ip_metadata_cache.ci_num_cached);
>> +			(unsigned long long)oi->ip_blkno,
>> +			INODE_CACHE(inode)->ci_num_cached);
>>  -	mlog_bug_on_msg(!(oi->ip_metadata_cache.ci_flags &
>> +	mlog_bug_on_msg(!(INODE_CACHE(inode)->ci_flags &
>>  			  OCFS2_CACHE_FL_INLINE),
>>  			"Clear inode of %llu, inode has a bad flag\n",
>>  			(unsigned long long)oi->ip_blkno);
> These 2 lines(mlog) has nothing to do with your ip_last_trans, why  
> change them?  And if you really want to change it, it may be included in  
> the patch you add INODE_CACHE I guess?

	I do want to change it.  I thought I had it against the previous
patch.  Whoops?

Joel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
