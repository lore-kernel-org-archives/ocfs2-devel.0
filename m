From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 11 Dec 2008 08:31:09 +0800
Subject: [Ocfs2-devel] [PATCH 08/18] ocfs2: Use metadata-specific
 ocfs2_journal_access_*() functions.
In-Reply-To: <20081210111540.GB16888@ca-server1.us.oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<1228871395-10273-9-git-send-email-joel.becker@oracle.com>
	<493F2A16.5070109@oracle.com>
	<20081210111540.GB16888@ca-server1.us.oracle.com>
Message-ID: <49405F4D.60302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> 
>>> @@ -1918,25 +1966,23 @@ static int ocfs2_rotate_subtree_right(struct inode 
>>> *inode,
>>>  	root_bh = left_path->p_node[subtree_index].bh;
>>>  	BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
>>>  -	ret = ocfs2_journal_access(handle, inode, root_bh,
>>> -				   OCFS2_JOURNAL_ACCESS_WRITE);
>>> +	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
>>> +					   subtree_index);
>>>  	if (ret) {
>>>  		mlog_errno(ret);
>>>  		goto out;
>>>  	}
>>>   	for(i = subtree_index + 1; i < path_num_items(right_path); i++) {
>>> -		ret = ocfs2_journal_access(handle, inode,
>>> -					   right_path->p_node[i].bh,
>>> -					   OCFS2_JOURNAL_ACCESS_WRITE);
>>> +		ret = ocfs2_path_bh_journal_access(handle, inode,
>>> +						   right_path, i);
>>>  		if (ret) {
>>>  			mlog_errno(ret);
>>>  			goto out;
>>>  		}
>>>  -		ret = ocfs2_journal_access(handle, inode,
>>> -					   left_path->p_node[i].bh,
>>> -					   OCFS2_JOURNAL_ACCESS_WRITE);
>>> +		ret = ocfs2_path_bh_journal_access(handle, inode,
>>> +						   left_path, i);
>> I guess when can use ocfs2_journal_access_eb directly since it is 
>> "subtree_index+1" now. No chance of be the root. The same goes for 
>> ocfs2_rotate_subtree_left, ocfs2_merge_rec_right, ocfs2_merge_rec_left.
> 
> 	But then you start dereferencing the path bh list.  That's
> breaks the abstraction of the path structure.  It also drops the
> consistency of always using ocfs2_path_bh_journal_access() for paths.
> Conversely, there is no real loss to calling
> ocfs2_path_bh_journal_access(); the extra function call is
> insignificant.
fail enough. actually this piece of code make me think of the use of 
ocfs2_journal_access_eb.
in ocfs2_rotate_subtree_left:
	if (le16_to_cpu(right_leaf_el->l_next_free_rec) > 1) {
		ret = ocfs2_journal_access_eb(handle, inode,
					path_leaf_bh(right_path),
					OCFS2_JOURNAL_ACCESS_WRITE);
So according to your policy, we should change it to 
ocfs2_path_bh_journal_access also? ;)

> 
>>> @@ -4594,8 +4633,8 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super 
>>> *osb,
>>>  	BUG_ON(num_bits > clusters_to_add);
>>>   	/* reserve our write early -- insert_extent may update the inode */
>>> -	status = ocfs2_journal_access(handle, inode, et->et_root_bh,
>>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
>>> +	status = ocfs2_et_root_journal_access(handle, inode, et,
>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
>> This is really a good chance for us to modify the comments also. ;)
> 
> 	You mean something like 'may update the tree root'?
yeah.

Regards,
Tao
