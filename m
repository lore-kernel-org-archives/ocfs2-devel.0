From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 13:22:47 2008
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2_net: Debug interface added to
	o2net
In-Reply-To: <1204081700-29323-2-git-send-email-sunil.mushran@oracle.com>
References: <1204081700-29323-1-git-send-email-sunil.mushran@oracle.com>
	<1204081700-29323-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080228212052.GC23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 26, 2008 at 07:08:20PM -0800, Sunil Mushran wrote:
> This patch is a forward port of net_proc.c in OCFS2 1.2. The difference
> here is that the debugging funtionality is exposed via debugfs.

	The code looks good and sign-offable, but you need to either
wrap it in CONFIG_DEBUG_FS or make CONFIG_OCFS2 depend on
CONFIG_DEBUG_FS.  In fact, I think we have the problem already with
ocfs2_dlm_init_debug().

Joel


-- 

"When I am working on a problem I never think about beauty. I
 only think about how to solve the problem. But when I have finished, if
 the solution is not beautiful, I know it is wrong."
         - Buckminster Fuller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
