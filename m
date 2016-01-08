From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Fri, 08 Jan 2016 14:44:29 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <20160108014556.GD819@wotan.suse.de>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
	<20160107225507.GB819@wotan.suse.de> <568EF987.9080904@oracle.com>
	<20160108014556.GD819@wotan.suse.de>
Message-ID: <56903BCD.6050806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 01/07/2016 05:45 PM, Mark Fasheh wrote:
>> 2. ocfs2_reflink ->  ocfs2_init_security_and_acl -> ocfs2_iop_set_acl
> Could you elaborate for me on the problem you found there?
The problem here is dropping dir lock in posix_acl_create after getting
default_acl and acl. These two can be changed by another node by
the time we get around to using  them in ocfs2_init_security_and_acl.

The old code in uek3 is mindful of this. In that code, 
ocfs2_init_security_and_acl
gets the dir lock and keeps it until the acls of new node are set.
Thanks
-Tariq
