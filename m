From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  6 Nov 2009 15:24:22 -0800
Subject: [Ocfs2-devel] Extend FIEMAP to indicate shared extents
Message-ID: <1257549864-18901-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Please could I get your ACK for these patches.

This adds a FIEMAP extent flag, FIEMAP_EXTENT_SHARED, to indicate
extents that are shared by multiple files. The second patch makes
use of the same in the OCFS2 file system to show such extents in
the reflinked files.

Thanks
Sunil
