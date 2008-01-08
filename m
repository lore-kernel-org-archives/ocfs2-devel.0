From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:15:47 2008
Subject: [Ocfs2-devel] [PATCH 26/30] ocfs2: Handle missing const struct
	inode_operations in struct inode
In-Reply-To: <1199388006-32658-25-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-25-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109001359.GX23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:20:02AM -0800, Sunil Mushran wrote:
> Commit c5ef1c42c51b1b5b4a401a6517bdda30933ddbaf in mainline marks struct
> inode_operations in struct inode as a const. This patch allows one to build
> ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
