From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 10 17:48:25 2008
Subject: [Ocfs2-devel] [PATCH 1/2] Add support for cross extent block
	merge.V1
In-Reply-To: <4781EB53.8040503@oracle.com>
References: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
	<20080104084538.GA1916@tma-pc1.cn.oracle.com>
	<20080107055116.GT23506@ca-server1.us.oracle.com>
	<4781EB53.8040503@oracle.com>
Message-ID: <20080111014719.GQ23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 07, 2008 at 05:05:23PM +0800, tao.ma wrote:
>> Hmm, I'm worried that we're exiting this function with a path whose upper
>> cpos values are inconsistent. An error before we get the chance to 
>> actually
>> do the rotate / removal could leave us with an inconsistent tree.
>>
>> I'm not sure that we can just slap some code to handle it here though - 
>> from
>> what I can tell, the callers are expecting that we'd leave an empty extent
>> for them to handle.
>>   
> Yes. So the situation here is really hard to handle and lead me to make the 
> decision that we should let ocfs2_roatate_tree_left go on the issue.
>> I see that ocfs2_rotate_tree_left _almost_ handles this situation
>> correctly, except the transaction extend could fail before we get to 
>> remove
>> the blocks. That might actually be a bug, though I have to think about it
>> some more. Generally if ocfs2_rotate_tree_left handled it 100% correctly, 
>> we
>> _could_ just comment the heck out of this function that callers *must* 
>> call
>> the rotate function later. Since calling ocfs2_rotate_tree_left() is
>> implicitely decided by the callers, I'd also want to audit the code to 
>> make
>> sure that it always gets called in the new merge situations we've
>> introduced.
>>   
> So any suggestion is welcomed. By now, I haven't found a good way to handle 
> it except my current ugly codes. ;)

Ok, I've had some time to think about this. We should just handle this
corner case in ocfs2_merge_rec_left(). ocfs2_rotate_tree_left() cleanly
exits if the empty extent has already been removed, so it's safe to
unconditionally call it as we do today.


>> So why don't we just always do the left merge 1st, instead of switching on
>> them like this?
>>   
> If split_index==0, then if we do merge_right first, it will not touch the 
> previous extent block(so no cross extent block merge is needed) and only 
> the extent block after the record will be affected. The second merge_left 
> will be cross extent block merge.
> If split_index==l_count-1, then if we do merge_left first, the first merge 
> will move the recs[0] of the next extent block into this block. So when 
> merge_right is called, no cross extent block merge is needed.
> So if you don't like this switch, I would prefer merge_right first and 
> merge_left second to the original merge_left first. ;)

Yeah, I think what I was looking for was whether you had a reason to not
just re-order the merging in all cases.

Do we ever get into the case that a leftright merge is at index == (l_count
- 1)? I think the search should prevent that (and instead give us index == 0
for the extent block to the right).

If so, I think that just always doing the left merge 1st makes sense. I
don't see any problem with that breaking the code to merge within a block
either.


> btw, I have patched your code of ocfs2_check_tree to my current git tree, 
> it works well under my test script. The test script should be ready for 
> review soon.

Great, post it ;) Have you looked at running the burn-in script?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
