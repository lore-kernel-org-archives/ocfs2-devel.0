From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 27 Oct 2008 23:14:53 -0700
Subject: [Ocfs2-devel] [PATCH 06/13] ocfs2: Improve
	ocfs2_read_xattr_bucket().
In-Reply-To: <49067C93.3050307@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
	<1225156828-32189-7-git-send-email-joel.becker@oracle.com>
	<49067C93.3050307@oracle.com>
Message-ID: <20081028061453.GA7778@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 28, 2008 at 10:44:35AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>> @@ -3128,7 +3145,7 @@ static int ocfs2_half_xattr_bucket(struct inode 
>> *inode,
>>  	int ret, i;
>>  	u16 count, start, len, name_value_len, xe_len, name_offset;
>>  	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>> -	struct buffer_head **s_bhs, **t_bhs = NULL;
>> +	struct ocfs2_xattr_bucket s_bucket, t_bucket;
>>  	struct ocfs2_xattr_header *xh;
>>  	struct ocfs2_xattr_entry *xe;
>>  	int blocksize = inode->i_sb->s_blocksize;
> snip
>> -	t_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
>> -	if (!t_bhs) {
>> -		ret = -ENOMEM;
>> -		goto out;
>> -	}
>> -
>> -	ret = ocfs2_read_xattr_bucket(inode, new_blk, t_bhs, new_bucket_head);
>> +	/*
>> +	 * Even if !new_bucket_head, we're overwriting t_bucket.  Thus,
>> +	 * there's no need to read it.
>> +	 */
>> +	ret = ocfs2_init_xattr_bucket(inode, &t_bucket, new_blk);
>>  	if (ret) {
>>  		mlog_errno(ret);
>>  		goto out;
>>  	}
>>   	for (i = 0; i < blk_per_bucket; i++) {
>> -		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
>> +		ret = ocfs2_journal_access(handle, inode, t_bucket.bu_bhs[i],
>>  					   new_bucket_head ?
>>  					   OCFS2_JOURNAL_ACCESS_CREATE :
>>  					   OCFS2_JOURNAL_ACCESS_WRITE);
> I have read the caller of ocfs2_half_xattr_bucket again. In 
> ocfs2_extend_xattr_bucket when we want to half the bucket to a never-used 
> new bucket within the same cluster(while we always pass new_bucket_head=0), 
> do we need to use OCFS2_JOURNAL_ACCESS_CREATE? If yes, maybe we have to 
> modify the caller to be more precisely(I can handle this based on your 
> patch set). The same goes for ocfs2_cp_xattr_bucket.

	Mark and I were discussing this on #ocfs2 just today.  We were
having a hard time understanding the condition of the bucket - what
new_bucket_head really means.  This comes from my patch to set the
JOURNAL_ACCESS based on the new_bucket_head value (same in
cp_xattr_bucket).
	Is the target bucket (t_bucket) always in the same cluster for
all callers regardless of new_bucket_head?  Has it ever been written
before?  May it have been allocated a long time ago?

Joel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
