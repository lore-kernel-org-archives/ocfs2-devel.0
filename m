From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 31 11:43:01 2007
Subject: [Ocfs2-devel] Re: [RFC][PATCH] byteorder: introduce le32_add_cpu &
	friends to core
In-Reply-To: <20071231091732.GA29043@infradead.org>
References: <20071230190619.GA13757@joi> <20071230191825.GA6447@infradead.org>
	<20071230214857.GA14177@joi> <20071231091732.GA29043@infradead.org>
Message-ID: <20071231194146.GT13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>, kernel-janitors <kernel-janitors@vger.kernel.org>

On Mon, Dec 31, 2007 at 09:17:32AM +0000, Christoph Hellwig wrote:
> > be32_add is shorter than be32_add_cpu but I think it's not clear
> > whether second parameter is in native byte order or not.
> 
> Then again adding foreing endian values doesn't make much sense.
> 
> If you insist on your naming please make sure to convert ocfs and xfs
> to your naming.

Personally, I'd rather stick with the (IMHO) more descriptive name - btw,
the ones he picked don't require any extra conversion in Ocfs2.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
