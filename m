From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 15:14:38 2007
Subject: [Ocfs2-devel] [PATCH 21/30] ocfs2: Handle missing macro
	MNT_RELATIME
In-Reply-To: <1198193387-16606-20-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-20-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221231242.GE15533@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:38PM -0800, Sunil Mushran wrote:
> Commit 47ae32d6a54955a041cdc30b06d0bb16e75f68d5 in mainline introduced
> macro MNT_RELATIME to limit atime updates to frequency specified in the
> mount option. This patch allows one to build ocfs2 with kernels having/not
> having this change.
> 
> It should be noted that the functionality will not be available on kernels
> not having the macro as the vfs support will be missing.

> ---
>  Makefile                    |    3 ++-
>  configure.in                |    5 +++++
>  kapi-compat/include/mount.h |    6 ++++++

	Why not relatime.h?

Joel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
