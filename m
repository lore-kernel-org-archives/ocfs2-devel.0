From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Aug  3 13:57:09 2004
Subject: [Ocfs2-devel] [Patch] use asynchronous journal commit in
	ocfs_rename
In-Reply-To: <3ACA40606221794F80A5670F0AF15F840509060C@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F840509060C@pdsmsx403>
Message-ID: <20040803185703.GM8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 03, 2004 at 03:49:57AM +0800, Ling, Xiaofeng wrote:
> ok. I've made the patch. see attach. 
Coolness, next time could you include it inline in the mail?  :)

In ocfs_link, you did:
ocfs_handle_add_lock(handle, OCFS_LKM_EXMODE, FLAG_FILE_CREATE, inode);

You left out the FLAG_FILE_UPDATE_OIN which is somewhat critical as it is
what the other node keys on to know that it needs to update the inode
information (otherwise i_nlink might've gotten out of sync).

Also, tmpstat is no longer used in ocfs_link so I removed it.

I came across an unexpected bug in the way we handle symlinks, but the fix
(which is unfortunately, something of a hack) was fairly simple.

I'm looking forward to just removing the checkpointing code altogether now
:)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
