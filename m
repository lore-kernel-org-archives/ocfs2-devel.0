From: tristan <tristan.ye@oracle.com>
Date: Sat, 20 Mar 2010 10:03:20 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle deletion of reflinked
 oprhan inodes correctly.
In-Reply-To: <20100319235047.GJ11402@wotan.suse.de>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
	<1268961670-4712-2-git-send-email-tristan.ye@oracle.com>
	<20100319235047.GJ11402@wotan.suse.de>
Message-ID: <4BA42CE8.7000009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Fri, Mar 19, 2010 at 09:21:10AM +0800, Tristan Ye wrote:
>   
>> Current rule of orphan dir is that all inodes in the orphan dir
>> have ORPHANED_FL, otherwise we treated it as an ERROR. this rule
>> works well except for some rare cases of reflink operation:
>>
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1215
>>
>> The problem is introduced by the essense of how reflink and our
>> orphan_scan thread were working:
>>
>>  * Orphan_scan scan the orphan dir into a queue first, and run
>>    queue in a later time, we only hold the orphan_dir's lock
>>    during scanning.
>>
>>  * Reflink create a oprhaned target in orphan_dir at the first
>>    step, and remove the targets and unset the flag at the third
>>    step, these two steps respectively hold the orphan_dir's lock
>>    themselves.
>>
>> Based on above semantics, there is a possibility that a reflink
>> inode can be moved out of the orphan dir and have its ORPHANED_FL
>> cleared before the queue is run, which leads to a ERROR in
>> ocfs2_query_wipde_inode().
>>
>> This patch helps to judge if a orphan inode to be wiped off, which
>> has NO ORPHANED_FL, is a legal alive reflinked target or not.
>>
>> The patch also works for failed reflinked targets from a crash or
>> other failures during the reflink operation, they can be wiped off
>> as desired since these failed reflinked inodes always has ORPHANED_FL
>> set ondisk.
>>     
>
> How is this? Wouldn't the failed reflink still have OCFS2_HAS_REFCOUNT_FL
> set as well as OCFS2_ORPHANED_FL? In the code below, we (correctly) skip
> those for delete.
>   

Mark,

We firstly check the flag ORPHANED_FL, if ORPHANED_FL were already 
there, no need to check REFCOUNT_FL, it will be definitely wiped off 
since we know for sure it's a deleted inode or a failed reflink inode. 
if ORPHANED_FL were not set. there may be 2 cases, one is a unknown 
error somehow which caused a deleted inode in orphan_dir having its 
ORPHAN_FL unset(that way, we need to bailout with a error). and the 
other case is all what our patch described: it's a legal reflink 
inode(in a incomplete state),which should not be treated as an error,and 
also can not be wiped off as well.

Then you may ask, how about the case when the reflink inode has 
ORPHANED_FL, but without REFCOUNT_FT been set yet. will our 
ocfs2_delete() codes incorrectly delete them? the answer is definitely 
no, since reflink operation hold the inode lock all its operating time 
except a failure.


Regards,
Tristan.
>
> Btw, other than my question above, the patch looks correct for the case of
> not wiping a reflinked inode.
> 	--Mark
>
> --
> Mark Fasheh
>   
