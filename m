From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:03:30 2008
Subject: [Ocfs2-devel] [PATCH 22/30] ocfs2: Handle missing macro
	MNT_RELATIME
In-Reply-To: <1199388006-32658-21-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-21-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109000232.GU23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:58AM -0800, Sunil Mushran wrote:
> Commit 47ae32d6a54955a041cdc30b06d0bb16e75f68d5 in mainline introduced
> macro MNT_RELATIME to limit atime updates to frequency specified in the
> mount option. This patch allows one to build ocfs2 with kernels having/not
> having this change.
> 
> It should be noted that the functionality will not be available on kernels
> not having the macro as the vfs support will be missing.

I bet we can conditionally define our own relatime option in here though -
Ocfs2 doesn't really make use of most of the vfs support, so it's not
necessary.

By the way, relatime is the default on the latest fedora releases, so people
_do_ want this feature.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
