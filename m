From: Christoph Hellwig <hch@lst.de>
Date: Mon Aug 30 08:50:25 2004
Subject: [Ocfs2-devel] 2.6 I/O path totally messed up
Message-ID: <20040830135022.GA17620@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The second argumentto generic_file_write_nolock is an iovec, not an
actual userbuffer.  The current code doesn't even have the slightest
chance to work.  Maybe it's time to decouple the 2.6 read/write code
from the 2.4 code and implement proper vectored operations everywhere?

(and kill tge O_DIRECT vs O_APPEN hack, and the broken fallback code,
 and..)
