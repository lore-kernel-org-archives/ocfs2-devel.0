From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 13:16:38 2008
Subject: [Ocfs2-devel] [PATCH 03/30] ocfs2: Handle workqueue changes
In-Reply-To: <1199388006-32658-2-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108211540.GC23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:39AM -0800, Sunil Mushran wrote:
> Commit 52bad64d95bd89e08c49ec5a071fa6dcbe5a1a9c in mainline makes
> changes to workqueue.h. This patch allows one to build ocfs2 with
> kernels having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Though I'd have preferred a more descriptive name than "NO_DELAYED_WORK",
which makes me think that we got rid of the entire delayed work mechanism.
Maybe "NO_DELAYED_WORK_STRUCT"
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
