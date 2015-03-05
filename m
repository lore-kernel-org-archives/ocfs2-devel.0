From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 4 Mar 2015 16:13:22 -0800
Subject: [Ocfs2-devel] question related to [PATCH
	1/1]	BUG_ON(lockres->l_level != DLM_LOCK_EX ...
In-Reply-To: <54F50ECB.20800@oracle.com>
References: <1425333797-26082-1-git-send-email-tariq.x.saeed@oracle.com>
	<54F50ECB.20800@oracle.com>
Message-ID: <20150305001322.GX21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 02, 2015 at 05:30:51PM -0800, Tariq Saeed wrote:
>> Ocfs2-devel] [PATCH 1/1] BUG_ON(lockres->l_level != DLM_LOCK_EX && 
>> !checkpointed) tripped in ocfs2_ci_checkpointed
> As I was working on this patch, I noticed that the changes  in 
> ocfs2_setattr are done in more than
> one transaction --> in case of crash somewhere in this func, say after 
> doing the first trans,
> the inode could be in a state where only some of the changes have
> been applied (after log replay).
>
> Checking ext3_ocfs2, from where this code was ported, I found the same 
> issue there as well.

Can you give a specific example where this would cause a problem for the
user?


> Do you have any comments?

Well other than my question above, some things are impossible to always fit
in one transaction. Extends and truncates are a good example of this. Ext4
does orphan inodes during truncate so it can complete them on remount in
case of crash. Ocfs2 doesn't do this though it could be done pretty easily
so if you're interested, that'd be a nice feature for us to finally cross
off the list :)
	--Mark

--
Mark Fasheh
