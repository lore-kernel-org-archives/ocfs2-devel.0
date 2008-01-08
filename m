From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:45:01 2008
Subject: [Ocfs2-devel] [PATCH 16/30] ocfs2: Handle different prototypes
	of register_sysctl_table()
In-Reply-To: <1199388006-32658-15-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-15-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108234321.GP23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:52AM -0800, Sunil Mushran wrote:
> Commit 0b4d414714f0d2f922d39424b0c5c82ad900a381 in mainline removes the
> insert_at_head argument from register_sysctl_table(). This patch allows
> building ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
