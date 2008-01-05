From: marcin.slusarz at gmail.com <marcin.slusarz@gmail.com>
Date: Sat, 05 Jan 2008 15:34:54 -0000
Subject: [Ocfs2-devel] [PATCH 0/3] byteorder: introduce le32_add_cpu &
	friends to core
Message-ID: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, OCFS2-devel <ocfs2-devel@oss.oracle.com>, Christoph Hellwig <hch@infradead.org>, kernel-janitors <kernel-janitors@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, xfs-masters@oss.sgi.com, Marcin Slusarz <marcin.slusarz@gmail.com>

Hi

This patchset moves le*_add_cpu and be*_add_cpu functions from OCFS2 to core
header (1st), converts ext3 filesystem to this API (2nd) and replaces
XFS different named functions with new ones (3rd).

There are many places where these functions will be useful.
Just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/
Patch for ext3 is an example how conversions will probably look like.

ps: this patchset depends on http://lkml.org/lkml/2007/12/25/35 (which is
    in ocfs2 git tree, branches: trivial, ALL)

Marcin Slusarz
