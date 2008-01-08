From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:45:06 2008
Subject: [Ocfs2-devel] [PATCH 15/30] ocfs2: Handles
	configfs_depend_item() and configfs_undepend_item()
In-Reply-To: <1199388006-32658-14-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-14-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108234302.GO23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:51AM -0800, Sunil Mushran wrote:
> Commit 631d1febab8e546e3bb800bdfe2c212b8adf87de in mainline introduces
> two new calls in configfs, configfs_depend_item() and configfs_undepend_item().
> This patch allows one to build ocfs2 with kernels having/not having
> this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
