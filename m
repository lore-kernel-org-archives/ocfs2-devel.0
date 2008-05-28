From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 28 May 2008 14:48:57 -0700
Subject: [Ocfs2-devel] [PATCH -next] ocfs2: fix printk format warnings
	with OCFS2_FS_STATS=n
In-Reply-To: <20080528144100.13ec8c6a.randy.dunlap@oracle.com>
References: <20080528144100.13ec8c6a.randy.dunlap@oracle.com>
Message-ID: <20080528214857.GG8325@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, May 28, 2008 at 02:41:00PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings when OCFS2_FS_STATS=n:
> 
> linux-next-20080528/fs/ocfs2/dlmglue.c: In function 'ocfs2_dlm_seq_show':
> linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'int'
> linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'int'
> linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'int'
> linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'int'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks Randy...
	--Mark

--
Mark Fasheh
