From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 31 Dec 2007 09:17:47 -0000
Subject: [Ocfs2-devel] [RFC][PATCH] byteorder: introduce le32_add_cpu &
	friends to	core
In-Reply-To: <20071230214857.GA14177@joi>
References: <20071230190619.GA13757@joi> <20071230191825.GA6447@infradead.org>
	<20071230214857.GA14177@joi>
Message-ID: <20071231091732.GA29043@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>, kernel-janitors <kernel-janitors@vger.kernel.org>

On Sun, Dec 30, 2007 at 10:49:34PM +0100, Marcin Slusarz wrote:
> I found it in XFS only. Did I miss something?

These helpers come from ocfs2 which has both be and le variants.

> be32_add is shorter than be32_add_cpu but I think it's not clear
> whether second parameter is in native byte order or not.

Then again adding foreing endian values doesn't make much sense.

If you insist on your naming please make sure to convert ocfs and xfs
to your naming.
