From: Ashish Samant <ashish.samant@oracle.com>
Date: Tue, 10 Apr 2018 10:46:36 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Take inode cluster lock before
 moving reflinked inode from orphan dir
In-Reply-To: <40eba26d-15f2-1795-bbe4-1fd47f721a08@gmail.com>
References: <1522431737-4134-1-git-send-email-ashish.samant@oracle.com>
	<40eba26d-15f2-1795-bbe4-1fd47f721a08@gmail.com>
Message-ID: <5ACCF87C.7010608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 04/02/2018 02:17 AM, Joseph Qi wrote:
>
> On 18/3/31 01:42, Ashish Samant wrote:
>> While reflinking an inode, we create a new inode in orphan directory, then
>> take EX lock on it, reflink the original inode to orphan inode and release
>> EX lock. Once the lock is released another node might request it in PR mode
>> which causes downconvert of the lock to PR mode.
>>
>> Later we attempt to initialize security acl for the orphan inode and move
>> it to the reflink destination. However, while doing this we dont take EX
>> lock on the inode. So effectively, we are doing this and accessing the
>> journal for this inode while holding PR lock. While accessing the journal,
>> we make
>>
>> ci->ci_last_trans = journal->j_trans_id
>>
>> At this point, if there is another downconvert request on this inode from
>> another node (PR->NL), we will trip on the following condition in
>> ocfs2_ci_checkpointed()
>>
>> BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed);
>>
>> because we hold the lock in PR mode and journal->j_trans_id is not greater
>> than ci_last_trans for the inode.
>>
>> Fix this by taking orphan inode cluster lock in EX mode before
>> initializing security and moving orphan inode to reflink destination.
>> Use the __tracker variant while taking inode lock to avoid recursive
>> locking in the ocfs2_init_security_and_acl() call chain.
>>
>> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> Looks good.
> Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Hi Joseph,

Looks like mainline kernel has removed the inode lock call
in PR mode for orphan inode in ocfs2_recover_orphans()
and it directly takes the lock in EX mode. So, the patch commit log does 
not
reflect the exact problem for mainline kernel. However,
it is still possible that we might end up accessing the journal for the 
inode
while holding inode lock in NL mode (instead of PR). It might not cause
the same problem as described above, but it seems wrong to
modify inode metadata with NL lock held and could potentially cause similar
problems later. So, i'll submit v2 with modified commit message.

Thanks,
Ashish
