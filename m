From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 01 Jun 2011 00:44:45 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: free memory allocated by
	security_inode_init_security
In-Reply-To: <1306749283.3128.6.camel@localhost.localdomain>
References: <1306737569-3919-1-git-send-email-tiger.yang@oracle.com>
	<1306749283.3128.6.camel@localhost.localdomain>
Message-ID: <4DE51AFD.5030608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mimi Zohar wrote:
> Thanks for taking a look.  For the normal case, the memory is now freed,
> but not on failure.
>   
Hi, Mini,
Thanks point it out, I will resend the patch.

Regards,
Tiger
