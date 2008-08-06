From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 6 Aug 2008 14:24:21 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster/netdebug.c: fix warning
In-Reply-To: <20080805205041.GD17320@orion>
References: <20080805201036.GC17320@orion>
	<20080805202948.GL22600@mail.oracle.com>
	<20080805205041.GD17320@orion>
Message-ID: <20080806212421.GX28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:50:41AM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> ocfs2/cluster/netdebug.c: fix warning
> 
> fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
>      type 'long unsigned int', but argument 17 has type 'suseconds_t'


Ok, this is in ocfs2.git now.
	--Mark

--
Mark Fasheh
