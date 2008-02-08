From: Christoph Hellwig <hch@lst.de>
Date: Fri Feb  8 23:17:41 2008
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add CDSL
In-Reply-To: <1202496577-21982-4-git-send-email-sunil.mushran@oracle.com>
References: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
	<1202496577-21982-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080209071720.GA30875@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 08, 2008 at 10:49:36AM -0800, Sunil Mushran wrote:
> This is a forward port of the CDSL implementation in OCFS2 1.2.

This was NACKEd before, please don't add it.  User proper bind-mounts
instead.
