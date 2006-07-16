From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun, 16 Jul 2006 00:31:41 -0700
Subject: [Ocfs2-devel] [RFC: 2.6 patch] fs/ocfs2/dlm/dlmmaster.c:
	unexport dlm_migrate_lockres
In-Reply-To: <20060715003600.GK3633@stusta.de>
References: <20060715003600.GK3633@stusta.de>
Message-ID: <20060716073141.GK29686@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jul 15, 2006 at 02:36:01AM +0200, Adrian Bunk wrote:
> This patch removes the unused EXPORT_SYMBOL_GPL(dlm_migrate_lockres).
Eh, that's fine I guess - we haven't used it yet and afair it was just
exported for debugging purposes anyway.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
