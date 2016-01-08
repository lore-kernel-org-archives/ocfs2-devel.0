From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 07 Jan 2016 16:13:24 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <568EE89B.5070208@oracle.com>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>	<568C9B0F.7040500@oracle.com>	<568DD2BD.8010503@oracle.com>
	<568EE89B.5070208@oracle.com>
Message-ID: <568EFF24.2010200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 01/07/2016 02:37 PM, Tariq Saeed wrote:
> et another part.  ocfs2_reflink ->  ocfs2_init_security_and_acl ->
> ocfs2_iop_set_acl
On a closer look at the code, this is not a problem.
Thanks,
-Tariq
