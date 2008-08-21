From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 23:23:30 -0700
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Determine an extent
	tree's	max_leaf_clusters in an et_op.
In-Reply-To: <48ACEB5B.5030903@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-8-git-send-email-joel.becker@oracle.com>
	<48ACEB5B.5030903@oracle.com>
Message-ID: <20080821062329.GE17607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 12:13:15PM +0800, TaoMa wrote:
> Joel Becker wrote:
>> Provide an optional extent_tree_operation to specify the
>> max_leaf_clusters of an ocfs2_extent_tree.  If not provided, the value
>> is 0 (unlimited).
>>

<snip>

>> @@ -265,11 +275,13 @@ static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
>>  		et->et_ops = &ocfs2_xattr_et_ops;
>>  	} else if (et_type == OCFS2_XATTR_TREE_EXTENT) {
>>  		et->et_ops = &ocfs2_xattr_tree_et_ops;
>> -		et->et_max_leaf_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
>> -						OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
>>  	}
>>   	et->et_ops->eo_fill_root_el(et);
>> +	if (!et->et_ops->eo_fill_max_leaf_clusters)
>> +		et->et_max_leaf_clusters = 0;
>> +	else
>> +		et->et_ops->eo_fill_max_leaf_clusters(inode, et);
>>  }
>>   
> Like what you have done in patch 1/10, maybe we can add a small wrapper  
> named ocfs2_et_fill_max_leaf_clusters for this?

	I did it that way at first, but then I decided to make the
eo_fill_*() functions not have an accessor, because they are internal to
get_extent_tree().  They can only be called from there.
	I'm open to changing it.  It jwas just a thought.

Joel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
