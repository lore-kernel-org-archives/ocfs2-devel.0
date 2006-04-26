From: Daniel Phillips <phillips@google.com>
Date: Wed, 26 Apr 2006 09:50:13 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060425215548.GB16170@lst.de>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<20060425215548.GB16170@lst.de>
Message-ID: <444FA4C5.9010608@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Christoph Hellwig wrote:
> On Tue, Apr 25, 2006 at 11:35:53AM -0700, Mark Fasheh wrote:
>>-Htree support
> 
> Please not.  htree is just the worst possible directory format around.
> Do some nice hashed or btree directories, but don't try this odd hack
> again.

Could you be specific about what you think is odd about it?

> Especially as the only reason it was developed for in ext2/3
> doesn't work very well in a cluster filesystem anyway

In what way?

 > to access the
> new htree all nodes would have to support the format anyway, so the
> whole easy up/downgrade thing doesn't matter at all.

Good point, and this only affects the leaf node format.

Regards,

Daniel
