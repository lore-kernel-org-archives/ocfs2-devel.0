From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 19 Apr 2011 17:20:10 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] ocfs or configfs bug ?
In-Reply-To: <20110419194840.GA27826@noexit>
References: <4DADA228.5050209@bull.net> <20110419194840.GA27826@noexit>
Message-ID: <4DAE26BA.3010203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/19/2011 12:48 PM, Joel Becker wrote:
> 	You're too late here.  This is in the echo process (bash,
> really).  getdents() isn't happening.
> 	The problem is almost certainly in configfs.  It's a race
> between setup and teardown of the virtual attribute files.  If anyone
> else has a cycle to look at it, great, otherwise I'll try to get to it
> later this week.

So we ran into it internally. This is what I wrote in the bug.

/@ The matching code in configfs_readir() is:/
/@     name = configfs_get_name(next);/
/@     len = strlen(name);/
/@     if (next->s_dentry)/
/@            ino = next->s_dentry->d_inode->i_ino; <===/
/@     else/
/@            ino = iunique(configfs_sb, 2);/
/@ ./
/@     if (filldir(dirent, name, len, filp->f_pos, ino,/
/@                 dt_type(next)) < 0)/
/@            return 0;/
/@ ./
/@ The oops indicates that next->s_dentry->d_inode is NULL./

Joel, does this give you any clues?

BTW, thanks for the testcase. And yes, I can reproduce it easily.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20110419/6b6d3b34/attachment.html 
