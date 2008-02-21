From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb 21 09:49:38 2008
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add fops->sendfile()
In-Reply-To: <1202755969-7115-4-git-send-email-sunil.mushran@oracle.com>
References: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
	<1202755969-7115-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080221174933.GB27865@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 11, 2008 at 10:52:49AM -0800, Sunil Mushran wrote:
> fops->sendfile() was removed in 2.6.23. Re-adding as this version
> of the fs is meant to also work with older kernels.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
