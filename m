From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 23:19:11 -0700
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Make ocfs2_extent_tree
	get/put instead of	alloc.
In-Reply-To: <48ACE71C.4000700@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-4-git-send-email-joel.becker@oracle.com>
	<48ACE71C.4000700@oracle.com>
Message-ID: <20080821061911.GB17607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 11:55:08AM +0800, TaoMa wrote:
> Joel Becker wrote:
>> Rather than allocating a struct ocfs2_extent_tree, just put it on the
>> stack.  Fill it with ocfs2_get_extent_tree() and drop it with
>> ocfs2_put_extent_tree().  Now the callers don't have to ENOMEM, yet
>> still safely ref the root_bh.
>>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>

>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -223,22 +223,17 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
>>  	.eo_sanity_check	= ocfs2_xattr_tree_sanity_check,
>>  };
>>  
>>
>>  -static void ocfs2_free_extent_tree(struct ocfs2_extent_tree *et)
>> +static void ocfs2_put_extent_tree(struct ocfs2_extent_tree *et)
>>  {
>> -	if (et) {
>> -		brelse(et->et_root_bh);
>> -		kfree(et);
>> -	}
>> +	brelse(et->et_root_bh);
>>  }
>>   
> Can we inline this since it is just a one-line function?

	No, because it's going to be an exported function in the last
patch.  Plus, inlining is kind of pointless - we're not on any fastpaths
here.  Inlining isn't always necessary, and shouldn't be the default for
all tiny functions.  For something like this, gcc might even figure it
out.

>>  @@ -4906,11 +4873,13 @@ int ocfs2_mark_extent_written(struct inode 
>> *inode, struct buffer_head *root_bh,
>>  	struct ocfs2_extent_rec split_rec;
>>  	struct ocfs2_path *left_path = NULL;
>>  	struct ocfs2_extent_list *el;
>> -	struct ocfs2_extent_tree *et = NULL;
>> +	struct ocfs2_extent_tree et;
>>   	mlog(0, "Inode %lu cpos %u, len %u, phys %u (%llu)\n",
>>  	     inode->i_ino, cpos, len, phys, (unsigned long long)start_blkno);
>>  +	ocfs2_get_extent_tree(&et, inode, root_bh, et_type, private);
>> +
>>  	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
>>  		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
>>  			    "that are being written to, but the feature bit "
>> @@ -4920,13 +4889,6 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
>>  		goto out;
>>  	}
>>  -	et = ocfs2_new_extent_tree(inode, root_bh, et_type, private);
>> -	if (!et) {
>> -		ret = -ENOMEM;
>> -		mlog_errno(ret);
>> -		goto out;
>> -	}
>> -
>>   
> I think you can get the extent tree here, since if the above judgement  
> returns error, we can go out directly without initializing the extent 
> tree.

	I do it up top because I unconditionally put it at the bottom.
This is a brelse(), which needs the matching get_bh().  Since we're
munging a stack variable, it doesn't hurt us to do the get_extent_tree()
at the top.

Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
