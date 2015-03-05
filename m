From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 05 Mar 2015 11:33:55 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] BUG_ON(lockres->l_level !=
 DLM_LOCK_EX && !checkpointed) tripped in ocfs2_ci_checkpointed
In-Reply-To: <20150304235719.GW21790@wotan.suse.de>
References: <1425333797-26082-1-git-send-email-tariq.x.saeed@oracle.com>
	<20150304235719.GW21790@wotan.suse.de>
Message-ID: <54F8AFA3.6010305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 03/04/2015 03:57 PM, Mark Fasheh wrote:
> Ok, so the problem is that we're not holding a cluster lock across acl
Yes, but in addition to that,  the inode lock in ocfs2_setattr MUST not 
be dropped till
the exit since all operations,mode change, size change etc,
in that function plus any changes to acls are atomic from user's point 
of view.
Thanks,
-Tariq Saeed
