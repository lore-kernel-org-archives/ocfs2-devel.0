From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 27 Oct 2008 18:53:59 -0700
Subject: [Ocfs2-devel] [PATCH 09/13] ocfs2: Take ocfs2_xattr_bucket
	structures off of	the stack.
In-Reply-To: <49066FD4.40809@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
	<1225156828-32189-10-git-send-email-joel.becker@oracle.com>
	<49066FD4.40809@oracle.com>
Message-ID: <20081028015359.GE25974@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 28, 2008 at 09:50:12AM +0800, Tao Ma wrote:
>
>
> Joel Becker wrote:
>> The ocfs2_xattr_bucket structure is a nice abstraction, but it is a bit
>> large to have on the stack.  Just like ocfs2_path, let's allocate it
>> with a ocfs2_xattr_bucket_new() function.
>>
>> We can now store the inode on the bucket, cleaning up all the other
>> bucket functions.  While we're here, we catch another place or two that
>> wasn't using ocfs2_read_xattr_bucket().
>>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>> ---
>
>> +
>> +static void ocfs2_xattr_bucket_relse(struct ocfs2_xattr_bucket *bucket)
>>  {
>> -	int i, blks = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>> +	int i;
>>  -	for (i = 0; i < blks; i++) {
>> +	for (i = 0; i < bucket->bu_blocks; i++) {
>>  		brelse(bucket->bu_bhs[i]);
>>  		bucket->bu_bhs[i] = NULL;
>>  	}
>>  }
>>  +static void ocfs2_xattr_bucket_free(struct ocfs2_xattr_bucket 
>> *bucket)
>> +{
>> +	if (bucket) {
>> +		ocfs2_xattr_bucket_relse(bucket);
>> +		bucket->bu_inode = NULL;
> we need "kfree(bucket)" here.

	Yes we do!  I screwed that up splitting the patches.  Thanks for
catching!

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
