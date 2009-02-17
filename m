From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Feb 2009 21:34:53 -0800
Subject: [Ocfs2-devel] [PATCH 05/40] ocfs2: move ip_created_trans to
	struct	ocfs2_caching_info
In-Reply-To: <4998BCCF.8070906@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
	<1234563387-17101-6-git-send-email-joel.becker@oracle.com>
	<4998BCCF.8070906@oracle.com>
Message-ID: <20090217053452.GA5489@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 16, 2009 at 09:09:35AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>> Similar ip_last_trans, ip_created_trans tracks the creation of a journal
>> managed inode.  This specifically tracks what transaction created the
>> inode.  This is so the code can know if the inode has ever been written
>> to disk.
>>
>> This behavior is desirable for any journal managed object.  We move it
>> to struct ocfs2_caching_info as ci_created_trans so that any object
>> using ocfs2_caching_info can rely on this behavior.
>>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> <snip>
>> index ef75dbb..ff4b526 100644
>> --- a/fs/ocfs2/journal.h
>> +++ b/fs/ocfs2/journal.h
>> @@ -118,9 +118,9 @@ static inline int ocfs2_inode_is_new(struct inode *inode)
>>  		return 0;
>>  	spin_lock(&trans_inc_lock);
>>  	ret = !(time_after(OCFS2_SB(inode->i_sb)->journal->j_trans_id,
>> -			   OCFS2_I(inode)->ip_created_trans));
>> +			   INODE_CACHE(inode)->ci_created_trans));
>>  	if (!ret)
>> -		OCFS2_I(inode)->ip_created_trans = 0;
>> +		INODE_CACHE(inode)->ci_created_trans = 0;
>>  	spin_unlock(&trans_inc_lock);
>>  	return ret;
>>  }
> A question unrelated to your modification. Why we use "!time_after" and  
> then check "!ret". I guess a "time_after" and "ret" is ok.

	I presume because we're returning ret to the caller.  We want
ret to be 1 if the time_after() is false.

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
