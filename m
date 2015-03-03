From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Mon, 02 Mar 2015 17:30:51 -0800
Subject: [Ocfs2-devel] question related to [PATCH 1/1]
 BUG_ON(lockres->l_level != DLM_LOCK_EX ...
In-Reply-To: <1425333797-26082-1-git-send-email-tariq.x.saeed@oracle.com>
References: <1425333797-26082-1-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <54F50ECB.20800@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> Ocfs2-devel] [PATCH 1/1] BUG_ON(lockres->l_level != DLM_LOCK_EX && 
> !checkpointed) tripped in ocfs2_ci_checkpointed
As I was working on this patch, I noticed that the changes  in 
ocfs2_setattr are done in more than
one transaction --> in case of crash somewhere in this func, say after 
doing the first trans,
the inode could be in a state where only some of the changes have
been applied (after log replay).

Checking ext3_ocfs2, from where this code was ported, I found the same 
issue there as well.
Do you have any comments?
Thanks
-Tariq Saeed
PS I realize that doing everything in ocfs2_setattr in a single 
transaction is a major surgery as
the functions called down the path for xattr start their own 
transactions with different credits.
