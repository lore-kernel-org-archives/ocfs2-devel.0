From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Wed, 06 Jan 2016 18:51:41 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <568C9B0F.7040500@oracle.com>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
	<568C9B0F.7040500@oracle.com>
Message-ID: <568DD2BD.8010503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 01/05/2016 08:41 PM, Junxiao Bi wrote:
> This fixed part of the deadlock. There is another part.
> ocfs2_mknod()->posix_acl_create()->ocfs2_iop_get_acl()
Right. It used to be:  ocfs2_mknod -> ocfs2_init_acl -> 
ocfs2_get_acl_nolock.

Thanks
-Tariq
