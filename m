From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 6 Aug 2008 14:23:47 -0700
Subject: [Ocfs2-devel] [2.6 patch] ocfs2/cluster/tcp.c: make some
	functions static
In-Reply-To: <20080806211112.GP1702@cs181140183.pp.htv.fi>
References: <20080806211112.GP1702@cs181140183.pp.htv.fi>
Message-ID: <20080806212347.GW28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Aug 07, 2008 at 12:11:12AM +0300, Adrian Bunk wrote:
> Commit 0f475b2abed6cbccee1da20a0bef2895eb2a0edd
> (ocfs2/net: Silence build warnings) made sense
> as far as it fixed compile warnings, but it was
> not required that it made the functions global.

Great, thanks Adrian.
	--Mark

--
Mark Fasheh
