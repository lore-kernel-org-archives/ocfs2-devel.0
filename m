From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun Jan  6 21:52:25 2008
Subject: [Ocfs2-devel] [PATCH 1/2] Add support for cross extent block
	merge.V1
In-Reply-To: <20080104084538.GA1916@tma-pc1.cn.oracle.com>
References: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
	<20080104084538.GA1916@tma-pc1.cn.oracle.com>
Message-ID: <20080107055116.GT23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 04, 2008 at 04:45:38PM +0800, tao.ma wrote:
> In ocfs2_merge_rec_left, when we find the merge extent is "CONTIG_RIGHT"
> with the first extent record of the next extent block, we will merge it to
> the next extent block and change all the related extent blocks accordingly.
> 
> In ocfs2_merge_rec_right, when we find the merge extent is "CONTIG_LEFT"
> with the last extent record of the previous extent block, we will merge
> it to the prevoius extent block and change all the related extent blocks
> accordingly.
> 
> As for CONTIG_LEFTRIGHT, we will handle CONTIG_RIGHT first when the split_index
> is zero since it is more efficient and easier.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/alloc.c |  367 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 332 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 23c8cda..c256750 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1450,6 +1450,8 @@ static void ocfs2_adjust_root_records(struct ocfs2_extent_list *root_el,
>   *   - When our insert into the right path leaf is at the leftmost edge
>   *     and requires an update of the path immediately to it's left. This
>   *     can occur at the end of some types of rotation and appending inserts.
> + *   - When we've adjusted the last extent record in the left path leaf and the
> + *     1st extent record in the right path leaf during cross extent block merge.
>   */
>  static void ocfs2_complete_edge_insert(struct inode *inode, handle_t *handle,
>  				       struct ocfs2_path *left_path,

Ok, great. I like that we're keeping these functions documented... It's hard
enough to follow as-is!



>  /*
>   * Remove split_rec clusters from the record at index and merge them
>   * onto the beginning of the record at index + 1.
>   */

Should update this comment though...

> -static int ocfs2_merge_rec_right(struct inode *inode, struct buffer_head *bh,
> -				handle_t *handle,
> -				struct ocfs2_extent_rec *split_rec,
> -				struct ocfs2_extent_list *el, int index)
> +static int ocfs2_merge_rec_right(struct inode *inode,
> +				 struct ocfs2_path *left_path,
> +				 handle_t *handle,
> +				 struct ocfs2_extent_rec *split_rec,
> +				 struct ocfs2_extent_list *el, int index)
>  {


> @@ -2751,7 +2848,90 @@ static int ocfs2_merge_rec_right(struct inode *inode, struct buffer_head *bh,
>  	if (ret)
>  		mlog_errno(ret);
>  
> +	if (right_path) {
> +		ret = ocfs2_journal_dirty(handle, path_leaf_bh(right_path));
> +		if (ret)
> +			mlog_errno(ret);
> +
> +		root_bh = left_path->p_node[subtree_index].bh;
> +		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
> +
> +		ret = ocfs2_journal_access(handle, inode, root_bh,
> +					   OCFS2_JOURNAL_ACCESS_WRITE);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		for (i = subtree_index + 1;
> +		     i < path_num_items(right_path); i++) {
> +			ret = ocfs2_journal_access(handle, inode,
> +						   right_path->p_node[i].bh,
> +						   OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
> +
> +			ret = ocfs2_journal_access(handle, inode,
> +						   left_path->p_node[i].bh,
> +						   OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
> +		}

I'd move the journal_access() calls here up before we actually change the
records. That way we can catch journal errors before the tree gets into an
transient state.


> @@ -2759,22 +2939,64 @@ out:
>   * Remove split_rec clusters from the record at index and merge them
>   * onto the tail of the record at index - 1.
>   */

Should update this comment.


> -static int ocfs2_merge_rec_left(struct inode *inode, struct buffer_head *bh,
> +static int ocfs2_merge_rec_left(struct inode *inode,
> +				struct ocfs2_path *right_path,
>  				handle_t *handle,
>  				struct ocfs2_extent_rec *split_rec,
>  				struct ocfs2_extent_list *el, int index)
>  {
> -	int ret, has_empty_extent = 0;
> +	int ret, i, subtree_index = 0, has_empty_extent = 0;
>  	unsigned int split_clusters = le16_to_cpu(split_rec->e_leaf_clusters);
>  	struct ocfs2_extent_rec *left_rec;
>  	struct ocfs2_extent_rec *right_rec;
> +	struct buffer_head *bh = path_leaf_bh(right_path);
> +	struct buffer_head *root_bh = NULL;
> +	struct ocfs2_path *left_path = NULL;
> +	struct ocfs2_extent_list *left_el;
>  
> -	BUG_ON(index <= 0);
> +	BUG_ON(index < 0);
>  
> -	left_rec = &el->l_recs[index - 1];
>  	right_rec = &el->l_recs[index];
> -	if (ocfs2_is_empty_extent(&el->l_recs[0]))
> -		has_empty_extent = 1;
> +	if (index == 0) {
> +		/* we meet with a cross extent block merge. */
> +		ret = ocfs2_get_left_path(inode, right_path, &left_path);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		left_el = path_leaf_el(left_path);
> +		BUG_ON(le16_to_cpu(left_el->l_next_free_rec) !=
> +		       le16_to_cpu(left_el->l_count));
> +
> +		left_rec = &left_el->l_recs[le16_to_cpu(left_el->l_count) - 1];

Using left_el->l_count to index the array is correct here, but would you
mind changing this to use l_next_free_rec so it's more consistent with what
we usually do? It actually reads a bit weird to my eyes because I'm used to
seeing l_next_free_rec inside of array derefs!


> @@ -2802,24 +3024,77 @@ static int ocfs2_merge_rec_left(struct inode *inode, struct buffer_head *bh,
>  	ocfs2_cleanup_merge(el, index);
>  
>  	ret = ocfs2_journal_dirty(handle, bh);
> -	if (ret)
> +	if (ret) {
>  		mlog_errno(ret);
> +		goto out;
> +	}
>  
> +	if (left_path) {
> +		ret = ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		/*
> +		 * In the situation that the right_rec is empty and the extent
> +		 * block is empty also, ocfs2_complete_edge_insert can't handle
> +		 * it, while ocfs2_rotate_tree_left can be called and the extent
> +		 * block will be deleted since c_split_covers_rec is set.
> +		 */
> +		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
> +		    le16_to_cpu(el->l_next_free_rec) == 1)
> +			goto out;
>

Hmm, I'm worried that we're exiting this function with a path whose upper
cpos values are inconsistent. An error before we get the chance to actually
do the rotate / removal could leave us with an inconsistent tree.

I'm not sure that we can just slap some code to handle it here though - from
what I can tell, the callers are expecting that we'd leave an empty extent
for them to handle.

I see that ocfs2_rotate_tree_left _almost_ handles this situation
correctly, except the transaction extend could fail before we get to remove
the blocks. That might actually be a bug, though I have to think about it
some more. Generally if ocfs2_rotate_tree_left handled it 100% correctly, we
_could_ just comment the heck out of this function that callers *must* call
the rotate function later. Since calling ocfs2_rotate_tree_left() is
implicitely decided by the callers, I'd also want to audit the code to make
sure that it always gets called in the new merge situations we've
introduced.


> +		root_bh = left_path->p_node[subtree_index].bh;
> +		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
> +
> +		ret = ocfs2_journal_access(handle, inode, root_bh,
> +					   OCFS2_JOURNAL_ACCESS_WRITE);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		for (i = subtree_index + 1;
> +		     i < path_num_items(right_path); i++) {
> +			ret = ocfs2_journal_access(handle, inode,
> +						   right_path->p_node[i].bh,
> +						   OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
> +
> +			ret = ocfs2_journal_access(handle, inode,
> +						   left_path->p_node[i].bh,
> +						   OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
> +		}

Same comment as before regarding the journal_access calls.


> @@ -2858,9 +3132,21 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
>  		 * Since the adding of an empty extent shifts
>  		 * everything back to the right, there's no need to
>  		 * update split_index here.
> -		 */
> -		ret = ocfs2_merge_rec_left(inode, path_leaf_bh(left_path),
> -					   handle, split_rec, el, split_index);
> +		 *
> + 		 * When the split_index is zero, we need to merge it to the
> + 		 * prevoius extent block. It is more efficient and easier
> + 		 * if we do merge_right first and merge_left later.
> + 		 */

So why don't we just always do the left merge 1st, instead of switching on
them like this?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
