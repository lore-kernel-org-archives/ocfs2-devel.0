From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:41:01 2008
Subject: [Ocfs2-devel] [PATCH 12/30] ocfs2: Handle missing dtors in
	kmem_cache_create()
In-Reply-To: <1199388006-32658-11-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-11-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108234036.GM23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:48AM -0800, Sunil Mushran wrote:
> Commit 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac removed the dtor arg
> from kmem_cache_create(). This patch allows one to build ocfs2 with
> kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
