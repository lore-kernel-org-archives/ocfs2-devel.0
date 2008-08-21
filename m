From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 21 Aug 2008 10:46:41 -0700
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: Make ocfs2_extent_tree the
	first-class	representation of a tree.
In-Reply-To: <48AD1D5C.8000803@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-11-git-send-email-joel.becker@oracle.com>
	<48AD1D5C.8000803@oracle.com>
Message-ID: <20080821174641.GK17607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 03:46:36PM +0800, TaoMa wrote:
>>    @@ -1236,10 +1241,11 @@ static int __ocfs2_remove_inode_range(struct 
>> inode *inode,
>>  	handle_t *handle;
>>  	struct ocfs2_alloc_context *meta_ac = NULL;
>>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>> +	struct ocfs2_extent_tree et;
>> +
>> +	ocfs2_get_dinode_extent_tree(&et, inode, di_bh);
>>  -	ret = ocfs2_lock_allocators(inode, di_bh, &di->id2.i_list,
>> -				    0, 1, NULL, &meta_ac,
>> -				    OCFS2_DINODE_EXTENT, NULL);
>> +	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
>>  	if (ret) {
>>  		mlog_errno(ret);
>>  		return ret;
>>   
> here you need to ocfs2_put_dinoe_extent_tree and I see no put in the end  
> of the function.

	Good catch.  Here's the on-top diff:

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1f31a99..c49d2f3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1247,6 +1247,7 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 
 	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
 	if (ret) {
+		ocfs2_put_extent_tree(&et);
 		mlog_errno(ret);
 		return ret;
 	}
@@ -1303,6 +1304,7 @@ out:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
+	ocfs2_put_extent_tree(&et);
 	return ret;
 }
 
>> @@ -1269,8 +1275,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
>>  		goto out;
>>  	}
>>  -	ret = ocfs2_remove_extent(inode, di_bh, cpos, len, handle, meta_ac,
>> -				  dealloc, OCFS2_DINODE_EXTENT, NULL);
>> +	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, meta_ac,
>> +				  dealloc);
>>  	if (ret) {
>>  		mlog_errno(ret);
>>  		goto out_commit;
>>   
> btw, I like your abstraction.

	It's your abstraction in the first place.  I just liked it so
much I promoted it to public view.  But thank you :-)

Joel

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
