From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 11 Jun 2008 11:49:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Handle error during journal
	load
In-Reply-To: <1213079088-9921-1-git-send-email-wen.gang.wang@oracle.com>
References: <1213079088-9921-1-git-send-email-wen.gang.wang@oracle.com>
Message-ID: <20080611184935.GK28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 10, 2008 at 02:24:48PM +0800, wen.gang.wang at oracle.com wrote:
> From: Wengang Wang <wen.gang.wang@oracle.com>
> 
> This patch ensures the mount fails if the fs is unable to load the journal.

Ok, thanks for this.
	--Mark

--
Mark Fasheh
