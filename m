From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:45:02 2008
Subject: [Ocfs2-devel] [PATCH 17/30] ocfs2: Handle su_mutex in struct
	configfs_subsystem
In-Reply-To: <1199388006-32658-16-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-16-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108234422.GQ23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:53AM -0800, Sunil Mushran wrote:
> Commit e6bd07aee739566803425acdbf5cdb29919164e1 in mainline changed a
> semaphore into a mutex in struct configfs_subsystem. This patch allows
> building ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
