From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:47:44 -0700
Subject: [Ocfs2-devel] [patch 05/28] ocfs2: acknowledge return value of
	ocfs2_error()
In-Reply-To: <55de3994.w2sNGV4JuorZ6zu9%akpm@linux-foundation.org>
References: <55de3994.w2sNGV4JuorZ6zu9%akpm@linux-foundation.org>
Message-ID: <20150828234744.GO1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:32PM -0700, Andrew Morton wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Subject: ocfs2: acknowledge return value of ocfs2_error()
> 
> Caveat: This may return -EROFS for a read case, which seems wrong.  This
> is happening even without this patch series though.  Should we convert
> EROFS to EIO?
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Well I realized that the error was mine and I missed this patch,

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
