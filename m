From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 20 Aug 2008 09:26:53 -0700
Subject: [Ocfs2-devel] ocfs2-test: fix flock_unit_test for fcntl locks
In-Reply-To: <20080814040612.GH21187@wotan.suse.de>
References: <20080814040612.GH21187@wotan.suse.de>
Message-ID: <48AC45CD.6030003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Mark Fasheh wrote:
> We were expecting a failure for the same-node same-fd trylock tests when in
> fcntl mode, but fcntl locks will actually succeed for this, while flock
> locks won't. The solution is to check which locking mode we're using and
> adjust our expected return accordingly.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
>   

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
