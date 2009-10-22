From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 21 Oct 2009 18:05:07 -0700
Subject: [Ocfs2-devel] Extend FIEMAP to indicate shared extents
Message-ID: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

This adds a FIEMAP extent flag, FIEMAP_EXTENT_SHARED, to indicate
extents that are shared by multiple files. The second patch makes
use of the same in the OCFS2 file system to show such extents in
the reflinked files.

Thanks
Sunil
