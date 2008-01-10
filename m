From: tao.ma <tao.ma@oracle.com>
Date: Thu Jan 10 18:21:14 2008
Subject: [Ocfs2-devel] [PATCH 1/2] Add support for cross extent block
	merge.V1
In-Reply-To: <20080111014719.GQ23506@ca-server1.us.oracle.com>
References: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
	<20080104084538.GA1916@tma-pc1.cn.oracle.com>
	<20080107055116.GT23506@ca-server1.us.oracle.com>
	<4781EB53.8040503@oracle.com>
	<20080111014719.GQ23506@ca-server1.us.oracle.com>
Message-ID: <4786D26F.2030909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Mon, Jan 07, 2008 at 05:05:23PM +0800, tao.ma wrote:
>   
>>> Hmm, I'm worried that we're exiting this function with a path whose upper
>>> cpos values are inconsistent. An error before we get the chance to 
>>> actually
>>> do the rotate / removal could leave us with an inconsistent tree.
>>>
>>> I'm not sure that we can just slap some code to handle it here though - 
>>> from
>>> what I can tell, the callers are expecting that we'd leave an empty extent
>>> for them to handle.
>>>   
>>>       
>> Yes. So the situation here is really hard to handle and lead me to make the 
>> decision that we should let ocfs2_roatate_tree_left go on the issue.
>>     
>>> I see that ocfs2_rotate_tree_left _almost_ handles this situation
>>> correctly, except the transaction extend could fail before we get to 
>>> remove
>>> the blocks. That might actually be a bug, though I have to think about it
>>> some more. Generally if ocfs2_rotate_tree_left handled it 100% correctly, 
>>> we
>>> _could_ just comment the heck out of this function that callers *must* 
>>> call
>>> the rotate function later. Since calling ocfs2_rotate_tree_left() is
>>> implicitely decided by the callers, I'd also want to audit the code to 
>>> make
>>> sure that it always gets called in the new merge situations we've
>>> introduced.
>>>   
>>>       
>> So any suggestion is welcomed. By now, I haven't found a good way to handle 
>> it except my current ugly codes. ;)
>>     
>
> Ok, I've had some time to think about this. We should just handle this
> corner case in ocfs2_merge_rec_left(). ocfs2_rotate_tree_left() cleanly
> exits if the empty extent has already been removed, so it's safe to
> unconditionally call it as we do today.
>   
hmm, ok. Maybe a helper function is needed since now 
ocfs2_merge_rec_left have to handle so much issue.
>
>   
>>> So why don't we just always do the left merge 1st, instead of switching on
>>> them like this?
>>>   
>>>       
>> If split_index==0, then if we do merge_right first, it will not touch the 
>> previous extent block(so no cross extent block merge is needed) and only 
>> the extent block after the record will be affected. The second merge_left 
>> will be cross extent block merge.
>> If split_index==l_count-1, then if we do merge_left first, the first merge 
>> will move the recs[0] of the next extent block into this block. So when 
>> merge_right is called, no cross extent block merge is needed.
>> So if you don't like this switch, I would prefer merge_right first and 
>> merge_left second to the original merge_left first. ;)
>>     
>
> Yeah, I think what I was looking for was whether you had a reason to not
> just re-order the merging in all cases.
>
> Do we ever get into the case that a leftright merge is at index == (l_count
> - 1)? I think the search should prevent that (and instead give us index == 0
> for the extent block to the right).
>   
Yes, I think we can get into this issue when the unwritten extent exists 
in l_count-1.
> If so, I think that just always doing the left merge 1st makes sense. I
> don't see any problem with that breaking the code to merge within a block
> either.
>   
Do you mean right merge first? As I have mentioned above, if index==0, 
the first right merge first will not touch cross extent block. Only the 
second one has to.
And now I think some of my previous comment is wrong. ;)
Even if index == l_count-1, it is ok for right merge first. Since the 
first right merge is a cross extent block merge, but the second left 
merge don't touch cross extent block. So there is totally one cross 
extent block merge.
>
>   
>> btw, I have patched your code of ocfs2_check_tree to my current git tree, 
>> it works well under my test script. The test script should be ready for 
>> review soon.
>>     
>
> Great, post it ;) Have you looked at running the burn-in script
OK, I will post it soon. Actually it is generated when I create sparse 
file support in ocfs2-tools. I always want to modify it to be a test 
script for both kernel and the tools. Now it really goes. ;)
Actually I make the ocfs2 file system read-only one time when I run one 
random_rw_test in it. :)
But I have to sparse some time to investigate the real reason. So please 
wait. ;)
