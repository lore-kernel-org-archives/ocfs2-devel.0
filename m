From: Ashish Samant <ashish.samant@oracle.com>
Date: Tue, 1 May 2018 17:20:09 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Take inode cluster lock before
 moving reflinked inode from orphan dir
In-Reply-To: <20180501170857.0cc4e94f7de64640b7deaeff@linux-foundation.org>
References: <1523475107-7639-1-git-send-email-ashish.samant@oracle.com>
	<20180501170857.0cc4e94f7de64640b7deaeff@linux-foundation.org>
Message-ID: <5AE90439.3070104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 05/01/2018 05:08 PM, Andrew Morton wrote:
> On Wed, 11 Apr 2018 12:31:47 -0700 Ashish Samant <ashish.samant@oracle.com> wrote:
>
>> While reflinking an inode, we create a new inode in orphan directory, then
>> take EX lock on it, reflink the original inode to orphan inode and release
>> EX lock. Once the lock is released another node could request it in EX mode
>> from ocfs2_recover_orphans() which causes downconvert of the lock, on this
>> node, to NL mode.
>>
>> Later we attempt to initialize security acl for the orphan inode and move
>> it to the reflink destination. However, while doing this we dont take EX
>> lock on the inode. This could potentially cause problems because we could
>> be starting transaction, accessing journal and modifying metadata of the
>> inode while holding NL lock and with another node holding EX lock on the
>> inode.
> Someone (eg, me) needs to decide which kernel version(s) need the
> patch.  And all I have is "this could potentially cause problems".
>
> Can you please be more specific about the end-user impact?  *Does* it
> cause problems?  Is the problem sufficiently urgent to warrant a merge
> into 4.17?  Into -stable kernels?

Hi Andrew,


What the code is doing currently is definitely wrong and should be fixed.
This could theoretically cause a dlm race, leaading to kernel panic, 
although the possibility of that
happening in the real world is very less. Hence the "potentially" in the 
commit message.
So, I'd say it should go into 4.17 but backporting to stable is probably 
not required.

Thanks,
Ashish
>
> Please always include all the end-user-impact info when fixing bugs.
>
> Thanks.
>
>> Fix this by taking orphan inode cluster lock in EX mode before
>> initializing security and moving orphan inode to reflink destination.
>> Use the __tracker variant while taking inode lock to avoid recursive
>> locking in the ocfs2_init_security_and_acl() call chain.
