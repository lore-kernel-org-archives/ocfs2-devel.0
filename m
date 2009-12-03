From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  3 Dec 2009 12:46:50 -0800
Subject: [Ocfs2-devel] Add FIEMAP_EXTENT_SHARED flag
Message-ID: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Andrew,

Please could you Ack this patch. This adds a new FIEMAP flag to denote
shared extents which we are using to identify such exents in reflinked
files.

Thanks
Sunil
