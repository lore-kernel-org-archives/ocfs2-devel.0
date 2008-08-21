From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 23:21:52 -0700
Subject: [Ocfs2-devel] [PATCH 06/10] ocfs2: Use struct ocfs2_extent_tree
	in	ocfs2_num_free_extents().
In-Reply-To: <48ACEAAD.3070907@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-7-git-send-email-joel.becker@oracle.com>
	<48ACEAAD.3070907@oracle.com>
Message-ID: <20080821062152.GD17607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 12:10:21PM +0800, TaoMa wrote:
> Joel Becker wrote:
>> ocfs2_num_free_extents() re-implements the logic of
>> ocfs2_get_extent_tree().  Now that ocfs2_get_extent_tree() does not
>> allocate, let's use it in ocfs2_num_free_extents() to simplify the code.
>>
>> The inode validation code in ocfs2_num_free_extents() is not needed.
>> All callers are passing in pre-validated inodes.
>>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>> ---
>>  fs/ocfs2/alloc.c |   30 +++++-------------------------
>>  1 files changed, 5 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index fb6ae67..0b900f6 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -618,34 +618,13 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
>>  	struct ocfs2_extent_block *eb;
>>  	struct buffer_head *eb_bh = NULL;
>>  	u64 last_eb_blk = 0;
>> +	struct ocfs2_extent_tree et;
>>   	mlog_entry_void();
>>  -	if (type == OCFS2_DINODE_EXTENT) {
>> -		struct ocfs2_dinode *fe =
>> -				(struct ocfs2_dinode *)root_bh->b_data;
>> -		if (!OCFS2_IS_VALID_DINODE(fe)) {
>> -			OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
>> -			retval = -EIO;
>> -			goto bail;
>> -		}
>> -
>> -		if (fe->i_last_eb_blk)
>> -			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
>> -		el = &fe->id2.i_list;
>> -	} else if (type == OCFS2_XATTR_VALUE_EXTENT) {
>> -		struct ocfs2_xattr_value_root *xv =
>> -			(struct ocfs2_xattr_value_root *) obj;
>> -
>> -		last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
>> -		el = &xv->xr_list;
>> -	} else if (type == OCFS2_XATTR_TREE_EXTENT) {
>> -		struct ocfs2_xattr_block *xb =
>> -			(struct ocfs2_xattr_block *)root_bh->b_data;
>> -
>> -		last_eb_blk = le64_to_cpu(xb->xb_attrs.xb_root.xt_last_eb_blk);
>> -		el = &xb->xb_attrs.xb_root.xt_list;
>> -	}
>> +	ocfs2_get_extent_tree(&et, inode, root_bh, type, obj);
>>   
> call eo_sanity_check first may be better since there is a check above in  
> OCFS2_DINODE_EXTENT.

	Every dinode caller has already checked the inode.  I looked at
them before I removed the IS_VALID_INODE().  That's what I meant in the
commit message.

Joel

-- 

"It is not the function of our government to keep the citizen from
 falling into error; it is the function of the citizen to keep the
 government from falling into error."
	- Robert H. Jackson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
