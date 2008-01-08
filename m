From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:20:02 2008
Subject: [Ocfs2-devel] [PATCH 29/30] ocfs2: Handle older prototype of
	bi_end_io_t
In-Reply-To: <1199388006-32658-28-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-28-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109001837.GA23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:20:05AM -0800, Sunil Mushran wrote:
> Commit 6712ecf8f648118c3363c142196418f89a510b90 in mainline
> dropped 'size' argument from bi_end_io(). This patch allows
> one to build ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
