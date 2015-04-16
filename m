From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 16 Apr 2015 11:51:41 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2_iop_set/get_acl() are also
 called from the VFS so we must take inode lock
In-Reply-To: <552F775B.6040203@oracle.com>
References: <1428097580-25352-1-git-send-email-tariq.x.saeed@oracle.com>
	<1428097580-25352-2-git-send-email-tariq.x.saeed@oracle.com>
	<552F775B.6040203@oracle.com>
Message-ID: <553004BD.9020601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 04/16/2015 01:48 AM, Junxiao Bi wrote:
> I think "return ERR_PTR(ret);" is more simple here.
True. I am guilty of just copy-paste from an older kernel.
> Also why you check "status != -ENOENT" in ocfs2_iop_set_acl() but not here
Same reason -- copy-and-paste from an older kernel. Having said that,
I don't think it matters one way or the other. Does it?

I have no objection to applying your suggestions and re-submitting the
patch. Mark, what is the protocol for that. Do I need to mention that 
this is a re-sumit?
Thanks,
-Tariq Saeed
